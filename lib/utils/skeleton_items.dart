import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:shimmer/shimmer.dart';

class OnDemandItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 50,
        width: screenSize.width,
        color: Color(0xff5a5757),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Shimmer.fromColors(
                  enabled: true,
                  child: Container(
                    height: 10,
                  ),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100]),
            ),
            Positioned(
                left: 30,
                top: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Sample text here",
                      style: TextStyle(shadows: [
                        Shadow(blurRadius: 6, color: Colors.black, offset: Offset(2, 3))
                      ], fontSize: AppConstraint.roomTitleSize),
                    ),
                    Text(
                      "Sample text here",
                      style: TextStyle(fontSize: AppConstraint.roomTitleSize),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
