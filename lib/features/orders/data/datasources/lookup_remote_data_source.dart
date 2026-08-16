import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_priority_model.dart';
import '../models/payment_mode_model.dart';

abstract class LookupRemoteDataSource {
  Future<List<OrderPriorityModel>> getOrderPriorities();
  Future<List<PaymentModeModel>> getPaymentModes();
  Future<List<String>> getPaymentStages();
  Future<Map<String, String>> getWhatsAppMasterTemplates();
}

class SupabaseLookupRemoteDataSource implements LookupRemoteDataSource {
  final SupabaseClient client;

  SupabaseLookupRemoteDataSource(this.client);

  @override
  Future<List<OrderPriorityModel>> getOrderPriorities() async {
    try {
      final response = await client
          .from('order_priorities')
          .select()
          .eq('is_active', true)
          .order('display_order', ascending: true);
      return response.map((data) => OrderPriorityModel.fromJson(data)).toList();
    } catch (_) {
      return const [
        OrderPriorityModel(id: 1, name: 'Normal', colorHex: '#4CAF50', displayOrder: 1),
        OrderPriorityModel(id: 2, name: 'High', colorHex: '#FF9800', displayOrder: 2),
        OrderPriorityModel(id: 3, name: 'Urgent', colorHex: '#F44336', displayOrder: 3),
      ];
    }
  }

  @override
  Future<List<PaymentModeModel>> getPaymentModes() async {
    try {
      final response = await client
          .from('payment_modes')
          .select()
          .eq('is_active', true)
          .order('id', ascending: true);
      return response.map((data) => PaymentModeModel.fromJson(data)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<String>> getPaymentStages() async {
    try {
      final response = await client
          .from('payment_stages')
          .select()
          .eq('is_active', true)
          .order('display_order', ascending: true);
      return response.map((e) => e['name'].toString()).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Map<String, String>> getWhatsAppMasterTemplates() async {
    try {
      final response = await client
          .from('whatsapp_templates')
          .select()
          .eq('is_active', true);
      final Map<String, String> result = {};
      for (final item in response) {
        if (item['template_key'] != null && item['content'] != null) {
          result[item['template_key'].toString()] = item['content'].toString();
        }
      }
      return result;
    } catch (_) {
      return {};
    }
  }
}
