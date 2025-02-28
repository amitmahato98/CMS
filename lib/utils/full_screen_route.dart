import 'package:flutter/material.dart';

class FullScreenRoute extends MaterialPageRoute {
  FullScreenRoute({required WidgetBuilder builder})
    : super(
        builder: (context) => Scaffold(body: builder(context)),
        fullscreenDialog: true,
      );
}
