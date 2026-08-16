import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../models/payment_transaction_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentTransactionModel>> getPaymentsForOrder(String orderId);
  Future<List<PaymentTransactionModel>> getPaymentsForCustomer(String customerId);
  Future<PaymentTransactionModel> addPayment(PaymentTransactionModel transaction);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final SupabaseClient supabaseClient;

  PaymentRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<PaymentTransactionModel>> getPaymentsForOrder(String orderId) async {
    try {
      final response = await supabaseClient
          .from('payment_transactions')
          .select()
          .eq('order_id', orderId)
          .order('created_at', ascending: false);

      final list = response as List<dynamic>;
      return list.map((json) => PaymentTransactionModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch remote payment transactions: $e');
    }
  }

  @override
  Future<List<PaymentTransactionModel>> getPaymentsForCustomer(String customerId) async {
    try {
      final response = await supabaseClient
          .from('payment_transactions')
          .select()
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      final list = response as List<dynamic>;
      return list.map((json) => PaymentTransactionModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch customer payment transactions: $e');
    }
  }

  @override
  Future<PaymentTransactionModel> addPayment(PaymentTransactionModel transaction) async {
    try {
      final response = await supabaseClient
          .from('payment_transactions')
          .upsert(transaction.toJson())
          .select()
          .single();

      return PaymentTransactionModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to add remote payment transaction: $e');
    }
  }
}
