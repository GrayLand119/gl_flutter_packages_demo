library gl_flutter_kit;

import 'package:flutter/material.dart';
import 'dart:core';

export 'src/GLTapped.dart';
export 'src/GLUtils.dart';
export 'src/GLAppBar.dart';
export 'src/GLCommonButton.dart';
export 'src/GLPolygenButton.dart';
export 'src/GLCommonCell.dart';
export 'src/GLCircleAvatar.dart';
export 'src/GLBaseDialog.dart';
export 'src/GLHUD.dart';
export 'src/GLCrossFadePageRoute.dart';

export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:cached_network_image/cached_network_image.dart';

part 'src/GLExtensions.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
