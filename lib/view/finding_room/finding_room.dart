import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/view/finding_room/finding_room_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class FindingRoom extends StatefulWidget {
  @override
  _FindingRoomState createState() => _FindingRoomState();
}

class _FindingRoomState extends State<FindingRoom> {
  FindingRoomProvider findingRoomProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await findingRoomProvider.initConnection();
      await findingRoomProvider.listenEvent();
    });
  }

  @override
  void dispose() {
    findingRoomProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    findingRoomProvider = Injector.get(context: context);

    return Scaffold(
      appBar: CustomAppBar(
          child: [],
          height: 50,
          onNavigateOut: () {
            Get.back();
          },
          padding: EdgeInsets.all(0),
          backIcon: FeatherIcons.arrowLeft),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            RaisedButton(onPressed: () async {
              await findingRoomProvider.find(true, 2, "5e5b5c16709ead0ab05369a5");
            })
          ],
        ),
      ),
    );
  }
}
