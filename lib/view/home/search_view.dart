import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/customWidget/requestButton.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/enum/relationship_enum.dart';
import 'package:gamming_community/view/home/provider/search_friend_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  var searchEditText = TextEditingController();

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
    return Scaffold(
      appBar: CustomAppBar(
          child: [
            Expanded(
              child: Container(
                height: 50,
                width: screenSize.width,
                child: TextField(
                  controller: searchEditText,
                  onSubmitted: (value) => inputValue == ""
                      ? null
                      : schFrProvider
                          .setState((currentState) => currentState.searchFriend(inputValue, [])),
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
            Get.back();
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
                                return buildSearchFriend(context, model.state.listUser[index]);
                              },
                            );
                    })),
          ],
        ),
      ),
    );
  }
}

Widget buildSearchFriend(BuildContext cxt, User user) {
  return Container(
    height: 100,
    width: Get.width,
    child: Row(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: user.profileUrl ?? AppConstraint.default_profile,
          placeholder: (context, url) => Container(
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
          errorWidget: (context, url, error) {
            return Container(
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            );
          },
          imageBuilder: (context, imageProvider) {
            return Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
            );
          },
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              user.nickname,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(user.describe)
          ],
        ),
        Spacer(),
        RequestButton(
          child: Container(),
          setCircle: true,
          buttonHeight: 40,
          buttonWidth: 80,
          onSuccess: (data) {
            data == 1
                ? BotToast.showText(text: "Send request success.")
                : BotToast.showText(text: "Remove request.");
          },
          onError: (data) {},
          onPressed: () {},
          isRequest: isHostRequest(user.relationship),
          userID: user.id,
        )
      ],
    ),
  );
}
