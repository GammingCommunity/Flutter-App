import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/view/friend_profile/provider/friend_profile_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PostTab extends StatefulWidget {
  final int userID;
  PostTab({this.userID});
  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> with AutomaticKeepAliveClientMixin {
  FRefreshController fRefreshController = FRefreshController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WhenRebuilderOr<FriendProfileProvider>(
        observe: () => RM.get<FriendProfileProvider>(),
        initState: (_, model) => model.setState((s) => s.getUserPost(widget.userID)),
        builder: (context, model) => FRefresh(
              controller: fRefreshController,
              headerHeight: 60,
              headerBuilder: (setter, constraints) {
                //await _privateChatProvider.refresh();
                return Container(
                  height: 50,
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xfff1f3f6),
                      valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
                      strokeWidth: 2.0,
                    ),
                  ),
                );
              },
              footerHeight: 50.0,
              footerBuilder: (setter) {
                /// Get refresh status, partially update the content of Footer area

                return Container(
                    height: 38,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Color(0xfff1f3f6),
                            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
                            strokeWidth: 2.0,
                          ),
                        ),
                        SizedBox(width: 9.0),
                        Text(
                          "Load more",
                          style: TextStyle(color: Color(0xff6c909b)),
                        ),
                      ],
                    ));
              },
              onRefresh: () async {
                print("on refresh");
                fRefreshController.finishRefresh();
              },
              onLoad: () {
                print("onLoad");
                fRefreshController.finishLoad();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  width: Get.width,
                  child: model.state.postCount == 0
                      ? Center(child: Text("No post"))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.state.postCount,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 100,
                              width: Get.width,
                            );
                          })),
            ));
  }

  @override
  bool get wantKeepAlive => true;
}
