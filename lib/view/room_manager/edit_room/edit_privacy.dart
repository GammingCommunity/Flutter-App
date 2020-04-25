import 'package:flutter/material.dart';
import 'package:gamming_community/view/room_manager/edit_room/privacy_radio.dart';
import 'package:gamming_community/view/room_manager/provider/edit_room_provider.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class EditPrivacy extends StatefulWidget {
  final bool isPrivate;
  EditPrivacy({this.isPrivate});
  @override
  _EditPrivacyState createState() => _EditPrivacyState();
}

class _EditPrivacyState extends State<EditPrivacy> {
  bool isPrivate = false;
  EditRoomProvider editProvider;
  @override
  void initState() {
    super.initState();
    isPrivate = widget.isPrivate;
  }

  @override
  Widget build(BuildContext context) {
    editProvider = Injector.get(context: context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        EditPrivacyRadio(
          value: true,
          checkedValue: isPrivate,
          title: "Public",
          onChange: (bool newVal) {
            editProvider.setPrivacy(newVal);
            setState(() {
              isPrivate = newVal;
            });
          },
        ),
        EditPrivacyRadio(
          value: false,
          checkedValue: isPrivate,
          title: "Private",
          onChange: (bool newVal) {
            editProvider.setPrivacy(newVal);
            setState(() {
              isPrivate = newVal;
            });
          },
        ),
      ],
    );
  }
}
