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

class GLAsyncResult<T> {
  final bool isSuccessful;

  final T result;
  final int errorCode;
  final String errorDesc;

  final dynamic extra;

  GLAsyncResult(this.isSuccessful, {this.result, this.errorCode, this.errorDesc, this.extra});

  static failedWith(GLAsyncResult res) {
    return GLAsyncResult(false, errorDesc: res.errorDesc, errorCode: res.errorCode, result: null);
  }

  @override
  String toString() {
    return "isSuccessful: $isSuccessful, error: $errorDesc - $errorCode";
  }
}

/// Style format: 大小-颜色-字体. e.g "321"
TextStyle GLTextStyle(String style) {
  assert(style.length >= 3);
  var _config = GLAppStyle.instance.currentConfig;
  int iFontSize;
  int iColor;
  int iFontWeight;
  if (style.contains(',')) {
    var _eles = style.split(',');
    iFontSize = int.tryParse(_eles[0]) ?? 1;
    iColor = int.tryParse(_eles[1]) ?? 1;
    iFontWeight = int.tryParse(_eles[2]) ?? 1;
  }else {
    iFontSize = int.tryParse(style[0]) ?? 1;
    iColor = int.tryParse(style[1]) ?? 1;
    iFontWeight = int.tryParse(style[2]) ?? 1;
  }

  return TextStyle(
    fontSize: _config.fontSizeMap[iFontSize] / 2,
    //1.3281472327365
    color: _config.colorsMap[iColor],
    fontFamily: _config.fontFamilyName,
    fontStyle: FontStyle.normal,
    fontWeight: _config.fontWeightMap[iFontWeight],
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

const String GL_ICON_BASE = "res/svg/";
const String GL_IMAGE_BASE = "res/png/";
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
      Widget placeholder,
      // VoidCallback completion,
      }) {
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
      // imageBuilder: (ctx, imgProvider) {
      //   print('aAAAAAA: imgProvider: $imgProvider');
      //   print('completion!!!!');
      //   return Image(image: imgProvider, fit: BoxFit.cover,);
      // },
      // progressIndicatorBuilder: (ctx, url, progress) {
      //   print('progress: ${progress.progress}');
      //   if (progress.downloaded == progress.totalSize) {
      //     print('completion!!!!');
      //     completion?.call();
      //   }
      //   if (placeholder != null) return placeholder;
      //   return SpinKitFadingCircle(size: 25, color: GLAppStyle.instance.currentConfig.primaryColor);
      // },
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
