import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/friend_profile/provider/friend_profile_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AboutTab extends StatefulWidget {
  final int userID;
  AboutTab({this.userID});
  @override
  _AboutTabState createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WhenRebuilderOr<FriendProfileProvider>(
      observe: () => RM.get<FriendProfileProvider>(),
      initState: (_, model) => model.setState((s) => s.getUserPost(widget.userID)),
      onWaiting: () => Center(
        child: AppConstraint.loadingIndicator(context),
      ),
      builder: (context, model) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("blabablablablalblablablalb")
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
