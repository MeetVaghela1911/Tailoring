import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/services/plan_service.dart';
import '../../../customers/data/datasources/customer_local_data_source.dart';
import '../../../customers/data/datasources/customer_remote_data_source.dart';
import '../../../templates/data/datasources/template_local_data_source.dart';
import '../../../templates/data/datasources/template_remote_data_source.dart';
import '../../../orders/data/datasources/order_local_data_source.dart';
import '../../../orders/data/datasources/order_remote_data_source.dart';
import '../../../customers/data/models/customer_model.dart';
import '../../../templates/data/models/template_model.dart';

class SyncManager {
  final CustomerLocalDataSource customerLocal;
  final CustomerRemoteDataSource customerRemote;
  final TemplateLocalDataSource templateLocal;
  final TemplateRemoteDataSource templateRemote;
  final OrderLocalDataSource orderLocal;
  final OrderRemoteDataSource orderRemote;
  final PlanService planService;
  
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool get isSyncing => _activeSyncFuture != null;

  SyncManager({
    required this.customerLocal,
    required this.customerRemote,
    required this.templateLocal,
    required this.templateRemote,
    required this.orderLocal,
    required this.orderRemote,
    required this.planService,
    Connectivity? connectivity,
  }) : _connectivity = connectivity ?? Connectivity();

  /// Initialize the SyncManager and listen to network changes.
  void init() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        // We have network connection, try to sync
        syncData();
      }
    });
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }

  Future<void>? _activeSyncFuture;

  /// Master function for two-way synchronization
  Future<void> syncData() async {
    if (_activeSyncFuture != null) {
      debugPrint('SyncManager: Sync already in progress, awaiting existing sync...');
      return _activeSyncFuture!;
    }

    if (planService.currentPlan == AppPlan.free) {
      debugPrint('SyncManager: User is on Free plan. Cloud sync skipped.');
      return;
    }
    
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      debugPrint('SyncManager: Device is offline. Sync postponed.');
      return;
    }

    _activeSyncFuture = _performSync();
    try {
      await _activeSyncFuture;
    } finally {
      _activeSyncFuture = null;
    }
  }

  Future<void> _performSync() async {
    try {
      debugPrint('SyncManager: Starting syncData for Premium user...');

      // 1. PUSH local changes to remote
      await _pushUnsyncedData();

      // 2. PULL remote changes to local DB
      await _pullRemoteData();

      debugPrint('SyncManager: Synchronization completed successfully.');
    } catch (e, stackTrace) {
      debugPrint('SyncManager: syncData Error: $e');
      debugPrint('SyncManager: syncData StackTrace: $stackTrace');
    }
  }

  Future<void> _pushUnsyncedData() async {
    // 1. Customers
    final unsyncedCustomers = await customerLocal.getUnsyncedCustomers();
    for (final local in unsyncedCustomers) {
      final model = CustomerModel(
        id: local.remoteId, 
        name: local.name, 
        phoneNumber: local.phoneNumber,
        email: local.email,
        address: local.address,
        notes: local.notes,
        createdAt: local.createdAt,
        colorHex: local.colorHex,
        profileImageUrl: local.profileImageUrl,
      );
      try {
        await customerRemote.addCustomer(model);
        await customerLocal.markAsSynced(local.remoteId);
      } catch (e, st) {
        debugPrint('SyncManager: Failed to push customer ${local.remoteId}: $e\n$st');
      }
    }

    // 2. Templates
    final unsyncedTemplates = await templateLocal.getUnsyncedTemplates();
    for (final local in unsyncedTemplates) {
      final model = TemplateModel(
        id: local.remoteId,
        name: local.name,
        category: local.category,
        iconCodePoint: local.iconCodePoint,
        iconFontFamily: local.iconFontFamily,
        fields: local.fields,
        basePrice: local.basePrice,
      );
      try {
        await templateRemote.addTemplate(model);
        await templateLocal.markAsSynced(local.remoteId);
      } catch (e, st) {
        debugPrint('SyncManager: Failed to push template ${local.remoteId}: $e\n$st');
      }
    }

    // 3. Orders
    final unsyncedOrders = await orderLocal.getUnsyncedOrders();
    for (final local in unsyncedOrders) {
      final rawModel = await orderLocal.getOrderById(local.remoteId);
      if (rawModel != null) {
        // Upsert to remote
        try {
          await orderRemote.updateOrder(rawModel);
          await orderLocal.markAsSynced(local.remoteId);
        } catch (e, st) {
          try {
            await orderRemote.createOrder(rawModel);
            await orderLocal.markAsSynced(local.remoteId);
          } catch (e2, st2) {
            debugPrint('SyncManager: Failed to push order ${local.remoteId}: $e\n$st\nCreate fallback error: $e2\n$st2');
          }
        }
      }
    }
  }

  Future<void> _pullRemoteData() async {
    // 1. Pull Customers
    try {
      final remoteCustomers = await customerRemote.getCustomers();
      if (remoteCustomers.isNotEmpty) {
        await customerLocal.upsertCustomers(remoteCustomers);
      }
    } catch (e, st) {
      debugPrint('SyncManager: Failed to pull customers: $e\n$st');
    }

    // 2. Pull Templates
    try {
      final remoteTemplates = await templateRemote.getTemplates();
      if (remoteTemplates.isNotEmpty) {
        await templateLocal.upsertTemplates(remoteTemplates);
      }
    } catch (e, st) {
      debugPrint('SyncManager: Failed to pull templates: $e\n$st');
    }

    // 3. Pull Orders
    try {
      final remoteOrders = await orderRemote.getOrders();
      if (remoteOrders.isNotEmpty) {
        await orderLocal.upsertOrders(remoteOrders);
      }
    } catch (e, st) {
      debugPrint('SyncManager: Failed to pull orders: $e\n$st');
    }
  }
}
