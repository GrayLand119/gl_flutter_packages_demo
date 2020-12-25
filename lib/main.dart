import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gl_flutter_kit/gl_flutter_kit.dart';

import 'MyHomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: GLMaterialColor.defaultAppColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, child) {
        /// 先初始化一些常用变量, 避免每次获取宽高都要调用一遍 MediaQuery.of(content)
        SCREEN_WIDTH = MediaQuery.of(context).size.width;
        SCREEN_HEIGHT = MediaQuery.of(context).size.height;
        PIXEL_RATIO = MediaQuery.of(context).devicePixelRatio;
        return child;
      },
    );
  }
}
