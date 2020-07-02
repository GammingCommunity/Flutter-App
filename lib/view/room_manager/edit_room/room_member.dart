import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/view/room_manager/display_member.dart';
import 'package:gamming_community/view/room_manager/provider/edit_room_provider.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomMember extends StatefulWidget {
  @override
  _RoomMemberState createState() => _RoomMemberState();
}

class _RoomMemberState extends State<RoomMember> {
  EditRoomProvider editProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    editProvider = Injector.get();
    return Row(
      children: <Widget>[
        ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: editProvider.listMember.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => DisplayMember(
                  showBadged: true,
                  borderRadius: 1000,
                  size: 50,
                  clickable: true,
                  onTap: () {
                    print(editProvider.listMember[index]);
                  },
                  ids: editProvider.listMember,
                )),
        editProvider.canAddMore
            ? CircleIcon(
                icon: FeatherIcons.plus,
                iconSize: 20,
                onTap: () {},
              )
            : Container()
      ],
    );
  }
}
