import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayMember extends StatefulWidget {
  final List ids;
  DisplayMember({this.ids});
  @override
  _DisplayMemberState createState() => _DisplayMemberState();
}

class _DisplayMemberState extends State<DisplayMember> {
  var query = GraphQLQuery();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: Future(() async {
        SharedPreferences ref = await SharedPreferences.getInstance();
        print("list member ${widget.ids}");
        // convert to list int
        var listInt = List<int>.from(widget.ids.map((e) => int.parse(e)).toList());

        var result = await SubRepo.queryGraphQL(
            ref.getStringList("userToken")[2], query.getUserInfo(listInt));
        var getUsers = <User>[];
        try {
          getUsers = ListUser.fromJson(result.data['lookAccount']).listUser;
        } catch (e) {
          return [];
        }
        return getUsers;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoading(context);
        } else {
          var users = snapshot.data;
          return users.isEmpty
              ? Text("Has error")
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (var item in users)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: CachedNetworkImage(
                          imageUrl: item.profileUrl ?? AppConstraint.default_profile,
                          height: 30,
                          width: 30,
                          fit: BoxFit.cover,
                          placeholder: (context, image) =>
                             AppConstraint.spinKitCubeGrid(context),
                          errorWidget: (context, error, image) => Icon(Icons.error),
                        ),
                      ),
                  ],
                );
        }
      },
    );
  }
}

Widget buildLoading(BuildContext context) {
  return SpinKitCubeGrid(color: Theme.of(context).iconTheme.color, size: 10);
}
