import 'package:flutter/material.dart';

class GLTapped extends StatefulWidget {
  GLTapped({this.child, this.onTap, this.onLongTap, this.onTapParent, this.behavior});
  final HitTestBehavior behavior;
  final Widget child;
  final Function onTap;
  final Function(Widget w) onTapParent;
  final Function onLongTap;

  @override
  _GLTappedState createState() => _GLTappedState();
}

class _GLTappedState extends State<GLTapped> with SingleTickerProviderStateMixin {
  bool _isChangeAlpha = false;

  AnimationController _controller;
  Animation _animation;

  Duration _tapInterval = const Duration(milliseconds: 200);

  @override
  void initState() {
    _controller = AnimationController(value: 1, vsync: this);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _animation.addListener(() {
      this.setState(() {});
    });
    super.initState();
  }

  bool _tapDown = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool _isTapped = false;
  @override
  Widget build(BuildContext context) {
    Duration duration = const Duration(milliseconds: 50);
    Duration showDuration = const Duration(milliseconds: 660);
    
    return GestureDetector(
      behavior: widget.behavior,
      onTap: () async {
        if (_isTapped) return;
        _isTapped = true;
        if (widget.onTapParent != null) {
          widget.onTapParent.call(widget);
        }else {
          widget.onTap?.call();
        }
        await Future.delayed(_tapInterval);
        _isTapped = false;
      },
      onLongPress: widget.onLongTap == null
          ? null
          : () async {
              await Future.delayed(Duration(milliseconds: 100));
              widget.onLongTap();
            },
      onTapDown: (detail) async {
        _tapDown = true;
        _isChangeAlpha = true;
        await _controller.animateTo(0.4, duration: duration);
        if (!_tapDown) {
          await _controller.animateTo(1, duration: showDuration);
        }
        _tapDown = false;
        _isChangeAlpha = false;
      },
      onTapUp: (detail) async {
        _tapDown = false;
        if (_isChangeAlpha == true) {
          return;
        }
        await _controller.animateTo(1, duration: showDuration);
        _isChangeAlpha = false;
      },
      onTapCancel: () async {
        _tapDown = false;
        _controller.value = 1;
        _isChangeAlpha = false;
      },
      child: Opacity(
        opacity: _animation.value,
        child: widget.child,
      ),
    );
  }
}
