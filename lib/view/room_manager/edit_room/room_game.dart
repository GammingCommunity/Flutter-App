import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/view/room_manager/edit_room/game_info.dart';
import 'package:gamming_community/view/room_manager/provider/edit_room_provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomGame extends StatefulWidget {
  @override
  _RoomGameState createState() => _RoomGameState();
}

class _RoomGameState extends State<RoomGame> {
  EditRoomProvider editProvider;
  @override
  Widget build(BuildContext context) {
    editProvider = Injector.get();
    return Row(
      children: <Widget>[
        ContainerResponsive(
            height: 100,
            child: GInfo(
              height: 100,
              width: 100,
              radius: 10,
            )),
        SizedBoxResponsive(width: 10),
        Column(
          children: <Widget>[
            Text(
              editProvider.game.gameName ?? "",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FlatButton.icon(onPressed: () {}, icon: Icon(FeatherIcons.edit2), label: Text("Edit"))
          ],
        )
      ],
    );
  }
}
