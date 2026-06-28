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

  @override
  Future<List<TemplateModel>> getTemplates() async {
    final response = await client.from('templates').select().order('name', ascending: true);
    return response.map((data) => TemplateModel.fromJson(data)).toList();
  }

  @override
  Future<TemplateModel> addTemplate(TemplateModel template) async {
    final response = await client.from('templates').upsert(template.toJson()).select().single();
    return TemplateModel.fromJson(response);
  }

  @override
  Future<TemplateModel> updateTemplate(TemplateModel template) async {
    final response = await client
        .from('templates')
        .update(template.toJson())
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
