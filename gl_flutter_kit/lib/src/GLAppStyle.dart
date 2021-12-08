part of 'package:gl_flutter_kit/gl_flutter_kit.dart';

/// Created by GrayLand119
/// on 2020/12/25
///
class GLAppStyleConfig {
  Color splashColor = Color(0xFFB4E4E2);
  Color separatorColor = Color(0xFFEDECE8);
  Color sessionColor = Color(0x3FEDECE8);
  Color backgroundColor = Color(0xFFEBECED);
  Color primaryColor = Color(0xFF69C9C6);
  Map<int, Color> colorsMap = {};

  int defaultColorValue = 0xFF69C9C6;
  Color defaultAppColor = Color(0xFF69C9C6);
  MaterialColor? defaultAppColors;

  Map<int, double> fontSizeMap = <int, double>{
    1: 120.0,
    2: 56.0,
    3: 48.0,
    4: 36.0,
    5: 32.0,
    6: 26.0,
    7: 24.0,
    8: 22.0,
    9: 18.0,
  };

  String fontFamilyName = "PingFang";
  Map fontWeightMap = {1: FontWeight.bold, 2: FontWeight.w500};

  GLAppStyleConfig() {
    colorsMap = <int, Color>{
      1: Color(0xFF282828),
      2: Color(0xFF818181),
      3: Color(0xFFB4B4B4),
      4: Colors.white,
      5: primaryColor,
      6: Color(0xFFF38F1C),
      7: Colors.lightBlue,
      0: Color(0xFFF4511E),
    };

    defaultAppColors = MaterialColor(
      defaultColorValue,
    <int, Color>{
    50: Color(0xFFDDF0F0),
    100: Color(0xFFC9EFEE),
    200: Color(0xFFB6EAE9),
    300: Color(0xFF9EE7E4),
    400: Color(0xFF84D9D7),
    500: defaultAppColor,
    600: Color(0xFF4FBFBB),
    700: Color(0xFF3CAEAA),
    800: Color(0xFF30A3A0),
    900: Color(0xFF1F8C88),
    },
    );
  }
}

class GLAppStyle {
  static GLAppStyle _instance = GLAppStyle._();

  static GLAppStyle get instance => _instance;

  static changeStyleWithConfig(GLAppStyleConfig config) {
    GLAppStyle.instance.updateConfig(config);
  }

  GLAppStyle._();

  GLAppStyleConfig _currentConfig = GLAppStyleConfig();

  GLAppStyleConfig get currentConfig => _currentConfig;

  void updateConfig(GLAppStyleConfig config) {
    _currentConfig = config;
    // TODO: make notify.
  }
}

// 快速访问方法
Map<int, Color> get GLColorMap => GLAppStyle.instance.currentConfig.colorsMap;