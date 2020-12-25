import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'GLUtils.dart';

/// Created by GrayLand119
/// on 2020/12/8
class GLDrawerBuilder<T> extends PageRouteBuilder<T> {
  Widget child;
  double widthFactor;

  Color backgroundColor;

  BoolCallback willPopBack;

  GLDrawerBuilder({
    this.child,
    this.widthFactor = 0.7,
    this.backgroundColor = Colors.black54,
    this.willPopBack,
    Duration showDuration = const Duration(milliseconds: 220),
    Duration dismissDuration = const Duration(milliseconds: 220),
  }) : super(
      transitionDuration: showDuration,
      reverseTransitionDuration: dismissDuration,
      opaque: false,
      pageBuilder: (context, animation1, animation2) {
        double _width = MediaQuery.of(context).size.width * widthFactor;

        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              FadeTransition(
                opacity: animation1,
                child: GestureDetector(
                  child: Container(
                    color: backgroundColor,
                  ),
                  onTap: () async {
                    if (willPopBack != null) {
                      bool res = await willPopBack.call();
                      if (res) {
                        Navigator.pop(context);
                      }
                    }else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              AnimatedBuilder(animation: animation1, builder: (ctx, c) {
                return Transform.translate(
                  offset: Offset((animation1.value - 1.0) * _width, 0.0), child: c,);
              }, child: Container(width: _width, child: child,),),
            ],
          ),
        );
      });
}