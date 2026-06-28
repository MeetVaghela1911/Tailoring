import 'package:isar_community/isar.dart';

part 'template_local_model.g.dart';

@collection
class TemplateLocalModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  String name = '';
  
  @Index()
  String category = '';
  
  int iconCodePoint = 0;
  
  String? iconFontFamily;
  
  List<String> fields = [];
  
  double basePrice = 0.0;
  
  @Index()
  bool isSynced = false;
  DateTime? lastUpdated;
}
