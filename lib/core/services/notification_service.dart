import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import '../../features/orders/domain/entities/order_entity.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint('Notification clicked: ${details.payload}');
        },
      );

      // Request Android 13+ permission
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'stitch_alerts_channel',
      'Stitch Order Alerts',
      channelDescription: 'Notifications for order progress, due dates, and pending payments',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const darwinDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notificationsPlugin.show(id, title, body, details, payload: payload);
  }

  /// Evaluates active orders and triggers instant alerts for conditions met
  Future<void> evaluateAndNotifyOrders(List<OrderEntity> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    for (final order in orders) {
      final orderShortId = order.id.length > 6 ? order.id.substring(0, 6) : order.id;
      final custName = order.customerName ?? 'Customer';

      // 1. DELIVERED with Pending Payment (every 2 days)
      if (order.status == 'DELIVERED' && order.balanceDue > 0) {
        final lastNotifiedKey = 'notif_payment_pending_${order.id}';
        final lastNotifiedMillis = prefs.getInt(lastNotifiedKey) ?? 0;
        final lastNotifiedDate = DateTime.fromMillisecondsSinceEpoch(lastNotifiedMillis);

        if (now.difference(lastNotifiedDate).inHours >= 48) {
          await showNotification(
            id: (order.id.hashCode + 100).abs() % 100000,
            title: '💳 Payment Pending Notice',
            body: 'Order #$orderShortId ($custName) was delivered, but ₹${order.balanceDue.toStringAsFixed(0)} payment is still pending.',
            payload: order.id,
          );
          await prefs.setInt(lastNotifiedKey, now.millisecondsSinceEpoch);
        }
      }

      // Skip completed / delivered orders for operational alerts
      if (order.status == 'DELIVERED') continue;

      // 2. Overdue Order Alert
      if (order.deliveryDate != null && now.isAfter(order.deliveryDate!)) {
        final daysOverdue = now.difference(order.deliveryDate!).inDays;
        final overdueDaysText = daysOverdue <= 0 ? '1' : '$daysOverdue';
        final lastNotifiedKey = 'notif_overdue_${order.id}';
        final lastNotifiedMillis = prefs.getInt(lastNotifiedKey) ?? 0;
        final lastNotifiedDate = DateTime.fromMillisecondsSinceEpoch(lastNotifiedMillis);

        if (now.difference(lastNotifiedDate).inHours >= 24) {
          await showNotification(
            id: (order.id.hashCode + 200).abs() % 100000,
            title: '🚨 Order Overdue Alert',
            body: 'Order #$orderShortId ($custName) is OVERDUE by $overdueDaysText day(s)! Delivery date was ${order.deliveryDate!.day}/${order.deliveryDate!.month}.',
            payload: order.id,
          );
          await prefs.setInt(lastNotifiedKey, now.millisecondsSinceEpoch);
        }
        continue;
      }

      // 3. Due Tomorrow Alert
      if (order.deliveryDate != null) {
        final hoursUntilDelivery = order.deliveryDate!.difference(now).inHours;
        if (hoursUntilDelivery > 0 && hoursUntilDelivery <= 24) {
          final lastNotifiedKey = 'notif_due_tomorrow_${order.id}';
          final lastNotifiedMillis = prefs.getInt(lastNotifiedKey) ?? 0;

          if (lastNotifiedMillis == 0) {
            await showNotification(
              id: (order.id.hashCode + 300).abs() % 100000,
              title: '⏰ Order Due Tomorrow',
              body: 'Order #$orderShortId ($custName) is due TOMORROW! Status: ${order.status}.',
              payload: order.id,
            );
            await prefs.setInt(lastNotifiedKey, now.millisecondsSinceEpoch);
          }
        }
      }

      // 4. Halfway Elapsed & Still NOT STARTED
      if (order.status == 'NOT STARTED' && order.deliveryDate != null) {
        final totalDuration = order.deliveryDate!.difference(order.createdAt).inHours;
        final elapsedDuration = now.difference(order.createdAt).inHours;

        if (totalDuration > 0 && elapsedDuration >= (totalDuration / 2)) {
          final lastNotifiedKey = 'notif_halfway_${order.id}';
          final lastNotifiedMillis = prefs.getInt(lastNotifiedKey) ?? 0;

          if (lastNotifiedMillis == 0) {
            await showNotification(
              id: (order.id.hashCode + 400).abs() % 100000,
              title: '⚠️ Order Work Delay Warning',
              body: 'Order #$orderShortId ($custName) is halfway to delivery, but status is still NOT STARTED. Please update status!',
              payload: order.id,
            );
            await prefs.setInt(lastNotifiedKey, now.millisecondsSinceEpoch);
          }
        }
      }

      // 5. Stagnant IN PROGRESS Alert (> 2 days in progress)
      if (order.status == 'IN PROGRESS') {
        final daysInProgress = now.difference(order.createdAt).inDays;
        if (daysInProgress >= 2) {
          final lastNotifiedKey = 'notif_stagnant_${order.id}';
          final lastNotifiedMillis = prefs.getInt(lastNotifiedKey) ?? 0;
          final lastNotifiedDate = DateTime.fromMillisecondsSinceEpoch(lastNotifiedMillis);

          if (now.difference(lastNotifiedDate).inHours >= 48) {
            await showNotification(
              id: (order.id.hashCode + 500).abs() % 100000,
              title: '✂️ In-Progress Order Reminder',
              body: 'Order #$orderShortId ($custName) has been IN PROGRESS for 2+ days. Please check status or mark as READY.',
              payload: order.id,
            );
            await prefs.setInt(lastNotifiedKey, now.millisecondsSinceEpoch);
          }
        }
      }
    }
  }

  Future<void> cancelOrderNotifications(String orderId) async {
    final notificationId = (orderId.hashCode).abs() % 100000;
    await _notificationsPlugin.cancel(notificationId);
  }
}
