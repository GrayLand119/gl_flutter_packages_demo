import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gl_flutter_kit/gl_flutter_kit.dart';

import 'MyHomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  styleInit();

  runApp(MyApp());
}

void styleInit() {
  GLAppStyleConfig _demoAppConfig = GLAppStyleConfig()
    ..primaryColor = Colors.deepOrange
    ..defaultAppColors = MaterialColor(
      0xFFFF5722,
      <int, Color>{
        50: Color(0xFFFBE9E7),
        100: Color(0xFFFFCCBC),
        200: Color(0xFFFFAB91),
        300: Color(0xFFFF8A65),
        400: Color(0xFFFF7043),
        500: Colors.deepOrange,
        600: Color(0xFFF4511E),
        700: Color(0xFFE64A19),
        800: Color(0xFFD84315),
        900: Color(0xFFBF360C),
      },
    )
    // 快捷取色器, 与 App 无关.
    ..colorsMap = <int, Color>{
      1: Color(0xFF282828),
      2: Color(0xFF818181),
      3: Color(0xFFB4B4B4),
      4: Colors.white,
      5: Colors.deepOrange,
      6: Color(0xFFF38F1C),
      7: Colors.lightBlue,
      0: Color(0xFFF4511E),
    };

  GLAppStyle.instance.updateConfig(_demoAppConfig);
}

class MyApp extends StatelessWidget {
  GLAppStyleConfig _yaAppConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: GLAppStyle.instance.currentConfig.defaultAppColors,
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
