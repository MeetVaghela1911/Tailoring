import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getCustomers();
  Future<CustomerModel> addCustomer(CustomerModel customer);
  Future<CustomerModel> updateCustomer(CustomerModel customer);
  Future<void> deleteCustomer(String id);
  Future<CustomerModel?> getCustomerById(String id);
}

class SupabaseCustomerRemoteDataSource implements CustomerRemoteDataSource {
  final SupabaseClient client;

  SupabaseCustomerRemoteDataSource(this.client);

  Future<String?> _getShopId() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return null;
    final shop = await client.from('shops').select('id').eq('owner_id', userId).maybeSingle();
    return shop?['id'] as String?;
  }

  @override
  Future<List<CustomerModel>> getCustomers() async {
    final shopId = await _getShopId();
    final query = shopId != null 
        ? client.from('customers').select().eq('shop_id', shopId).eq('is_deleted', false)
        : client.from('customers').select().eq('is_deleted', false);
    
    final response = await query.order('created_at', ascending: false);
    return response.map((data) => CustomerModel.fromJson(data)).toList();
  }

  @override
  Future<CustomerModel> addCustomer(CustomerModel customer) async {
    var json = customer.toJson();
    final userId = client.auth.currentUser?.id;
    if (userId != null) {
      json['user_id'] = userId;
    }
    if (json['shop_id'] == null) {
      final shopId = await _getShopId();
      if (shopId != null) {
        json['shop_id'] = shopId;
      }
    }
    final response = await client.from('customers').upsert(json).select().single();
    return CustomerModel.fromJson(response);
  }

  @override
  Future<CustomerModel> updateCustomer(CustomerModel customer) async {
    var json = customer.toJson();
    final userId = client.auth.currentUser?.id;
    if (userId != null) {
      json['user_id'] = userId;
    }
    if (json['shop_id'] == null) {
      final shopId = await _getShopId();
      if (shopId != null) {
        json['shop_id'] = shopId;
      }
    }
    final response = await client
        .from('customers')
        .update(json)
        .eq('id', customer.id)
        .select()
        .single();
    return CustomerModel.fromJson(response);
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await client.from('customers').update({'is_deleted': true}).eq('id', id);
  }

  @override
  Future<CustomerModel?> getCustomerById(String id) async {
    final response = await client.from('customers').select().eq('id', id).single();
    return CustomerModel.fromJson(response);
  }
}
