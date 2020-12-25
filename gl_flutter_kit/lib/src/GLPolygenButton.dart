import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'GLTapped.dart';

/// Created by GrayLand119
/// on 2020/12/15
class GLPolygenButton extends StatelessWidget {
  final Widget child;
  final Path maskPath;

  VoidCallback onTap;

  final Color maskColor;

  GLPolygenButton({this.child, this.maskPath, this.maskColor, this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Rect maskBounds = maskPath.getBounds();
    var _v = CustomPaint(
      painter: GLPolygenPainter(maskPath: maskPath, maskColor: maskColor),
      child: child ?? Container(height:maskBounds.height,width: maskBounds.width,),
    );

    if (onTap == null) {
      return _v;
    } else {
      return GLTapped(
        onTap: onTap,
        child: _v,
      );
    }
  }
}

class GLPolygenPainter extends CustomPainter {
  Path maskPath;

  Color maskColor;

  GLPolygenPainter({this.maskPath, this.maskColor}) {
    if (maskColor == null) {
      maskColor = Colors.black87;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (maskPath == null) {
      maskPath = Path();
      final double _halfW = size.width / 2.0;
      final double _halfH = size.height / 2.0;
      final double _arrowR = 5.0;
      maskPath.moveTo(0, 0);
      maskPath.lineTo(_halfW, 0);
      maskPath.lineTo(_halfW, _halfH - _arrowR);
      maskPath.lineTo(_halfW + _arrowR, _halfH);
      maskPath.lineTo(_halfW, _halfH + _arrowR);
      maskPath.lineTo(_halfW, size.height);
      maskPath.lineTo(0, size.height);
      maskPath.close();
    }
    canvas.drawPath(
        maskPath,
        Paint()
          ..style = PaintingStyle.fill
          ..color = maskColor);
  }

  @override
  bool hitTest(Offset position) {
    return maskPath.contains(position);
    // return super.hitTest(position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
