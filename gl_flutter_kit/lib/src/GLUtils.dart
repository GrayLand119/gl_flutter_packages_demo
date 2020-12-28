import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';
import 'GLTapped.dart';

/// Created by GrayLand119
/// on 2020/12/2
class GLUtils {
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
  /// android 平台半透明状态栏设置为透明
  static void makeAndroidStatusBarTransparent(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}

typedef IntCallback = int Function();
typedef BoolCallback = Future<bool> Function();

const double kDefaultPaddingHorizontal = 16.0;

/// Style format: 大小-颜色-字体. e.g "321"
TextStyle GLTextStyle(String style) {
  assert(style.length >= 3);
  var _config = GLAppStyle.instance.currentConfig;
  return TextStyle(
    fontSize: _config.fontSizeMap[int.parse(style[0])] / 2,
    //1.3281472327365
    color: _config.colorsMap[int.parse(style[1])],
    fontFamily: _config.fontFamilyName,
    fontStyle: FontStyle.normal,
    fontWeight: _config.fontWeightMap[int.parse(style[2])],
    decoration: TextDecoration.none,
  );
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

const String GL_ICON_BASE = "res/icons/";
const String GL_IMAGE_BASE = "res/images/";
const String GL_SVG_EXTENSION = "svg";
const String GL_PNG_EXTENSION = "png";


Widget GLLoadingCircle() => SpinKitFadingCircle(size: 25, color: GLAppStyle.instance.currentConfig.primaryColor);

class GLImage {
  static svgAsset(
    String name, {
    String base = GL_ICON_BASE,
    String extension = GL_SVG_EXTENSION,
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
      placeholder = SpinKitFadingCircle(size: 25, color: GLAppStyle.instance.currentConfig.primaryColor);
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
    String base = GL_IMAGE_BASE,
    String extension = GL_PNG_EXTENSION,
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
