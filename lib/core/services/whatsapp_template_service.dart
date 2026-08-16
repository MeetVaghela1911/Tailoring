import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import '../utility/dependency_injection.dart';

enum WhatsAppTemplateType {
  invoice,
  stitchingStarted,
  trialReady,
  readyForPickup,
  delivered,
  paymentReminder,
  deliveryUpdate,
  custom,
}

class WhatsAppTemplateOption {
  final WhatsAppTemplateType type;
  final String title;
  final String description;
  final IconData icon;
  final Color themeColor;
  final bool defaultAttachPdf;

  const WhatsAppTemplateOption({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.themeColor,
    this.defaultAttachPdf = false,
  });
}

class WhatsAppTemplateService {
  static const String _prefUserPrefix = 'whatsapp_user_template_';
  static const String _prefCloudPrefix = 'whatsapp_cloud_master_';

  /// In-memory cache of cloud master templates fetched from Supabase
  static final Map<WhatsAppTemplateType, String> _cloudMasterTemplates = {};

  /// Get list of supported WhatsApp message options with UI metadata
  static List<WhatsAppTemplateOption> getAvailableOptions() {
    return const [
      WhatsAppTemplateOption(
        type: WhatsAppTemplateType.invoice,
        title: 'Receipt & Invoice',
        description: 'Order receipt breakdown with PDF option',
        icon: Icons.receipt_long,
        themeColor: Color(0xFF25D366),
        defaultAttachPdf: true,
      ),
      WhatsAppTemplateOption(
        type: WhatsAppTemplateType.stitchingStarted,
        title: 'Stitching Started',
        description: 'Notify customer stitching has begun',
        icon: Icons.content_cut,
        themeColor: Color(0xFF2196F3),
        defaultAttachPdf: false,
      ),
      WhatsAppTemplateOption(
        type: WhatsAppTemplateType.trialReady,
        title: 'Fitting Trial Ready',
        description: 'Invite customer for fitting trial',
        icon: Icons.checkroom,
        themeColor: Color(0xFF9C27B0),
        defaultAttachPdf: false,
      ),
      WhatsAppTemplateOption(
        type: WhatsAppTemplateType.readyForPickup,
        title: 'Ready for Pickup',
        description: 'Order completed and ready for pickup',
        icon: Icons.mark_chat_read_outlined,
        themeColor: Color(0xFF4CAF50),
        defaultAttachPdf: false,
      ),
      WhatsAppTemplateOption(
        type: WhatsAppTemplateType.paymentReminder,
        title: 'Payment Reminder',
        description: 'Friendly reminder for pending balance',
        icon: Icons.account_balance_wallet,
        themeColor: Color(0xFFFF9800),
        defaultAttachPdf: false,
      ),
      WhatsAppTemplateOption(
        type: WhatsAppTemplateType.delivered,
        title: 'Order Delivered',
        description: 'Thank you message & review request',
        icon: Icons.sentiment_very_satisfied,
        themeColor: Color(0xFF00BCD4),
        defaultAttachPdf: false,
      ),
      WhatsAppTemplateOption(
        type: WhatsAppTemplateType.deliveryUpdate,
        title: 'Schedule Update',
        description: 'Delivery date notice or adjustment',
        icon: Icons.access_time,
        themeColor: Color(0xFFE91E63),
        defaultAttachPdf: false,
      ),
      WhatsAppTemplateOption(
        type: WhatsAppTemplateType.custom,
        title: 'Custom Message',
        description: 'Freeform message with order tags',
        icon: Icons.edit_note,
        themeColor: Color(0xFF607D8B),
        defaultAttachPdf: false,
      ),
    ];
  }

  /// Sets/updates cloud master templates fetched from Supabase and caches them locally
  static Future<void> updateCloudMasterTemplates(Map<String, String> rawCloudMap) async {
    SharedPreferences? prefs;
    try {
      if (getIt.isRegistered<SharedPreferences>()) {
        prefs = getIt<SharedPreferences>();
      }
    } catch (_) {}

    rawCloudMap.forEach((key, content) {
      final type = WhatsAppTemplateType.values.where((t) => t.name == key).firstOrNull;
      if (type != null && content.isNotEmpty) {
        _cloudMasterTemplates[type] = content;
        if (prefs != null) {
          prefs.setString('$_prefCloudPrefix${type.name}', content);
        }
      }
    });
  }

  /// Get active template pattern (User Local Override > Supabase DB Cloud Master)
  static String getActiveTemplatePattern(WhatsAppTemplateType type) {
    SharedPreferences? prefs;
    try {
      if (getIt.isRegistered<SharedPreferences>()) {
        prefs = getIt<SharedPreferences>();
      }
    } catch (_) {}

    // 1. Check local user override first
    if (prefs != null) {
      final localOverride = prefs.getString('$_prefUserPrefix${type.name}');
      if (localOverride != null && localOverride.trim().isNotEmpty) {
        return localOverride;
      }
    }

    // 2. Check in-memory Supabase Cloud Master DB template
    if (_cloudMasterTemplates.containsKey(type) && _cloudMasterTemplates[type]!.trim().isNotEmpty) {
      return _cloudMasterTemplates[type]!;
    }

    // 3. Check persistent cached Supabase Cloud Master DB template
    if (prefs != null) {
      final cloudCached = prefs.getString('$_prefCloudPrefix${type.name}');
      if (cloudCached != null && cloudCached.trim().isNotEmpty) {
        _cloudMasterTemplates[type] = cloudCached;
        return cloudCached;
      }
    }

    return '';
  }

  /// Save local user customization for a specific template type
  static Future<bool> saveLocalUserTemplate(WhatsAppTemplateType type, String customPattern) async {
    try {
      if (getIt.isRegistered<SharedPreferences>()) {
        final prefs = getIt<SharedPreferences>();
        return await prefs.setString('$_prefUserPrefix${type.name}', customPattern);
      }
    } catch (_) {}
    return false;
  }

  /// Clears local user override, restoring Supabase Cloud master template
  static Future<bool> resetLocalUserTemplate(WhatsAppTemplateType type) async {
    try {
      if (getIt.isRegistered<SharedPreferences>()) {
        final prefs = getIt<SharedPreferences>();
        return await prefs.remove('$_prefUserPrefix${type.name}');
      }
    } catch (_) {}
    return false;
  }

  /// Checks whether user has customized this template locally
  static bool hasLocalUserOverride(WhatsAppTemplateType type) {
    try {
      if (getIt.isRegistered<SharedPreferences>()) {
        final prefs = getIt<SharedPreferences>();
        final local = prefs.getString('$_prefUserPrefix${type.name}');
        return local != null && local.trim().isNotEmpty;
      }
    } catch (_) {}
    return false;
  }

  /// Generate filled message text for an order using dynamic tag placeholders
  static String generateMessageText({
    required WhatsAppTemplateType type,
    required OrderEntity order,
  }) {
    final rawPattern = getActiveTemplatePattern(type);
    if (rawPattern.isEmpty) return '';

    String shopName = 'Tailor & Co.';
    String shopPhone = '';
    try {
      if (getIt.isRegistered<AuthBloc>()) {
        final authState = getIt<AuthBloc>().state;
        if (authState is AuthAuthenticated) {
          if (authState.user.shop != null && authState.user.shop!.name.isNotEmpty) {
            shopName = authState.user.shop!.name;
          }
          if (authState.user.profile != null && authState.user.profile!.phone != null && authState.user.profile!.phone!.isNotEmpty) {
            shopPhone = authState.user.profile!.phone!;
          }
        }
      }
    } catch (_) {}

    final orderId = order.orderNumber != null
        ? '${order.orderNumber}'
        : (order.id.length > 6 ? order.id.substring(0, 6).toUpperCase() : order.id.toUpperCase());

    final custName = (order.customerName != null && order.customerName!.trim().isNotEmpty)
        ? order.customerName!
        : 'Customer';

    final deliveryDateText = order.deliveryDate != null
        ? DateFormat('dd/MM/yyyy').format(order.deliveryDate!)
        : 'To be confirmed';

    final itemsText = order.garmentTypes.isNotEmpty
        ? order.garmentTypes.join(', ')
        : 'Garments';

    return rawPattern
        .replaceAll('{customerName}', custName)
        .replaceAll('{orderId}', orderId)
        .replaceAll('{items}', itemsText)
        .replaceAll('{totalAmount}', order.totalAmount.toStringAsFixed(0))
        .replaceAll('{advancePaid}', order.advancePaid.toStringAsFixed(0))
        .replaceAll('{balanceDue}', order.balanceDue.toStringAsFixed(0))
        .replaceAll('{deliveryDate}', deliveryDateText)
        .replaceAll('{shopName}', shopName)
        .replaceAll('{shopPhone}', shopPhone);
  }

  /// Recommends the best template type based on order status and balance due
  static WhatsAppTemplateType getRecommendedTemplateForOrder(OrderEntity order) {
    final status = order.status.toUpperCase();

    if (status == 'DELIVERED') {
      if (order.balanceDue > 0) {
        return WhatsAppTemplateType.paymentReminder;
      }
      return WhatsAppTemplateType.delivered;
    } else if (status == 'READY') {
      return WhatsAppTemplateType.readyForPickup;
    } else if (status == 'IN PROGRESS') {
      return WhatsAppTemplateType.stitchingStarted;
    } else if (status == 'OVERDUE') {
      return WhatsAppTemplateType.deliveryUpdate;
    } else {
      return WhatsAppTemplateType.invoice;
    }
  }

  /// Clean and format phone number for WhatsApp URLs (`https://wa.me/<phone>`)
  static String cleanPhoneNumber(String? rawPhone) {
    if (rawPhone == null || rawPhone.isEmpty) return '';
    final rawDigits = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');
    if (rawDigits.isEmpty) return '';
    if (rawDigits.startsWith('+')) {
      return rawDigits.substring(1); // wa.me requires digits without '+'
    }
    if (rawDigits.length == 10) {
      return '91$rawDigits'; // Standard India prefix default if 10 digits
    }
    return rawDigits;
  }
}
