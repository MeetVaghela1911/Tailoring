import 'package:isar_community/isar.dart';

part 'order_local_model.g.dart';

@collection
class OrderLocalModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  @Index()
  String? customerId;
  String? customerName;
  String? customerPhone;

  List<String> garmentTypes = [];
  String garmentQuantitiesJson = '{}';
  String garmentPricesJson = '{}';

  String? specialInstructions;
  String? referenceImagePath;

  // Isar doesn't perfectly support Map<String, String>. We can overcome this by serializing
  // it to a JSON string, or keeping two lists (keys and values). JSON string is easiest for simple local storage.
  String measurementsJson = '{}';
  String measurementNotesJson = '{}';

  @Index()
  DateTime? deliveryDate;
  int priorityIndex = 0;
  String assignedTailor = '';

  double totalAmount = 0.0;
  double advancePaid = 0.0;
  double externalCharges = 0.0;
  int paymentMode = 0;
  
  @Index()
  String status = 'NOT STARTED';

  DateTime createdAt = DateTime.now();

  @Index()
  bool isSynced = false;
  
  DateTime? lastUpdated;
}
