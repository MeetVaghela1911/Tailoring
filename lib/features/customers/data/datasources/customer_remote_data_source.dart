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

  @override
  Future<List<CustomerModel>> getCustomers() async {
    final response = await client.from('customers').select().order('created_at', ascending: false);
    return response.map((data) => CustomerModel.fromJson(data)).toList();
  }

  @override
  Future<CustomerModel> addCustomer(CustomerModel customer) async {
    final response = await client.from('customers').upsert(customer.toJson()).select().single();
    return CustomerModel.fromJson(response);
  }

  @override
  Future<CustomerModel> updateCustomer(CustomerModel customer) async {
    final response = await client
        .from('customers')
        .update(customer.toJson())
        .eq('id', customer.id)
        .select()
        .single();
    return CustomerModel.fromJson(response);
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await client.from('customers').delete().eq('id', id);
  }

  @override
  Future<CustomerModel?> getCustomerById(String id) async {
    final response = await client.from('customers').select().eq('id', id).single();
    return CustomerModel.fromJson(response);
  }
}
