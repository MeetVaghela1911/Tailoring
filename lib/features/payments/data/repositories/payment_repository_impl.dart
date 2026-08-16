import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../orders/data/datasources/order_local_data_source.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../datasources/payment_local_data_source.dart';
import '../datasources/payment_remote_data_source.dart';
import '../models/payment_transaction_model.dart';
import '../../domain/entities/payment_transaction.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource localDataSource;
  final PaymentRemoteDataSource remoteDataSource;
  final OrderLocalDataSource orderLocalDataSource;
  final NetworkInfo networkInfo;
  final Uuid _uuid = const Uuid();

  PaymentRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.orderLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PaymentTransaction>>> getPaymentsForOrder(String orderId) async {
    try {
      final localPayments = await localDataSource.getPaymentsForOrder(orderId);
      return Right(localPayments.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Failed to load payments for order: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentTransaction>>> getPaymentsForCustomer(String customerId) async {
    try {
      final localPayments = await localDataSource.getPaymentsForCustomer(customerId);
      return Right(localPayments.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Failed to load payments for customer: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentTransaction>> addPayment({
    required String orderId,
    String? customerId,
    String? customerName,
    String? customerPhone,
    required double amount,
    required int paymentMode,
    String? paymentModeName,
    String? paymentStage,
    String? notes,
    String? referenceNumber,
  }) async {
    try {
      final modeName = paymentModeName ?? (paymentMode == 1 ? 'Cash' : paymentMode == 2 ? 'Card' : 'UPI / Online');
      final model = PaymentTransactionModel(
        id: _uuid.v4(),
        orderId: orderId,
        customerId: customerId,
        customerName: customerName,
        customerPhone: customerPhone,
        amount: amount,
        paymentMode: paymentMode,
        paymentModeName: modeName,
        paymentStage: paymentStage ?? 'Partial Payment',
        notes: notes,
        referenceNumber: referenceNumber,
        createdAt: DateTime.now(),
      );

      final savedModel = await localDataSource.addPayment(model);

      // Dynamically update the Order's total advancePaid locally
      final order = await orderLocalDataSource.getOrderById(orderId);
      if (order != null) {
        final updatedOrder = order.copyWith(
          advancePaid: order.advancePaid + amount,
          paymentMode: paymentMode,
        );
        await orderLocalDataSource.updateOrder(OrderModel.fromEntity(updatedOrder));
      }

      // Sync remotely if connected
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.addPayment(savedModel);
          await localDataSource.markAsSynced(savedModel.id);
        } catch (_) {}
      }

      return Right(savedModel.toEntity());
    } catch (e) {
      return Left(CacheFailure('Failed to record payment transaction: $e'));
    }
  }

  @override
  Future<Either<Failure, CustomerKhataSummary>> getCustomerKhataSummary(String customerId) async {
    try {
      final orders = await orderLocalDataSource.getOrdersByCustomer(customerId);
      final payments = await localDataSource.getPaymentsForCustomer(customerId);

      double totalVolume = 0.0;
      double totalPaid = 0.0;

      for (var o in orders) {
        totalVolume += o.totalAmount;
      }

      for (var p in payments) {
        totalPaid += p.amount;
      }

      for (var o in orders) {
        final orderPaymentsSum = payments.where((p) => p.orderId == o.id).fold(0.0, (s, p) => s + p.amount);
        if (o.advancePaid > orderPaymentsSum) {
          totalPaid += (o.advancePaid - orderPaymentsSum);
        }
      }

      final outstanding = (totalVolume - totalPaid).clamp(0.0, double.infinity);
      final firstOrder = orders.isNotEmpty ? orders.first : null;

      return Right(CustomerKhataSummary(
        customerId: customerId,
        customerName: firstOrder?.customerName,
        customerPhone: firstOrder?.customerPhone,
        totalOrdersCount: orders.length,
        totalOrderVolume: totalVolume,
        totalPaidAmount: totalPaid,
        totalOutstandingDue: outstanding,
      ));
    } catch (e) {
      return Left(CacheFailure('Failed to generate customer Khata summary: $e'));
    }
  }

  @override
  Future<Either<Failure, DailyCashbookSummary>> getDailyCashbookSummary() async {
    try {
      final allPayments = await localDataSource.getAllPayments();
      final allOrders = await orderLocalDataSource.getOrders();

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final todayPayments = allPayments.where((p) =>
          p.createdAt.isAfter(todayStart) && p.createdAt.isBefore(todayEnd)).toList();

      double cash = 0.0;
      double upi = 0.0;
      double card = 0.0;

      for (var p in todayPayments) {
        if (p.paymentMode == 1) {
          cash += p.amount;
        } else if (p.paymentMode == 2) {
          card += p.amount;
        } else {
          upi += p.amount;
        }
      }

      double totalCollected = cash + upi + card;

      double pending = 0.0;
      for (var o in allOrders) {
        if (o.status != 'DELIVERED' && o.balanceDue > 0) {
          pending += o.balanceDue;
        }
      }

      return Right(DailyCashbookSummary(
        date: now,
        totalCollected: totalCollected,
        cashCollected: cash,
        upiCollected: upi,
        cardCollected: card,
        pendingReceivables: pending,
      ));
    } catch (e) {
      return Left(CacheFailure('Failed to compute daily cashbook summary: $e'));
    }
  }

  @override
  Future<Either<Failure, FilteredFinanceSummary>> getFilteredFinanceSummary({
    DateTime? startDate,
    DateTime? endDate,
    String filterName = 'This Month',
  }) async {
    try {
      final allPayments = await localDataSource.getAllPayments();
      final allOrders = await orderLocalDataSource.getOrders();

      final now = DateTime.now();
      DateTime start = startDate ?? DateTime(now.year, now.month, 1);
      DateTime end = endDate ?? DateTime(now.year, now.month + 1, 1).subtract(const Duration(milliseconds: 1));

      // Filter explicit payment transactions within date range
      final filteredPayments = allPayments.where((p) {
        return p.createdAt.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
            p.createdAt.isBefore(end.add(const Duration(milliseconds: 1)));
      }).toList();

      // Filter orders created or active within date range
      final filteredOrders = allOrders.where((o) {
        return o.createdAt.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
            o.createdAt.isBefore(end.add(const Duration(milliseconds: 1)));
      }).toList();

      // Create a master list of all payment transactions including initial advances recorded on orders
      final List<PaymentTransaction> allTxns = filteredPayments.map((p) => p.toEntity()).toList();

      double cash = 0.0;
      double upi = 0.0;
      double card = 0.0;

      for (var p in filteredPayments) {
        if (p.paymentMode == 1) {
          cash += p.amount;
        } else if (p.paymentMode == 2) {
          card += p.amount;
        } else {
          upi += p.amount;
        }
      }

      // Synthesize initial advance payment transactions for orders created in date range if not captured in payment_transactions table
      for (var o in filteredOrders) {
        final orderPaymentsSum = filteredPayments.where((p) => p.orderId == o.id).fold(0.0, (s, p) => s + p.amount);
        if (o.advancePaid > orderPaymentsSum) {
          final diff = o.advancePaid - orderPaymentsSum;
          if (o.paymentMode == 1) {
            cash += diff;
          } else if (o.paymentMode == 2) {
            card += diff;
          } else {
            upi += diff;
          }

          final modeName = o.paymentMode == 1 ? 'Cash' : o.paymentMode == 2 ? 'Card' : 'UPI / Online';
          allTxns.add(
            PaymentTransaction(
              id: 'adv-${o.id}',
              orderId: o.id,
              customerId: o.customerId,
              customerName: o.customerName,
              customerPhone: o.customerPhone,
              amount: diff,
              paymentMode: o.paymentMode,
              paymentModeName: modeName,
              paymentStage: 'Advance',
              createdAt: o.createdAt,
            ),
          );
        }
      }

      // Sort payment history transactions descending by date
      allTxns.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final double totalCollected = cash + upi + card;

      // Calculate pending receivables across all orders in filtered range
      double pendingDues = 0.0;
      final List<OrderEntity> pendingOrders = [];
      for (var o in allOrders) {
        final isInRange = o.createdAt.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
            o.createdAt.isBefore(end.add(const Duration(milliseconds: 1)));
        if (o.balanceDue > 0 && (isInRange || filterName == 'This Month' || filterName == 'Today')) {
          pendingDues += o.balanceDue;
          pendingOrders.add(o.toEntity());
        }
      }

      final double estimatedTotal = totalCollected + pendingDues;
      final double efficiency = estimatedTotal > 0 ? (totalCollected / estimatedTotal) * 100 : 100.0;

      return Right(FilteredFinanceSummary(
        startDate: start,
        endDate: end,
        filterName: filterName,
        totalCollected: totalCollected,
        cashCollected: cash,
        upiCollected: upi,
        cardCollected: card,
        pendingReceivables: pendingDues,
        estimatedTotalRevenue: estimatedTotal,
        collectionEfficiency: efficiency,
        transactions: allTxns,
        pendingOrders: pendingOrders,
      ));
    } catch (e) {
      return Left(CacheFailure('Failed to generate filtered finance summary: $e'));
    }
  }
}
