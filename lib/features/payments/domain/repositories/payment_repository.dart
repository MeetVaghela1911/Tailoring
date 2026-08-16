import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../entities/payment_transaction.dart';

class CustomerKhataSummary {
  final String customerId;
  final String? customerName;
  final String? customerPhone;
  final int totalOrdersCount;
  final double totalOrderVolume;
  final double totalPaidAmount;
  final double totalOutstandingDue;

  const CustomerKhataSummary({
    required this.customerId,
    this.customerName,
    this.customerPhone,
    required this.totalOrdersCount,
    required this.totalOrderVolume,
    required this.totalPaidAmount,
    required this.totalOutstandingDue,
  });
}

class DailyCashbookSummary {
  final DateTime date;
  final double totalCollected;
  final double cashCollected;
  final double upiCollected;
  final double cardCollected;
  final double pendingReceivables;

  const DailyCashbookSummary({
    required this.date,
    required this.totalCollected,
    required this.cashCollected,
    required this.upiCollected,
    required this.cardCollected,
    required this.pendingReceivables,
  });
}

class FilteredFinanceSummary {
  final DateTime? startDate;
  final DateTime? endDate;
  final String filterName;
  final double totalCollected;
  final double cashCollected;
  final double upiCollected;
  final double cardCollected;
  final double pendingReceivables;
  final double estimatedTotalRevenue;
  final double collectionEfficiency; // 0 to 100%
  final List<PaymentTransaction> transactions;
  final List<OrderEntity> pendingOrders;

  const FilteredFinanceSummary({
    this.startDate,
    this.endDate,
    required this.filterName,
    required this.totalCollected,
    required this.cashCollected,
    required this.upiCollected,
    required this.cardCollected,
    required this.pendingReceivables,
    required this.estimatedTotalRevenue,
    required this.collectionEfficiency,
    required this.transactions,
    required this.pendingOrders,
  });
}

abstract class PaymentRepository {
  Future<Either<Failure, List<PaymentTransaction>>> getPaymentsForOrder(String orderId);
  Future<Either<Failure, List<PaymentTransaction>>> getPaymentsForCustomer(String customerId);
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
  });
  Future<Either<Failure, CustomerKhataSummary>> getCustomerKhataSummary(String customerId);
  Future<Either<Failure, DailyCashbookSummary>> getDailyCashbookSummary();
  Future<Either<Failure, FilteredFinanceSummary>> getFilteredFinanceSummary({
    DateTime? startDate,
    DateTime? endDate,
    String filterName = 'This Month',
  });
}
