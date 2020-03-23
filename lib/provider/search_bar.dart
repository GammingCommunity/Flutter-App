import 'package:flutter/material.dart';

class Search with ChangeNotifier{
  bool hideSearchBar = true;
  void setHideSearchBar(bool value){
    hideSearchBar = value;
    notifyListeners();
  }
  get isHideSearch => hideSearchBar;

} 