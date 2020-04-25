import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/view/room_manager/provider/edit_room_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomLogo extends StatefulWidget {
  @override
  _RoomLogoState createState() => _RoomLogoState();
}

class _RoomLogoState extends State<RoomLogo> with AutomaticKeepAliveClientMixin {
  EditRoomProvider editProvider;
  @override
  void initState() {
    print("logo");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    editProvider = Injector.get();
    super.build(context);
    return Positioned.fill(
        bottom: 5,
        left: 10,
        child: Align(
            alignment: Alignment.bottomLeft,
            child: Stack(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(1000),
                  child: editProvider.isChangeLogo
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Container(
                            color: Colors.white,
                            child: Image.asset(
                              editProvider.logoPath,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => ClipRRect(
                                      child: Container(height: 100, width: 100, color: Colors.grey),
                                    ),
                                imageBuilder: (context, imageProvider) => Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(1000),
                                          border: Border.all(
                                              color: AppColors.BACKGROUND_COLOR, width: 3),
                                          image: DecorationImage(image: imageProvider)),
                                    ),
                                imageUrl: editProvider.roomLogo),
                          ],
                        ),
                ),
                ContainerResponsive(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: Colors.grey.withOpacity(0.8),
                    ),
                    child: CircleIcon(
                      icon: FeatherIcons.edit,
                      iconSize: 30,
                      onTap: () async {
                        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                        //close modal
                        //Navigator.pop(context);
                        //print(image);
                        try {
                          editProvider.setLogoPath(image.path);
                        } catch (e) {}
                      },
                    ))
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}
