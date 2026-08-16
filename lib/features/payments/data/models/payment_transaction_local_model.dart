import 'package:isar_community/isar.dart';

part 'payment_transaction_local_model.g.dart';

@collection
class PaymentTransactionLocalModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  @Index()
  late String orderId;

  @Index()
  String? customerId;
  String? customerName;
  String? customerPhone;

  double amount = 0.0;
  int paymentMode = 1;
  String? paymentModeName;
  String? paymentStage;
  String? notes;
  String? referenceNumber;

  @Index()
  DateTime createdAt = DateTime.now();

  @Index()
  bool isSynced = false;
}
