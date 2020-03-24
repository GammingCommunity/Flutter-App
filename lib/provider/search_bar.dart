import 'package:flutter/material.dart';

class Search with ChangeNotifier{
  bool _hideSearchBar = true;
  double _currentScrollOffset = 0.0;
  void setHideSearchBar(bool value){
    _hideSearchBar = value;
    notifyListeners();
  }
  void setCurrentScrollOffset(double offset){
    _currentScrollOffset= offset;
    notifyListeners();
  }
  get currentOffset => _currentScrollOffset;
  get isHideSearch => _hideSearchBar;

} 