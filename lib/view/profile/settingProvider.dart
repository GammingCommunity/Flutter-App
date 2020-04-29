import 'package:states_rebuilder/states_rebuilder.dart';

class SettingProvider extends StatesRebuilder {
  bool darkTheme = true;
  bool enLang = true;
  void setTheme() {
    darkTheme = !darkTheme;
    rebuildStates();
  }

  void setLanguage() {
    enLang = !enLang;
    rebuildStates();
  }
}
