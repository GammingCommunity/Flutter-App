import 'package:flutter/material.dart';

class PVScaleFactor extends StatelessWidget {
  final Widget child;
  PVScaleFactor({this.child});
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final mediaQueryData = MediaQuery.of(context);
        final constrainedTextScaleFactor = mediaQueryData.textScaleFactor.clamp(1.0, 1.5);
        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaleFactor: constrainedTextScaleFactor,
          ),
          child: child,
        );
      },
    );
  }
}
