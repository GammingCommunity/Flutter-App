import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/view/room_manager/provider/edit_room_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomBackground extends StatefulWidget {
  @override
  _RoomBackgroundState createState() => _RoomBackgroundState();
}

class _RoomBackgroundState extends State<RoomBackground> {
  EditRoomProvider editProvider;
  String path = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      path = editProvider.roomBackground;
    });
  }

  @override
  Widget build(BuildContext context) {
    editProvider = Injector.get(context: context);
    // load background image // seperate view to prevent rebuild
    return Stack(
      children: <Widget>[
        editProvider.isChangeBackground
            ? Container(
                color: Colors.white,
                child: Image.asset(
                  editProvider.backgroundPath,
                  height: 150.h,
                  width: ScreenUtil().uiWidthPx,
                  fit: BoxFit.cover,
                ),
              )
            : CachedNetworkImage(
                height: 150.h,
                width: ScreenUtil().uiWidthPx,
                fit: BoxFit.fill,
                imageUrl: editProvider.roomBackground),
        ContainerResponsive(
            height: 150.h,
            width: ScreenUtil().uiWidthPx,
            color: Colors.grey.withOpacity(0.8),
            child: CircleIcon(
              icon: FeatherIcons.image,
              iconSize: 30,
              onTap: () async {
                var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                try {
                  editProvider.setBackgroundPath(image.path);
                } catch (e) {}
              },
            ))
      ],
    );
  }

}
