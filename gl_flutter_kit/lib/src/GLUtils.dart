import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'GLTapped.dart';

/**
 * Created by GrayLand119
 * on 2020/12/2
 */
class GLUtils {
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

typedef IntCallback = int Function();
typedef BoolCallback = Future<bool> Function();

const Color GLSplashColor = Color(0xFFB4E4E2);
const Color GLSeperatorColor = Color(0xFFEDECE8);
const Color GLSessionColor = Color(0x3FEDECE8);
const Color GLBackgroundColor = Color(0xFFEBECED);
const Color GLPrimaryColor = Color(0xFF69C9C6);

const double kDefaultPaddingHorizontal = 16.0;

/// Unit : pt
const GLFontSizeMap = <int, double>{
  1: 120.0,
  2: 56.0,
  3: 48.0,
  4: 36.0,
  5: 32.0,
  6: 26.0,
  7: 24.0,
  8: 22.0,
};

const GLColorMap = <int, Color>{
  1: Color(0xFF282828),
  2: Color(0xFF818181),
  3: Color(0xFFB4B4B4),
  4: Colors.white,
  5: GLPrimaryColor,
  6: Color(0xFFF38F1C),
  7: Colors.lightBlue,
  0: Color(0xFFF4511E),
};

abstract class GLMaterialColor {
  static const _defaultAppColor = 0xFF69C9C6;
  static const MaterialColor defaultAppColor = MaterialColor(
    _defaultAppColor,
    <int, Color>{
      50: Color(0xFFDDF0F0),
      100: Color(0xFFC9EFEE),
      200: Color(0xFFB6EAE9),
      300: Color(0xFF9EE7E4),
      400: Color(0xFF84D9D7),
      500: Color(_defaultAppColor),
      600: Color(0xFF4FBFBB),
      700: Color(0xFF3CAEAA),
      800: Color(0xFF30A3A0),
      900: Color(0xFF1F8C88),
    },
  );
}

const GLFontWeightMap = {1: FontWeight.bold, 2: FontWeight.w500};

/// Style format: 大小-颜色-字体. e.g "321"
TextStyle GLTextStyle(String style) {
  assert(style.length >= 3);

  return TextStyle(
    fontSize: GLFontSizeMap[int.parse(style[0])] / 2,
    //1.3281472327365
    color: GLColorMap[int.parse(style[1])],
    fontFamily: "PingFang",
    fontStyle: FontStyle.normal,
    fontWeight: GLFontWeightMap[int.parse(style[2])],
    decoration: TextDecoration.none,
  );
}

double SCREEN_WIDTH = 0.0;
double SCREEN_HEIGHT = 0.0;
double PIXEL_RATIO = 0.0;

double SCALE_WIDTH(width) {
  return width / 375.0 * SCREEN_WIDTH;
}

double SCALE_HEIGHT(height) {
  return height / 667.0 * SCREEN_HEIGHT;
}

Text GLText(String text, String style,
    {TextAlign textAlign = TextAlign.start,
    int maxLines,
    bool softWrap,
    TextOverflow overflow = TextOverflow.visible}) {
  return Text(
    text,
    style: GLTextStyle(style),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    softWrap: softWrap,
  );
}

TextSpan GLTextSpan(String text, String style) {
  return TextSpan(text: text, style: GLTextStyle(style));
}

TextPainter GLTextPainter(String text, String style,
    {TextAlign textAlign = TextAlign.center,
    double minWidth = 0.0,
    double maxWidth = double.infinity}) {
  final textStyle = GLTextStyle(style);
  final textSpan = TextSpan(
    text: text,
    style: textStyle,
  );
  final textPainter = TextPainter(
    text: textSpan,
    textAlign: textAlign,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout(
    minWidth: minWidth,
    maxWidth: maxWidth,
  );
  return textPainter;
}

const String ICON_BASE = "res/icons/";
const String IMAGE_BASE = "res/images/";
const String SVG_EXTENSION = "svg";
const String PNG_EXTENSION = "png";


Widget GLLoadingCircle() => SpinKitFadingCircle(size: 25, color: GLColorMap[5]);

class GLImage {
  static svgAsset(
    String name, {
    String base = ICON_BASE,
    String extension = SVG_EXTENSION,
    double width,
    double height,
    Color color,
    BoxFit fit = BoxFit.contain,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) {
    return SvgPicture.asset(
      "$base$name.$extension",
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
    );
  }

  /// imgUrl can be a local file path.
  static netImage(
      {@required String imgUrl,
      double width,
      double height,
      BoxFit fit = BoxFit.cover,
      Widget placeholder}) {
    if (imgUrl.startsWith('/')) {
      return Image.file(
        File(imgUrl),
        width: width,
        height: height,
        fit: fit,
      );
    }
    if (placeholder == null) {
      placeholder = SpinKitFadingCircle(size: 25, color: GLColorMap[5]);
      // placeholder = GLImage.svgAsset('icon_avatar', color: UIPrimaryColor);
    }
    return CachedNetworkImage(
      fit: fit,
      imageUrl: imgUrl,
      width: width,
      height: height,
      placeholder: (ctx, url) {
        return placeholder;
      },
    );
  }

  static localAsset(
    String name, {
    String base = IMAGE_BASE,
    String extension = PNG_EXTENSION,
    double width,
    double height,
    Color color,
    BoxFit fit = BoxFit.contain,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) {
    return Image.asset(
      "$base$name.$extension",
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
    );
  }
}

Widget GLImageButton({Widget image, Widget title, VoidCallback onTap}) {
  if (title != null) {
    return GLTapped(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          SizedBox(
            child: Center(child: title),
            height: 32,
          ),
        ],
      ),
    );
  } else {
    return GLTapped(
      onTap: onTap,
      child: image,
    );
  }
}
