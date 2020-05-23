import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/skeleton_template.dart';

class DisplayAvatar extends StatelessWidget {
  final double size;
  final bool isCircle;
  final double radius;
  DisplayAvatar({@required this.size, this.isCircle = true, this.radius});

  Future getUserID() async {
    var query = GraphQLQuery();
    try {
      var result = await SubRepo.queryGraphQL(await getToken(), query.getCurrentUserInfo());
      var profileUrl = User.fromJson(result.data['getThisAccount']).profileUrl;
      return profileUrl;
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            borderRadius: isCircle ? BorderRadius.circular(10000) : BorderRadius.circular(radius)),
        child: FutureBuilder(
          future: getUserID(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SkeletonTemplate.image(
                  size, size, isCircle ? 10000 : BorderRadius.circular(radius));
            } else {
              var profileUrl = snapshot.data;
              return CachedNetworkImage(fit: BoxFit.cover, imageUrl: profileUrl);
            }
          },
        ));
  }
}
