import 'package:flutter/material.dart';

Widget buildAppWithTextScaleLimiter(Widget app) {
  return Builder(
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: app,
      );
    },
  );
}
