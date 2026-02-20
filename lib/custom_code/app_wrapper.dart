import 'package:flutter/material.dart';

Widget buildAppWithTextScaleLimiter(Widget app) {
  return Builder(
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: app,
      );
    },
  );
}
