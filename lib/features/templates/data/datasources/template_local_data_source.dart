import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/local_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/template_local_model.dart';
import '../models/template_model.dart';

abstract class TemplateLocalDataSource {
  Future<List<TemplateModel>> getTemplates();
  Future<List<TemplateModel>> getTemplatesByCategory(String category);
  Future<TemplateModel> addTemplate(TemplateModel template);
  Future<TemplateModel> updateTemplate(TemplateModel template);
  Future<void> deleteTemplate(String id);
  Future<List<TemplateLocalModel>> getUnsyncedTemplates();
  Future<void> markAsSynced(String id);
  Future<void> upsertTemplates(List<TemplateModel> templates);
}

class TemplateLocalDataSourceImpl implements TemplateLocalDataSource {
  final LocalDatabase localDb;
  final Uuid _uuid = const Uuid();

  TemplateLocalDataSourceImpl({required this.localDb});

  @override
  Future<List<TemplateModel>> getTemplates() async {
    try {
      final templates = await localDb.isar.templateLocalModels.where().findAll();
      return templates.map(_toTemplateModel).toList();
    } catch (e) {
      throw CacheException('Failed to fetch templates from local database: $e');
    }
  }

  @override
  Future<List<TemplateModel>> getTemplatesByCategory(String category) async {
    final templates = await localDb.isar.templateLocalModels.filter().categoryEqualTo(category).findAll();
    return templates.map(_toTemplateModel).toList();
  }

  @override
  Future<TemplateModel> addTemplate(TemplateModel template) async {
    final String remoteId = template.id.isEmpty ? _uuid.v4() : template.id;

    final localModel = TemplateLocalModel()
      ..remoteId = remoteId
      ..name = template.name
      ..category = template.category
      ..iconCodePoint = template.iconCodePoint
      ..iconFontFamily = template.iconFontFamily
      ..fields = template.fields
      ..basePrice = template.basePrice
      ..isSynced = false
      ..lastUpdated = DateTime.now();

    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.templateLocalModels.put(localModel);
      });
    } catch (e) {
      throw CacheException('Failed to add template to local database: $e');
    }

    return _toTemplateModel(localModel);
  }

  @override
  Future<TemplateModel> updateTemplate(TemplateModel template) async {
    final existingLocal = await localDb.isar.templateLocalModels.filter().remoteIdEqualTo(template.id).findFirst();
    
    if (existingLocal == null) {
      throw Exception('Template not found in local database');
    }

    existingLocal
      ..name = template.name
      ..category = template.category
      ..iconCodePoint = template.iconCodePoint
      ..iconFontFamily = template.iconFontFamily
      ..fields = template.fields
      ..basePrice = template.basePrice
      ..isSynced = false
      ..lastUpdated = DateTime.now();

    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.templateLocalModels.put(existingLocal);
      });
    } catch (e) {
      throw CacheException('Failed to update template in local database: $e');
    }

    return _toTemplateModel(existingLocal);
  }

  @override
  Future<void> deleteTemplate(String id) async {
    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.templateLocalModels.filter().remoteIdEqualTo(id).deleteAll();
      });
    } catch (e) {
      throw CacheException('Failed to delete template from local database: $e');
    }
  }

  @override
  Future<List<TemplateLocalModel>> getUnsyncedTemplates() async {
    return await localDb.isar.templateLocalModels.filter().isSyncedEqualTo(false).findAll();
  }

  @override
  Future<void> markAsSynced(String id) async {
    final template = await localDb.isar.templateLocalModels.filter().remoteIdEqualTo(id).findFirst();
    if (template != null) {
      template.isSynced = true;
      await localDb.isar.writeTxn(() async {
        await localDb.isar.templateLocalModels.put(template);
      });
    }
  }

  TemplateModel _toTemplateModel(TemplateLocalModel local) {
    return TemplateModel(
      id: local.remoteId,
      name: local.name,
      category: local.category,
      iconCodePoint: local.iconCodePoint,
      iconFontFamily: local.iconFontFamily,
      fields: local.fields,
      basePrice: local.basePrice,
    );
  }

  @override
  Future<void> upsertTemplates(List<TemplateModel> templates) async {
    final localModels = templates.map((t) {
      return TemplateLocalModel()
        ..remoteId = t.id.isEmpty ? _uuid.v4() : t.id
        ..name = t.name
        ..category = t.category
        ..iconCodePoint = t.iconCodePoint
        ..iconFontFamily = t.iconFontFamily
        ..fields = t.fields
        ..basePrice = t.basePrice
        ..isSynced = true
        ..lastUpdated = DateTime.now();
    }).toList();

    await localDb.isar.writeTxn(() async {
      for (final localModel in localModels) {
        final existingLocal = await localDb.isar.templateLocalModels
            .filter()
            .remoteIdEqualTo(localModel.remoteId)
            .findFirst();
        
        if (existingLocal != null) {
          localModel.id = existingLocal.id;
        }
        await localDb.isar.templateLocalModels.put(localModel);
      }
    });
  }
}
