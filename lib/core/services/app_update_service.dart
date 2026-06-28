import 'package:flutter/material.dart';

class AppUpdateService extends ChangeNotifier {
  bool _isUpdateRequired = false;
  String? _minVersion;

  bool get isUpdateRequired => _isUpdateRequired;
  String? get minVersion => _minVersion;

  void setUpdateRequired(String minVersion) {
    _isUpdateRequired = true;
    _minVersion = minVersion;
    notifyListeners();
  }

  void reset() {
    _isUpdateRequired = false;
    _minVersion = null;
    notifyListeners();
  }
}
