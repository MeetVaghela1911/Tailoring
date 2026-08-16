import 'package:isar_community/isar.dart';

part 'customer_local_model.g.dart';

@collection
class CustomerLocalModel {
  Id id = Isar.autoIncrement;
  
  // Isar doesn't naturally support String IDs as primary keys, so we keep the Supabase UUID as an indexed field
  @Index(unique: true, replace: true)
  late String remoteId; 

  @Index(type: IndexType.value, caseSensitive: false)
  String name = '';

  @Index(caseSensitive: false)
  String phoneNumber = '';
  
  String? email;
  String? address;
  String? notes;
  
  late DateTime createdAt;
  
  String? colorHex;
  String? profileImageUrl;

  @Index()
  bool isSynced = false;
  DateTime? lastUpdated;

  @Index()
  bool isDeleted = false;
}
