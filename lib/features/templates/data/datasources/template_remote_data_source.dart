import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/template_model.dart';

abstract class TemplateRemoteDataSource {
  Future<List<TemplateModel>> getTemplates();
  Future<TemplateModel> addTemplate(TemplateModel template);
  Future<TemplateModel> updateTemplate(TemplateModel template);
  Future<void> deleteTemplate(String id);
}

class SupabaseTemplateRemoteDataSource implements TemplateRemoteDataSource {
  final SupabaseClient client;

  SupabaseTemplateRemoteDataSource(this.client);

  Future<String?> _getShopId() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return null;
    final shop = await client.from('shops').select('id').eq('owner_id', userId).maybeSingle();
    return shop?['id'] as String?;
  }

  @override
  Future<List<TemplateModel>> getTemplates() async {
    final shopId = await _getShopId();
    final query = shopId != null
        ? client.from('templates').select().eq('shop_id', shopId)
        : client.from('templates').select();

    final response = await query.order('name', ascending: true);
    return response.map((data) => TemplateModel.fromJson(data)).toList();
  }

  @override
  Future<TemplateModel> addTemplate(TemplateModel template) async {
    var json = template.toJson();
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
    final response = await client.from('templates').upsert(json).select().single();
    return TemplateModel.fromJson(response);
  }

  @override
  Future<TemplateModel> updateTemplate(TemplateModel template) async {
    var json = template.toJson();
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
        .from('templates')
        .update(json)
        .eq('id', template.id)
        .select()
        .single();
    return TemplateModel.fromJson(response);
  }

  @override
  Future<void> deleteTemplate(String id) async {
    await client.from('templates').delete().eq('id', id);
  }
}
