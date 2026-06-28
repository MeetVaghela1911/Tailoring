import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

// We will import our Isar models here once they are created
import '../../features/customers/data/models/customer_local_model.dart';
import '../../features/templates/data/models/template_local_model.dart';
import '../../features/orders/data/models/order_local_model.dart';

class LocalDatabase {
  late Isar _isar;

  bool _isInitialized = false;

  Isar get isar {
    if (!_isInitialized) {
      throw Exception('LocalDatabase is not initialized. Call init() first.');
    }
    return _isar;
  }

  Future<void> init() async {
    if (_isInitialized) return;

    final dir = await getApplicationDocumentsDirectory();
    
    _isar = await Isar.open(
      [
        CustomerLocalModelSchema,
        TemplateLocalModelSchema,
        OrderLocalModelSchema,
      ],
      directory: dir.path,
    );
    
    _isInitialized = true;
  }

  /// Close Isar instance
  Future<void> close() async {
    if (_isInitialized) {
      await _isar.close();
      _isInitialized = false;
    }
  }

  /// Clear all data - USE WITH CAUTION
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
