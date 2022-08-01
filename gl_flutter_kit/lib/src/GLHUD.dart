import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
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
  progress,

  /// using the [GLHUD] indicatorChild property.
  custom,
}

class GLHUD extends StatefulWidget {
  Widget? customChild;

  final Widget child;
  final bool cancelEnable;
  final double pannelWidth;
  final double pannelHeight;
  final String titleStyle;
  final String contentStyle;

  Duration fadeDuration = const Duration(milliseconds: 200);
  VoidCallback? didDismissed;
  Color? maskColor;
  Color? hudBackgroundColor;
  final GLHUDType initialState;

  WillPopCallback? onWillPop;

  @override
  static GLHUDState? of(BuildContext context) {
    assert(context != null);
    return context.findAncestorStateOfType<GLHUDState>();
  }

  @override
  static GlobalKey<GLHUDState> genKey() => GlobalKey<GLHUDState>();

  GLHUD({
    required this.child,
    this.initialState = GLHUDType.dismissed,
    this.cancelEnable = true,
    this.customChild,
    this.maskColor,
    this.hudBackgroundColor,
    this.onWillPop,
    this.pannelWidth = 140,
    this.pannelHeight = 140,
    this.titleStyle = '512',
    this.contentStyle = '623',
    Key? key,
  }) : super(key: key) {
    if (maskColor == null) {
      maskColor = Colors.black.withOpacity(0.4);
    }
    if (hudBackgroundColor == null) {
      hudBackgroundColor = Colors.white;
    }
  }

  @override
  GLHUDState createState() {
    return GLHUDState(titleStyle: titleStyle, contentStyle: contentStyle);
  }
}

class GLHUDState extends State<GLHUD> with TickerProviderStateMixin {
  late GLHUDType _hudState;

  /// Default text style is '511', meaning use fotmat like that:
  /// GLAppStyle.instance.currentConfig.fontSizeMap[5]
  /// GLAppStyle.instance.currentConfig.colorsMap[1]
  /// GLAppStyle.instance.currentConfig.fontWeightMap[1]
  String titleStyle;// Title label style
  String contentStyle; // Message label style
  String? _title;
  String? _content; // message
  String? _contentLast;

  Timer? _delayHideTimer;

  Duration? _autoHideDuration;

  VoidCallback? _timeOutCallback;

  Widget? _extendWidget;

  double _extendWidgetHeight = 0.0;
  double _progressValue = 0.0;
  late double _maxWidth;
  late double loadingWidgetWH;

  EdgeInsets padding = EdgeInsets.zero;

  GLHUDType get hudState => _hudState;

  set hudState(GLHUDType v) {
    // dlog.i('set hudState $v');
    if (v != _hudState) {
      setState(() {
        _hudState = v;
      });
    }
  }

  bool? update;
  late AnimationController _fadeController;

  // AnimationController _rotateController;
  late Animation _animation;
  // Tween<double> _opacityTween;

  late double _spaceBetweenTitleAndContent;

  GLHUDState({required this.titleStyle, required this.contentStyle});

  @override
  void initState() {
    // titleStyle = '512';
    // contentStyle = '623';

    padding = const EdgeInsets.all(16.0);
    _spaceBetweenTitleAndContent = 12.0;
     _maxWidth = SCREEN_WIDTH - 100;
    loadingWidgetWH = 50.0;

    _hudState = widget.initialState;

    super.initState();

    _fadeController = AnimationController(duration: widget.fadeDuration, vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_fadeController);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _delayHideTimer?.cancel();
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
      _fadeController.reverse();
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

      case GLHUDType.message:
        child = _messageHUD();
        break;
      case GLHUDType.progress:
        child = _progressHUD();
        break;
      case GLHUDType.loading:
      default:
        child = _loadingHUD();
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

  Widget _defaultContainer({required Widget child, double exWidth = 0.0, double exHeight = 0.0}) {

    return Center(
      child: Container(
        padding: padding,
        width: widget.pannelWidth + exWidth,
        height: widget.pannelHeight + exHeight,
        decoration:
        BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: widget.hudBackgroundColor),
        child: child,
      ),
    );
  }

  void showLoading({String? title, String? message, Duration timeOut = const Duration(
      seconds: 30), VoidCallback? timeOutCallback, Widget? extendWidget, double? extendWidgetHeight}) {
    _title = title;
    _content = message;
    _autoHideDuration = timeOut;
    _timeOutCallback = timeOutCallback;
    hudState = GLHUDType.loading;
    _extendWidget = extendWidget;
    _extendWidgetHeight = extendWidgetHeight ?? 0.0;

    if (_autoHideDuration != null) {
      _delayHideTimer?.cancel();
      // dlog.i('loading: _autoHideDuration: ${_autoHideDuration}');
      _delayHideTimer = Timer(_autoHideDuration!, () {
        _timeOutCallback?.call();
        // dlog.i('loading: on hide');
        hide();
      });
    }
  }

  void showProgress({String? title, String? message, double progress = 0}) {
    _title = title;
    _content = message;
    _extendWidgetHeight = 0;
    _extendWidget = null;
    progress = progress.toStringAsFixed(2).toDouble();
    if (_progressValue != progress) {
      setState(() {
        _progressValue = progress;
      });
    } else {
      _progressValue = progress;
    }

    hudState = GLHUDType.progress;
    _delayHideTimer?.cancel();


    // if (_autoHideDuration != null) {
    //   _delayHideTimer?.cancel();
    //   // dlog.i('loading: _autoHideDuration: ${_autoHideDuration}');
    //   _delayHideTimer = Timer(_autoHideDuration, () {
    //     _timeOutCallback?.call();
    //     // dlog.i('loading: on hide');
    //     hide();
    //   });
    // }
  }

  void showErrorMessage({String? message}) {
    // dlog.w('showErrorMessage, $message');
    // TODO: 添加失败图标
    showMessage(title: '出错啦', message: message, duration: Duration(seconds: 3));
  }

  void showSuccessMessage({String? message}) {
    // TODO: 添加成功图标
    showMessage(message: message);
  }

  void showMessage(
      {String? title, String? message, Duration duration = const Duration(milliseconds: 1200)}) {
    _delayHideTimer?.cancel();
    _title = title;
    _content = message;
    _autoHideDuration = duration;
    hudState = GLHUDType.message;

    // dlog.i('message: _autoHideDuration: ${_autoHideDuration}');
    _delayHideTimer?.cancel();
    _delayHideTimer = Timer(duration, () {
      // dlog.i('message: on hide');
      hide();
    });
  }

  void showCustom({required Widget child, Duration timeOut = const Duration(
      seconds: 30), VoidCallback? timeOutCallback}) {
    if (child != null) {
      widget.customChild = child;
    }

    _autoHideDuration = timeOut;
    _timeOutCallback = timeOutCallback;
    hudState = GLHUDType.custom;

    if (_autoHideDuration != null) {
      _delayHideTimer?.cancel();
      // dlog.i('loading: _autoHideDuration: ${_autoHideDuration}');
      _delayHideTimer = Timer(_autoHideDuration!, () {
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

  @override
  Widget _messageHUD() {
    _show();
    bool _hasTitle = (_title?.length ?? 0) > 0;
    bool _hasContent = (_content?.length ?? 0) > 0;
    List<Widget> _cols = [];

    double minWidth = widget.pannelWidth;

    double calcWidth = padding.horizontal;
    double calcHeight = padding.vertical;

    if (_hasTitle) {
      Text _t1 = GLText(_title ?? "", titleStyle);
      Size _s1 = _t1.layout(maxWidth: _maxWidth, minWidth: minWidth);

      calcWidth = max(calcWidth, _s1.width + padding.horizontal);
      calcHeight += _s1.height;

      _cols.add(_t1);
    }

    if (_hasContent) {
      Text _t1 = GLText(_content ?? "", contentStyle, textAlign: TextAlign.center);
      Size _s1 = _t1.layout(maxWidth: _maxWidth, minWidth: minWidth);

      calcWidth = max(calcWidth, _s1.width + padding.horizontal);
      calcHeight += _s1.height;

      if (_hasTitle) {
        _cols.add(SizedBox(height: _spaceBetweenTitleAndContent,));
        calcHeight += _spaceBetweenTitleAndContent;
      }

      _cols.add(_t1);
    }

    calcWidth = max(calcWidth, widget.pannelWidth);
    calcHeight = max(calcHeight, 70);

    calcWidth = calcWidth - widget.pannelWidth;
    calcHeight = calcHeight - widget.pannelHeight;

    return _defaultContainer(
        exWidth: calcWidth,
        exHeight: calcHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _cols,
        ));
  }

  @override
  Widget _progressHUD() {
    _show();

    bool _hasTitle = (_title?.length ?? 0) > 0;
    bool _hasContent = (_content?.length ?? 0) > 0;

    List<Widget> _cols = [];
    double _exH = padding.vertical;
    double _exW = widget.pannelWidth;

    if (_hasTitle) {
      Text _t1 = GLText(_title ?? "", titleStyle);
      Size _s1 = _t1.layout(maxWidth: _maxWidth);

      _exH += _s1.height + 16.0;
      _exW = max(_exW, _s1.width + padding.horizontal);

      _cols.add(_t1);
      _cols.add(Spacer());
    } else {
      _cols.add(Spacer());
    }

    var _spin = CircularProgressIndicator(
      value: _progressValue, backgroundColor: GLAppStyle.instance.currentConfig.separatorColor,);
    _exH += loadingWidgetWH;
    _cols.add(SizedBox(width: loadingWidgetWH,height: loadingWidgetWH, child: _spin));

    if (_hasContent) {
      Text _t1 = GLText(_content ?? "", contentStyle, textAlign: TextAlign.center);
      Size _s1 = _t1.layout(maxWidth: _maxWidth);

      _exW = max(_s1.width + padding.horizontal, _exW);
      _exH += _s1.height + 16.0;

      _cols.add(Spacer());
      _cols.add(_t1);
    } else {
      _cols.add(Spacer());
    }

    if (_extendWidget != null) {
      _cols.add(SizedBox(height: _extendWidgetHeight,
        child: _extendWidget,));
      _exH += _extendWidgetHeight;
    }

    _exW = _exW - widget.pannelWidth;
    _exH = max(_exH, widget.pannelHeight) - widget.pannelHeight;

    return _defaultContainer(
        exWidth: _exW,
        exHeight: _exH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _cols,
        ));
  }

  @override
  Widget loadingSpinWidget({double? size}) {
    return SpinKitWave(
      color: GLAppStyle.instance.currentConfig.primaryColor,
      itemCount: 12,
      size: size ?? loadingWidgetWH,
    );
  }

  @override
  Widget _loadingHUD() {
    _show();

    // var _r2 = SpinKitSpinningCircle(color: UIPrimaryColor,);
    // var _r2 = SpinKitRotatingPlain(color: UIPrimaryColor,);
    // var _r2 = SpinKitRotatingCircle(color: UIPrimaryColor,);
    bool _hasTitle = (_title?.length ?? 0) > 0;
    bool _hasContent = (_content?.length ?? 0) > 0;

    List<Widget> _cols = [];
    double _exH = padding.vertical;
    double _exW = widget.pannelWidth;

    double _tLoadingWH = loadingWidgetWH;

    if (_hasContent || _hasContent) {
      _tLoadingWH -= 12;
    }

    if (_hasTitle) {
      Text _t1 = GLText(_title ?? "", titleStyle);
      Size _s1 = _t1.layout(maxWidth: _maxWidth);

      _exH += _s1.height + 16;
      _exW = max(_exW, _s1.width + padding.horizontal);
      _cols.add(_t1);
      _cols.add(Spacer());
    } else {
      _cols.add(Spacer());
    }

    var _spin = loadingSpinWidget(size: _tLoadingWH);
    _cols.add(_spin);
    _exH += _tLoadingWH;

    if (_hasContent) {
      Text _t1 = GLText(_content ?? "", contentStyle, textAlign: TextAlign.center);
      Size _s1 = _t1.layout(maxWidth: _maxWidth);

      _exH += _s1.height + 16;
      _exW = max(_exW, _s1.width + padding.horizontal);

      _cols.add(Spacer());
      _cols.add(_t1);
    } else {
      _cols.add(Spacer());
    }

    if (_extendWidget != null) {
      _cols.add(SizedBox(height: _extendWidgetHeight,
        child: _extendWidget,));
      _exH += _extendWidgetHeight;
    }

    _exH = max(_exH, widget.pannelHeight) - widget.pannelHeight;
    _exW = _exW - widget.pannelWidth;

    return _defaultContainer(
        exWidth: _exW,
        exHeight: _exH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _cols,
        ));
  }
}