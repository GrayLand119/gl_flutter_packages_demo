import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'GLUtils.dart';

/**
 * Created by GrayLand119
 * on 2020/12/3
 */
class GLNavigationItem extends StatelessWidget {
  final Color color;
  final double width;
  final Widget child;
  final VoidCallback onPressed;

  GLNavigationItem({this.color, this.width = 44.0, this.child, this.onPressed, Key key})
      : super(key: key);

  bool _tapped = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: width,
      child: CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 14), child: child, onPressed: onPressed == null ? null : () async {
        if (_tapped) return;
        _tapped = true;
        onPressed();
        await Future.delayed(Duration(milliseconds: 100));
        _tapped = false;
      }),
    );
  }
}
