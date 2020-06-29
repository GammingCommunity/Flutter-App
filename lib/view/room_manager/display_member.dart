import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:get/get.dart';

class DisplayMember extends StatefulWidget {
  final List ids;
  final double borderRadius;
  final double size;
  final Function onTap;
  final bool clickable;
  final bool showBadged;
  DisplayMember(
      {@required this.ids,
      @required this.borderRadius,
      @required this.size,
      this.onTap,
      this.clickable = false,
      this.showBadged = false});
  @override
  _DisplayMemberState createState() => _DisplayMemberState();
}

class _DisplayMemberState extends State<DisplayMember> with AutomaticKeepAliveClientMixin {
  var query = GraphQLQuery();

  String currentID = "";
  @override
  void initState() {
    super.initState();
    getCurrentID().then((value) => {
          print("here $value"),
          setState(() {
            currentID = value;
          })
        });
  }

  Future getCurrentID() async {
    var info = await getUserInfo();
    return info['userID'];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 50,
      width: Get.width,
      alignment: Alignment.centerLeft,
      child: FutureBuilder<List<User>>(
        future: Future(() async {
          // convert to list int
          var listInt = List<int>.from(widget.ids.map((e) => int.parse(e)).toList());
          var getUsers = <User>[];
          try {
            var result =
                await SubRepo.queryGraphQL(await getToken(), query.getMutliUserInfo(listInt));
            getUsers = ListUser.fromJson(result.data['lookAccount']).listUser;
          } catch (e) {
            print(e);
            return [];
          }
          return getUsers;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: widget.size,
              width: Get.width,
                          child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      SkeletonTemplate.image(widget.size, widget.size, 15),
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: widget.ids.length),
            );
          } else {
            var users = snapshot.data;
            //print(currentID == "68");
            return users.isEmpty
                ? Text("Error")
                : ListView.separated(
                   physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemCount: users.length,
                  
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: <Widget>[
                          Positioned(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                              onTap: () {
                                widget.clickable ? widget.onTap() : null;
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(widget.borderRadius),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      users[index].profileUrl ?? AppConstraint.default_profile,
                                  height: widget.size,
                                  width: widget.size,
                                  fit: BoxFit.cover,
                                  placeholder: (context, image) => Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(widget.borderRadius)),
                                  ),
                                  errorWidget: (context, error, image) => Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          widget.showBadged
                              ? currentID == users[index].id.toString()
                                  ? Positioned(
                                      top: -5,
                                      right: -5,
                                      child: Icon(
                                        Icons.star,
                                        size: 20,
                                        color: Colors.amber,
                                      ))
                                  : Container()
                              : Container(),
                        ],
                      );
                    },
                  );

            /*  Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var index = 0; index < users.length; index++)
                  Stack(
                    children: <Widget>[
                      Positioned(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          onTap: () {
                            widget.clickable ? widget.onTap() : null;
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            child: CachedNetworkImage(
                              imageUrl: users[index].profileUrl ?? AppConstraint.default_profile,
                              height: widget.size,
                              width: widget.size,
                              fit: BoxFit.cover,
                              placeholder: (context, image) => Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(widget.borderRadius)),
                              ),
                              errorWidget: (context, error, image) => Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      widget.showBadged
                          ? currentID == users[index].id.toString()
                              ? Positioned(
                                  top: -5,
                                  right: -5,
                                  child: Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Colors.amber,
                                  ))
                              : Container()
                          : Container(),
                    ],
                  ),

                //for (var item in users)
              ],
            );*/
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget buildLoading(BuildContext context, double size) {
  return Container(
      height: size,
      width: size,
      child: Center(child: SpinKitCubeGrid(color: Theme.of(context).iconTheme.color, size: 10)));
}
