import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Created by GrayLand119
/// on 2020/12/15
class GLCrossFadePageRoute<T> extends PageRouteBuilder<T> {
  GLCrossFadePageRoute({@required Widget page})
      : super(
    pageBuilder: (ctx, a1, a2) => page,
    transitionsBuilder: (ctx, a1, a2, c) => FadeTransition(
      opacity: a1.drive(Tween(begin: 0.0, end: 1.0)),
      child: c,
    ),
  );
}