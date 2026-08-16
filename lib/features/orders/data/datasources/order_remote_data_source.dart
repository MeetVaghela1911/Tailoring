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

  Future<String?> _getShopId() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return null;
    final shop = await client.from('shops').select('id').eq('owner_id', userId).maybeSingle();
    return shop?['id'] as String?;
  }

  Future<Map<String, String>> _getTemplateMap(String? shopId) async {
    final Map<String, String> map = {};
    if (shopId == null) return map;
    try {
      final templates = await client.from('templates').select('id, name').eq('shop_id', shopId);
      for (final t in templates) {
        if (t['id'] != null && t['name'] != null) {
          final tName = (t['name'] as String).toLowerCase().trim();
          final tId = t['id'] as String;
          map[tName] = tId;
          map[tId] = tId;
        }
      }
    } catch (_) {}
    return map;
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final shopId = await _getShopId();
    final query = shopId != null
        ? client.from('orders').select('*, customer:customers(*), items:order_items(*)').eq('shop_id', shopId).eq('is_deleted', false)
        : client.from('orders').select('*, customer:customers(*), items:order_items(*)').eq('is_deleted', false);

    final response = await query.order('created_at', ascending: false);
    return response.map((data) => OrderModel.fromJson(data)).toList();
  }

  Map<String, dynamic> _mapOrderJsonToIds(Map<String, dynamic> json, Map<String, String> templateMap) {
    if (json['garment_types'] != null && json['garment_types'] is List) {
      final rawList = json['garment_types'] as List;
      json['garment_types'] = rawList
          .map((g) => templateMap[g.toString().toLowerCase().trim()] ?? g.toString())
          .toList();
    }

    if (json['garment_quantities'] != null && json['garment_quantities'] is Map) {
      final rawMap = json['garment_quantities'] as Map;
      final Map<String, dynamic> newQuantities = {};
      rawMap.forEach((k, v) {
        final idKey = templateMap[k.toString().toLowerCase().trim()] ?? k.toString();
        newQuantities[idKey] = v;
      });
      json['garment_quantities'] = newQuantities;
    }

    if (json['garment_prices'] != null && json['garment_prices'] is Map) {
      final rawMap = json['garment_prices'] as Map;
      final Map<String, dynamic> newPrices = {};
      rawMap.forEach((k, v) {
        final idKey = templateMap[k.toString().toLowerCase().trim()] ?? k.toString();
        newPrices[idKey] = v;
      });
      json['garment_prices'] = newPrices;
    }

    if (json['measurement_notes'] != null && json['measurement_notes'] is Map) {
      final rawMap = json['measurement_notes'] as Map;
      final Map<String, dynamic> newNotes = {};
      rawMap.forEach((k, v) {
        final idKey = templateMap[k.toString().toLowerCase().trim()] ?? k.toString();
        newNotes[idKey] = v;
      });
      json['measurement_notes'] = newNotes;
    }

    json['measurements'] = {};

    return json;
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    var json = order.toJson();
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

    final shopId = json['shop_id'] as String?;
    final templateMap = await _getTemplateMap(shopId);

    json = _mapOrderJsonToIds(json, templateMap);

    final itemsData = json.remove('items');
    final response = await client.from('orders').upsert(json).select().single();
    final orderId = response['id'] as String;

    if (itemsData != null && itemsData is List && itemsData.isNotEmpty) {
      for (var item in itemsData) {
        item['order_id'] = orderId;
        if (item['template_id'] == null && item['garment_name'] != null) {
          final gName = (item['garment_name'] as String).toLowerCase().trim();
          item['template_id'] = templateMap[gName];
        }
        await client.from('order_items').upsert(item);
      }
    } else {
      for (final type in order.garmentTypes) {
        final price = order.garmentPrices[type] ?? order.garmentPrices.entries.where((e) => e.key.trim().toLowerCase() == type.trim().toLowerCase()).firstOrNull?.value ?? 0.0;
        final qty = order.garmentQuantities[type] ?? order.garmentQuantities.entries.where((e) => e.key.trim().toLowerCase() == type.trim().toLowerCase()).firstOrNull?.value ?? 1;
        final matchedTemplateId = templateMap[type.toLowerCase().trim()];
        final gMeas = order.measurements[type] ??
            (matchedTemplateId != null ? order.measurements[matchedTemplateId] : null) ??
            order.measurements.entries.where((e) => e.key.trim().toLowerCase() == type.trim().toLowerCase()).firstOrNull?.value ??
            '';
        final gNote = order.measurementNotes[type] ??
            (matchedTemplateId != null ? order.measurementNotes[matchedTemplateId] : null) ??
            order.measurementNotes.entries.where((e) => e.key.trim().toLowerCase() == type.trim().toLowerCase()).firstOrNull?.value ??
            '';

        final Map<String, String> measMap = {type: gMeas};
        final Map<String, String> noteMap = {type: gNote};
        if (matchedTemplateId != null && matchedTemplateId.isNotEmpty) {
          measMap[matchedTemplateId] = gMeas;
          noteMap[matchedTemplateId] = gNote;
        }

        await client.from('order_items').upsert({
          'order_id': orderId,
          'template_id': matchedTemplateId,
          'garment_name': type,
          'quantity': qty,
          'unit_price': price,
          'measurements': measMap,
          'measurement_notes': noteMap,
        });
      }
    }

    final fullOrder = await client
        .from('orders')
        .select('*, customer:customers(*), items:order_items(*)')
        .eq('id', orderId)
        .single();
    return OrderModel.fromJson(fullOrder);
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    var json = order.toJson();
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

    final shopId = json['shop_id'] as String?;
    final templateMap = await _getTemplateMap(shopId);

    json = _mapOrderJsonToIds(json, templateMap);

    final itemsData = json.remove('items');
    final response = await client
        .from('orders')
        .update(json)
        .eq('id', order.id)
        .select()
        .single();
    final orderId = response['id'] as String;

    if (itemsData != null && itemsData is List && itemsData.isNotEmpty) {
      await client.from('order_items').delete().eq('order_id', orderId);
      for (var item in itemsData) {
        item['order_id'] = orderId;
        if (item['template_id'] == null && item['garment_name'] != null) {
          final gName = (item['garment_name'] as String).toLowerCase().trim();
          item['template_id'] = templateMap[gName];
        }
        await client.from('order_items').upsert(item);
      }
    } else {
      await client.from('order_items').delete().eq('order_id', orderId);
      for (final type in order.garmentTypes) {
        final price = order.garmentPrices[type] ?? order.garmentPrices.entries.where((e) => e.key.trim().toLowerCase() == type.trim().toLowerCase()).firstOrNull?.value ?? 0.0;
        final qty = order.garmentQuantities[type] ?? order.garmentQuantities.entries.where((e) => e.key.trim().toLowerCase() == type.trim().toLowerCase()).firstOrNull?.value ?? 1;
        final matchedTemplateId = templateMap[type.toLowerCase().trim()];
        final gMeas = order.measurements[type] ??
            (matchedTemplateId != null ? order.measurements[matchedTemplateId] : null) ??
            order.measurements.entries.where((e) => e.key.trim().toLowerCase() == type.trim().toLowerCase()).firstOrNull?.value ??
            '';
        final gNote = order.measurementNotes[type] ??
            (matchedTemplateId != null ? order.measurementNotes[matchedTemplateId] : null) ??
            order.measurementNotes.entries.where((e) => e.key.trim().toLowerCase() == type.trim().toLowerCase()).firstOrNull?.value ??
            '';

        final Map<String, String> measMap = {type: gMeas};
        final Map<String, String> noteMap = {type: gNote};
        if (matchedTemplateId != null && matchedTemplateId.isNotEmpty) {
          measMap[matchedTemplateId] = gMeas;
          noteMap[matchedTemplateId] = gNote;
        }

        await client.from('order_items').upsert({
          'order_id': orderId,
          'template_id': matchedTemplateId,
          'garment_name': type,
          'quantity': qty,
          'unit_price': price,
          'measurements': measMap,
          'measurement_notes': noteMap,
        });
      }
    }

    final fullOrder = await client
        .from('orders')
        .select('*, customer:customers(*), items:order_items(*)')
        .eq('id', orderId)
        .single();
    return OrderModel.fromJson(fullOrder);
  }

  @override
  Future<void> deleteOrder(String id) async {
    await client.from('orders').update({'is_deleted': true}).eq('id', id);
  }

  @override
  Future<OrderModel?> getOrderById(String id) async {
    final response = await client
        .from('orders')
        .select('*, customer:customers(*), items:order_items(*)')
        .eq('id', id)
        .single();
    return OrderModel.fromJson(response);
  }
}
