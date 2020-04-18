import 'package:states_rebuilder/states_rebuilder.dart';

class SettingProvider extends StatesRebuilder{
  bool darkTheme = true;

  void setTheme() {
    darkTheme = ! darkTheme;
    rebuildStates();
  }
}