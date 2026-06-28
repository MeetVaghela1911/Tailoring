import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrder(OrderModel order);
  Future<void> deleteOrder(String id);
  Future<OrderModel?> getOrderById(String id);
}

class SupabaseOrderRemoteDataSource implements OrderRemoteDataSource {
  final SupabaseClient client;

  SupabaseOrderRemoteDataSource(this.client);

  @override
  Future<List<OrderModel>> getOrders() async {
    final response = await client.from('orders').select().order('created_at', ascending: false);
    return response.map((data) => OrderModel.fromJson(data)).toList();
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final response = await client.from('orders').upsert(order.toJson()).select().single();
    return OrderModel.fromJson(response);
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    final response = await client
        .from('orders')
        .update(order.toJson())
        .eq('id', order.id)
        .select()
        .single();
    return OrderModel.fromJson(response);
  }

  @override
  Future<void> deleteOrder(String id) async {
    await client.from('orders').delete().eq('id', id);
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    final response = await client.from('orders').select().eq('id', id).single();
    return OrderModel.fromJson(response);
  }
}
