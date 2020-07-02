import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String content;
  bool isChange = false;
  double _currentScrollOffset = 0.0;

  String changeContent(int index) {
    switch (index) {
      case 0:
        isChange = true;
        return content = "Hello  Friends";
        break;
      case 1:
        isChange = true;
        return content = "....";
        break;
      case 2:
        isChange = true;
        return content = "Search group";
        break;
      case 3:
        isChange = true;
        return content = "Search friends";
        break;
      case 4:
        isChange = true;
        return content = "Search friends";
        break;
      default:
        return "";
    }
  }

  void setCurrentScrollOffset(double offset) {
    _currentScrollOffset = offset;
    notifyListeners();
  }

  get currentOffset => _currentScrollOffset;
}
