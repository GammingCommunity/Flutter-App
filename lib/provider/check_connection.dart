import 'package:flutter/material.dart';
import 'dart:io';
class CheckConnection with ChangeNotifier{
  bool isConnected = true;
  Future<void> get checkConnect async {
     try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isConnected =true;
        notifyListeners();
      }
    } on SocketException catch (_) {
      print('not connected');
      isConnected =false;
      notifyListeners();
    }
      
  }
}