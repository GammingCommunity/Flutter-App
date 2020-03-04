import 'package:flutter/material.dart';

class AddRoom {
  static TextEditingController roomName= TextEditingController();
  static TextEditingController numberOfMember= TextEditingController();
  static displayDialog(BuildContext context, GlobalKey key) {
    return showDialog(
        useRootNavigator: true,
       
        child: Container(
          height: 200,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
          ),
          child: SimpleDialog(
            contentPadding: EdgeInsets.all(10),
            children: <Widget>[
              Form(child: Column(children: <Widget>[
                TextField(controller: roomName,),
                TextField(controller: roomName,)
              ],))
            ],
          ),
        ),
        context: context);
  }
}
