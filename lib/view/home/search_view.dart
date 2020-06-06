import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/requestButton.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/enum/relationship_enum.dart';
import 'package:gamming_community/view/home/provider/search_friend_provider.dart';
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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var schFrProvider = RM.get<SearchFriendsProvider>();
    return Scaffold(
      appBar: PreferredSize(
          child:  Row(
              children: [
                CircleIcon(
                  icon: FeatherIcons.x,
                  onTap: () {
                    // clear data before navigate out
                    schFrProvider.setState((currentState) => currentState.clearSearchResult());
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    height: 50,
                    width: screenSize.width,
                    child: TextField(
                      controller: searchEditText,
                      onSubmitted: (value) => inputValue == ""
                          ? null
                          : schFrProvider
                              .setState((currentState) => currentState.searchFriend(inputValue)),
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Type your name, or IDs",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              clearInput();
                            },
                            child: Icon(FeatherIcons.x),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    ),
                  ),
                )
              ],
            ),
          
          preferredSize: Size.fromHeight(50)),
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
  var screenSize = MediaQuery.of(cxt).size;
  return Container(
    height: 100,
    width: screenSize.width,
    child: Row(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: user.profileUrl ?? AppConstraint.default_profile,
          placeholder: (context, url) => Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              )),
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
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              user.nickname,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        Spacer(),
        RequestButton(
          child: Container(),
          setCircle: true,
          buttonHeight: 30,
          buttonWidth: 30,
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
