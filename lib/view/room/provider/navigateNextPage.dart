import 'package:flutter/material.dart';

class NavigateNextPage with ChangeNotifier{
  PageController controller;

  void setPageController(PageController controller){
    controller = controller;
    notifyListeners();
  }
  get getController => controller;
  void nextPage(){
    controller.animateToPage(2,duration: Duration(milliseconds: 500), curve: Curves.ease);
    notifyListeners();
  }
  void previousPage(){
    controller.animateToPage(1,duration: Duration(milliseconds: 500), curve: Curves.ease);
    notifyListeners();
  }
}