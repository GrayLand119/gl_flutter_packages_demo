import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Created by GrayLand119
/// on 2020/12/25
double SCREEN_WIDTH = 0.0;
double SCREEN_HEIGHT = 0.0;
double PIXEL_RATIO = 0.0;

double SCALE_WIDTH(width) {
  return width / 375.0 * SCREEN_WIDTH;
}

double SCALE_HEIGHT(height) {
  return height / 667.0 * SCREEN_HEIGHT;
}