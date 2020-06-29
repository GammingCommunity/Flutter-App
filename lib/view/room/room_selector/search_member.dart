import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/customWidget/faSlideAnimation_v2.dart';
import 'package:gamming_community/customWidget/requestButton.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/enum/relationship_enum.dart';
import 'package:gamming_community/view/home/provider/search_friend_provider.dart';
import 'package:gamming_community/view/room_manager/bloc/room_manager_bloc.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SearchMember extends StatefulWidget {
  @override
  _SearchMemberState createState() => _SearchMemberState();
}

class _SearchMemberState extends State<SearchMember> {
  RoomManagerBloc roomManagerBloc;
  var searchEditText = TextEditingController();
  var users = <User>[];
  String get inputValue => searchEditText.text;
  void clearInput() => searchEditText.clear();
  @override
  void dispose() {
    super.dispose();
    searchEditText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var schFrProvider = RM.get<SearchFriendsProvider>();
    roomManagerBloc = BlocProvider.of<RoomManagerBloc>(context);

    return Scaffold(
      floatingActionButton: Visibility(
          visible: users.length > 0,
          child: FaSlideAnimation.slideUp(
            delayed: 200,
            show: users.length > 0,
            child: SizedBox(
                width: 60,
                height: 60,
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.indigo,
                  child: InkWell(
                    onTap: () {
                      Get.back(result: users);
                      schFrProvider.setState((currentState) => currentState.clearSearchResult());
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
          )),
      appBar: CustomAppBar(
          child: [
            Expanded(
              child: Container(
                height: 50,
                width: screenSize.width,
                child: TextField(
                  controller: searchEditText,
                  onSubmitted: (value) {
                    var v = roomManagerBloc.users.map((e) => e.id).toList();
                    print(v);
                    return inputValue == ""
                        ? null
                        : schFrProvider
                            .setState((currentState) => currentState.searchFriend(inputValue, v));
                  },
                  /* onChanged: (String value) => schFrProvider.setState(
                      (currentState) => currentState.changeText(value == "" ? false : true)),*/
                  decoration: InputDecoration(
                      filled: true,
                      hintText: "Type your name, or IDs",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      suffixIcon: Visibility(
                          visible: !schFrProvider.state.isChangTxt,
                          child: CircleIcon(
                              icon: FeatherIcons.x,
                              onTap: () {
                                clearInput();
                                setState(() {
                                  users.clear();
                                });
                                schFrProvider
                                    .setState((currentState) => currentState.clearSearchResult());
                              })),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                ),
              ),
            )
          ],
          height: 50,
          onNavigateOut: () {
            schFrProvider.setState((currentState) => currentState.clearSearchResult());
            Get.back(result: users);
          },
          padding: EdgeInsets.all(5),
          backIcon: FeatherIcons.arrowLeft),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        height: screenSize.height,
        width: screenSize.width,
        child: Column(
          children: [
            Expanded(
                child: WhenRebuilderOr<SearchFriendsProvider>(
                    observe: () => RM.get<SearchFriendsProvider>(),
                    onError: (error) => Center(
                          child: Text("There is an error with your request. Try again"),
                        ),
                    onWaiting: () => AppConstraint.loadingIndicator(context),
                    builder: (context, model) {
                      return model.state.listUser.isEmpty
                          ? Center(
                              child: Text("No result match !"),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              itemCount: model.state.listUser.length,
                              itemBuilder: (context, index) {
                                return FaSlideAnimation.slideUp(
                                  delayed: 500,
                                  show: true,
                                  child: UserItem(
                                    index: index,
                                    user: model.state.listUser[index],
                                    onSelected: (selectedIndex) {
                                      setState(() {
                                        users.add(model.state.listUser.elementAt(selectedIndex));
                                      });
                                    },
                                    onDeselected: (id) {
                                      setState(() {
                                        users.removeWhere((e) => e.id == id);
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                    })),
          ],
        ),
      ),
    );
  }
}

class UserItem extends StatefulWidget {
  final int index;
  final User user;
  final Function onSelected;
  final Function onDeselected;
  UserItem({this.index, this.user, this.onSelected, this.onDeselected});
  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  bool selected = false;
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (selected == false) {
          print("1");
          setState(() {
            selected = !selected;
          });
          return widget.onSelected(widget.index);
        } else {
          print("2");
          setState(() {
            selected = false;
          });
          return widget.onDeselected(widget.user.id);
        }
      },
      child: Container(
        height: 100,
        width: Get.width,
        child: Row(
          children: <Widget>[
            Checkbox(value: selected, onChanged: (value) {}),
            SizedBox(width: 10),
            InkWell(
              borderRadius: BorderRadius.circular(10000),
              excludeFromSemantics: true,
              onTap: () {
                print(widget.user.id);
              },
              child: CachedNetworkImage(
                imageUrl: widget.user.profileUrl ?? AppConstraint.default_profile,
                placeholder: (context, url) => Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    )),
                errorWidget: (context, url, error) {
                  return Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  );
                },
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.user.nickname,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.user.describe,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
