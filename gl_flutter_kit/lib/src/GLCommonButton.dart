import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';
import 'GLUtils.dart';

/// Created by GrayLand119
/// on 2020/12/3
class GLCommonButton extends StatelessWidget {
  final String? title;
  final String style;
  final double height;
  final double width;

  GLVoidCallback? onTap;

  EdgeInsets padding;

  final bool isRoundRect;

  /// 增加了简易版(加锁或定时器浪费资源)防止多次点击处理.
  GLCommonButton(
      {this.title,
        this.style = '542',
        this.height = 50.0,
        this.width = double.infinity,
        this.padding = const EdgeInsets.symmetric(horizontal: 45),
        this.onTap,
        this.isRoundRect = true,
        Key? key})
      : super(key: key);

  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        height: height,
        width: width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: onTap == null ?
            GLAppStyle.instance.currentConfig.splashColor :
            GLAppStyle.instance.currentConfig.primaryColor,
            borderRadius: isRoundRect ? BorderRadius.circular(height / 2.0) : BorderRadius.zero),
        child: TextButton(
          onPressed: onTap == null ? null : () async {
            if (_tapped) return;
            _tapped = true;
            await onTap?.call();
            _tapped = false;
          },
          child: GLText(title ?? "", style),
          // splashColor: GLAppStyle.instance.currentConfig.separatorColor,
        ),
      ),
    );
  }
}