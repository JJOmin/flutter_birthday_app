import 'package:flutter/widgets.dart';

//import 'package:geburtstags_app/repository/settings.repo.dart';
import 'package:geburtstags_app/models/settings.model.dart';

class SettingsRepo extends ChangeNotifier {
  SettingsRepo._privateConstructor() {
    _settings = Settings(darkMode: true);
  }

  static final SettingsRepo _instance = SettingsRepo._privateConstructor();

  factory SettingsRepo() => _instance;
  late Settings _settings;

  bool get darkMode => _settings.darkMode;

  void toggleDarkMode() {
    _settings.darkMode = !_settings.darkMode;
    notifyListeners(); // UI wird benachrichtigt
  }

  void setDarkMode(bool value) {
    _settings.darkMode = value;
    notifyListeners();
  }
}
