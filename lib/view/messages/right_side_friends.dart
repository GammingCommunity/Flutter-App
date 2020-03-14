import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';

class RightSideFriends extends StatefulWidget {
  @override
  _RightSideFriendsState createState() => _RightSideFriendsState();
}

class _RightSideFriendsState extends State<RightSideFriends> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: 100,
      height: screenSize.height - AppConstraint.bottom_bar_height,
      child: Drawer(
          child: Column(
        children: <Widget>[
          Material(
            clipBehavior: Clip.antiAlias,
            type: MaterialType.circle,
            color: Colors.transparent,
            child: IconButton(
              alignment: Alignment.center,
              icon: Icon(
                OpenIconicIcons.magnifyingGlass,
                size: 20,
              ),
              // Open search box friends

              onPressed: () {
                
              },
            ),
          ),
          Expanded(
              child: Container(
            constraints: BoxConstraints.tight(Size(60, 60)),
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(
                height: 20,
              ),
              itemCount: 10,
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(AppConstraint.container_border_radius),
                onTap: (){},
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        AppConstraint.container_border_radius),
                    color: Colors.indigo[300],
                  ),
                ),
              ),
            ),
          ))
        ],
      )),
    );
  }
}
