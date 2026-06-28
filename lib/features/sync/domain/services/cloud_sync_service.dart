import '../../../customers/data/datasources/customer_local_data_source.dart';
import '../../../customers/data/datasources/customer_remote_data_source.dart';
import '../../../templates/data/datasources/template_local_data_source.dart';
import '../../../templates/data/datasources/template_remote_data_source.dart';
import '../../../orders/data/datasources/order_local_data_source.dart';
import '../../../orders/data/datasources/order_remote_data_source.dart';
import '../../../customers/data/models/customer_model.dart';
import '../../../templates/data/models/template_model.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../../core/services/plan_service.dart';

class CloudSyncService {
  final CustomerLocalDataSource customerLocal;
  final CustomerRemoteDataSource customerRemote;
  final TemplateLocalDataSource templateLocal;
  final TemplateRemoteDataSource templateRemote;
  final OrderLocalDataSource orderLocal;
  final OrderRemoteDataSource orderRemote;
  final PlanService planService;

  CloudSyncService({
    required this.customerLocal,
    required this.customerRemote,
    required this.templateLocal,
    required this.templateRemote,
    required this.orderLocal,
    required this.orderRemote,
    required this.planService,
  });

  /// Call this when a user upgrades from Free to Premium.
  /// It takes all unsynced local data and pushes it to Supabase.
  Future<void> migrateLocalDataToCloud() async {
    try {
      // 1. Migrate Customers
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
        // Add to cloud
        await customerRemote.addCustomer(model);
        // Mark as synced locally
        await customerLocal.markAsSynced(local.remoteId);
      }

      // 2. Migrate Templates
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
        await templateRemote.addTemplate(model);
        await templateLocal.markAsSynced(local.remoteId);
      }

      // 3. Migrate Orders
      final unsyncedOrders = await orderLocal.getUnsyncedOrders();
      for (final local in unsyncedOrders) {
        // Parse measurements
        Map<String, String> parsedMeasurements = {};
        try {
          // We implemented parsing in the datasource, but here we just need to send it up so we do it raw or use the method
          final rawModel = await orderLocal.getOrderById(local.remoteId);
          if (rawModel != null) parsedMeasurements = rawModel.measurements;
        } catch (_) {}

        final model = OrderModel(
          id: local.remoteId,
          customerId: local.customerId,
          customerName: local.customerName,
          customerPhone: local.customerPhone,
          garmentTypes: local.garmentTypes,
          specialInstructions: local.specialInstructions ?? '',
          referenceImagePath: local.referenceImagePath,
          measurements: parsedMeasurements,
          deliveryDate: local.deliveryDate,
          priorityIndex: local.priorityIndex,
          assignedTailor: local.assignedTailor,
          totalAmount: local.totalAmount,
          advancePaid: local.advancePaid,
          paymentMode: local.paymentMode,
          status: local.status,
          createdAt: local.createdAt,
        );
        await orderRemote.createOrder(model);
        await orderLocal.markAsSynced(local.remoteId);
      }

      // Finally, update plan service to premium so repo switches routing
      await planService.setPlan(AppPlan.premium);

    } catch (e) {
      throw Exception('Failed to migrate data to cloud: \$e');
    }
  }
}
