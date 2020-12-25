import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';
import 'GLUtils.dart';

/// Created by GrayLand119
/// on 2020/12/17
enum GLHUDType {
  dismissed,
  loading,
  message,
  /// using the [GLHUD] indicatorChild property.
  custom,
}

class GLHUD extends StatefulWidget {
  Widget customChild;
  final Widget child;
  final bool cancelEnable;
  final double pannelWidth;
  final double pannelHeight;

  Duration fadeDuration = const Duration(milliseconds: 200);
  VoidCallback didDismissed;
  Color maskColor;

  final GLHUDType initialState;

  WillPopCallback onWillPop;

  static GLHUDState of(BuildContext context) {
    assert(context != null);
    return context.findAncestorStateOfType<GLHUDState>();
  }

  static GlobalKey<GLHUDState> genKey() => GlobalKey<GLHUDState>();

  GLHUD({
    @required this.child,
    this.initialState = GLHUDType.dismissed,
    this.cancelEnable = true,
    this.customChild,
    this.maskColor,
    this.onWillPop,
    this.pannelWidth = 140,
    this.pannelHeight = 140,
    Key key,
  }) : super(key: key) {
    if (maskColor == null) {
      maskColor = Colors.black.withAlpha(100);
    }
  }

  @override
  GLHUDState createState() {
    // _curState = _GLHUDState();
    return GLHUDState();
  }
}

class GLHUDState extends State<GLHUD> with TickerProviderStateMixin {
  GLHUDType _hudState;

  String _content;
  String _contentLast;
  String _title;

  Timer _delayHideTimer;

  Duration _autoHideDuration;

  VoidCallback _timeOutCallback;

  GLHUDType get hudState => _hudState;

  set hudState(GLHUDType v) {
    // dlog.i('set hudState $v');
    if (v != _hudState) {
      setState(() {
        _hudState = v;
      });
    }
  }

  bool update;
  AnimationController _fadeController;
  // AnimationController _rotateController;
  Animation _animation;
  Tween<double> _opacityTween;

  @override
  void initState() {
    _hudState = widget.initialState;
    // _hudState = GLHUDType.dismissed;
    super.initState();

    _fadeController = AnimationController(duration: widget.fadeDuration, vsync: this);
    // _rotateController = AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_fadeController);
    // _opacityTween = Tween(begin: 0.0, end: 1.0);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _delayHideTimer?.cancel();
    // _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _child = Material(
      child: Stack(
        children: [
          widget.child,
          _hud(),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: _child,
    );

    // if (_hudState == GLHUDType.dismissed) {
    //
    // }else {
    //   return WillPopScope(
    //     onWillPop: widget.onWillPop != null ? widget.onWillPop : () async {
    //       return true;
    //       if (_hudState != GLHUDType.dismissed) {
    //         dlog.w("Not allow pop when showing hud");
    //         return false;
    //       }
    //       return true;
    //     },
    //     child: _child,
    //   );
    // }

  }

  void _show() {
    // if (_hudState == GLHUDType.loading) {
    // _rotateController.repeat();
    // }else {
    // _rotateController.stop();
    // }
    if (!_fadeController.isCompleted) {
      _fadeController.forward();
    }
  }

  void _dismiss() {
    // _rotateController.stop();
    if (!_fadeController.isDismissed) {
      _fadeController?.reverse();
    }
    widget.didDismissed?.call();
  }

  Widget _hud() {
    var child;
    switch (_hudState) {
      case GLHUDType.dismissed:
        {
          _dismiss();
          break;
        }

      case GLHUDType.custom:
        {
          _show();
          child = Center(child: widget.customChild);
          break;
        }

      case GLHUDType.message: {
        _show();
        bool _hasTitle = (_title?.length ?? 0) > 0;
        bool _hasContent = (_content?.length ?? 0) > 0;
        List<Widget> _cols = [];
        double _exH = 0.0;
        double _exW = 0.0;
        if (_hasTitle) {
          Text _t1 = GLText(_title, '411');
          _cols.add(_t1);
        }else {
          _exH -= 50.0;
        }

        if (_hasContent) {
          Text _t1 = GLText(_content, '522', textAlign: TextAlign.center);
          Size _s1 = _t1.layout(maxWidth: SCREEN_WIDTH - 100);
          // dlog.i('_s1 h : ${_s1.height}');
          if (_s1.width > widget.pannelWidth - 50.0) {
            _exW += _s1.width - widget.pannelWidth + 50.0;
          }
          if (_s1.height > 60) {
            _exH += _s1.height - 60;
          }
          if (_hasTitle) _cols.add(SizedBox(height: 20,));
          _cols.add(_t1);
        }

        child = _defaultContainer(
            exWidth: _exW,
            exHeight: _exH,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _cols,
            ));

        // if (_contentLast != _content) {
        //   dlog.w('message: _autoHideDuration: ${_autoHideDuration}');
        //   _delayHideTimer?.cancel();
        //   _delayHideTimer = Timer(_autoHideDuration, () {
        //     dlog.w('message: on hide');
        //     hide();
        //   });
        //   _contentLast = _content;
        // }

        break;
      }
      case GLHUDType.loading:
      default:
        {
          _show();
          // var _r1 = RotationTransition(
          //   turns: Tween(begin: 0.0, end: pi * 2).animate(_rotateController),
          //   child: Icon(
          //     Icons.autorenew_rounded,
          //     size: 80,
          //     color: Colors.deepOrange,
          //   ));

          // var _r2 = SpinKitSpinningCircle(color: UIPrimaryColor,);
          // var _r2 = SpinKitRotatingPlain(color: UIPrimaryColor,);
          // var _r2 = SpinKitRotatingCircle(color: UIPrimaryColor,);
          bool _hasTitle = (_title?.length ?? 0) > 0;
          bool _hasContent = (_content?.length ?? 0) > 0;
          double _iconSize = 50.0;
          if (_hasTitle) _iconSize-=10.0;
          if (_hasContent) _iconSize-=10.0;
          var _spin = SpinKitWave(
            color: GLPrimaryColor,
            itemCount: 12,
            size: _iconSize,
          );
          // var _spin = SpinKitThreeBounce(
          //   color: UIPrimaryColor,
          //   // itemCount: 12,
          //   size: 32,
          // );

          List<Widget> _cols = [];
          double _exH = 0.0;
          double _exW = 0.0;
          if (_hasTitle) {
            Text _t1 = GLText(_title, '411');
            _cols.add(_t1);
            _cols.add(Spacer());
            _exH += 20.0;
          }else  {
            _cols.add(Spacer());
          }

          _cols.add(_spin);

          if (_hasContent) {
            Text _t1 = GLText(_content, '522', textAlign: TextAlign.center);
            Size _s1 = _t1.layout(maxWidth: SCREEN_WIDTH - 100);
            if (_s1.width > widget.pannelWidth - 32.0) {
              _exW += _s1.width - widget.pannelWidth + 32.0;
            }
            if (_s1.height > 30) {
              _exH += _s1.height - 10;
            }
            _cols.add(Spacer());
            _cols.add(_t1);
          }else {
            _cols.add(Spacer());
          }

          child = _defaultContainer(
              exWidth: _exW,
              exHeight: _exH,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _cols,
              ));
        }
    }

    return AnimatedBuilder(
        animation: _animation,
        child: child,
        builder: (ctx, child) {
          return Visibility(
            visible: _animation.value > 0,
            child: Opacity(
              opacity: _animation.value,
              child: Container(
                color: widget.maskColor,
                child: child,
              ),
            ),
          );
        });
  }

  Widget _defaultContainer({Widget child, double exWidth=0.0, double exHeight=0.0}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: widget.pannelWidth + exWidth,
        height: widget.pannelHeight + exHeight,
        decoration:
        BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.white),
        child: child,
      ),
    );
  }

  void showLoading({String title, String message, Duration timeOut = const Duration(seconds: 30), VoidCallback timeOutCallback}) {
    _title = title;
    _content = message;
    _autoHideDuration = timeOut;
    _timeOutCallback = timeOutCallback;
    hudState = GLHUDType.loading;

    if (_autoHideDuration != null) {
      _delayHideTimer?.cancel();
      // dlog.i('loading: _autoHideDuration: ${_autoHideDuration}');
      _delayHideTimer = Timer(_autoHideDuration, () {
        _timeOutCallback?.call();
        // dlog.i('loading: on hide');
        hide();
      });
    }
  }

  void showErrorMessage({String message}) {
    // dlog.w('showErrorMessage, $message');
    // TODO: 添加失败图标
    showMessage(title: '出错啦', message: message);
  }

  void showSuccessMessage({String message}) {
    // TODO: 添加成功图标
    showMessage(message: message);
  }

  void showMessage({String title, String message, Duration duration = const Duration(milliseconds: 1200)}) {
    _delayHideTimer?.cancel();
    _title = title;
    _content = message;
    _autoHideDuration = duration;
    hudState = GLHUDType.message;

    // dlog.i('message: _autoHideDuration: ${_autoHideDuration}');
    _delayHideTimer?.cancel();
    _delayHideTimer = Timer(_autoHideDuration, () {
      // dlog.i('message: on hide');
      hide();
    });
  }

  void showCustom({Widget child, Duration timeOut = const Duration(seconds: 30), VoidCallback timeOutCallback}) {
    if (child != null) {
      widget.customChild = child;
    }

    _autoHideDuration = timeOut;
    _timeOutCallback = timeOutCallback;
    hudState = GLHUDType.custom;

    if (_autoHideDuration != null) {
      _delayHideTimer?.cancel();
      // dlog.i('loading: _autoHideDuration: ${_autoHideDuration}');
      _delayHideTimer = Timer(_autoHideDuration, () {
        _timeOutCallback?.call();
        // dlog.i('loading: on hide');
        hide();
      });
    }
  }

  void hide() {
    _title = null;
    _content = null;
    _autoHideDuration = null;
    _delayHideTimer?.cancel();
    _timeOutCallback = null;
    _dismiss();
    hudState = GLHUDType.dismissed;
  }
}