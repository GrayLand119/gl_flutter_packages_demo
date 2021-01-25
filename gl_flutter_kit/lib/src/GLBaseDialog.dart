import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';
import 'GLMarco.dart';
import 'GLUtils.dart';

/// Created by GrayLand119
/// on 2020/12/3
class GLAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final String cancelTitle;
  final String okTitle;
  final Color maskColor;
  final Axis actionAxis;
  final bool isDangerousAction;
  final bool tapAnywhereToDismiss;

  GLAlertDialog({this.title,
    this.content,
    this.cancelTitle,
    this.okTitle,
    this.maskColor,
    this.actionAxis,
    this.tapAnywhereToDismiss = false,
    this.isDangerousAction,
    Key key})
      : super(key: key);

  static Future<dynamic> show(BuildContext context,
      {String title,
        String content,
        String cancelTitle = '取消',
        String okTitle = '',
        Color maskColor = const Color(0x4DAEAE),
        Axis actionAxis = Axis.horizontal,
        bool isDangerousAction = false,
        bool tapAnywhereToDismiss = false,
        Key key,}) async {
    return await showDialog(
        context: context,
        child: GLAlertDialog(
          key: key,
          title: title,
          content: content,
          cancelTitle: cancelTitle,
          okTitle: okTitle,
          maskColor: maskColor,
          actionAxis: actionAxis,
          tapAnywhereToDismiss: tapAnywhereToDismiss,
          isDangerousAction: isDangerousAction,
        )) ??
        false;
  }

  @override
  _GLAlertDialogState createState() => _GLAlertDialogState();
}

class _GLAlertDialogState extends State<GLAlertDialog> with SingleTickerProviderStateMixin {
  AnimationController _springController;
  Animation _springAnimation;
  SpringDescription _springDescription;
  SpringSimulation _springSimulation;
  double endAlignY = -0.1;

  @override
  void initState() {
    _springController =
        AnimationController.unbounded(vsync: this, duration: Duration(milliseconds: 220));
    _springDescription = SpringDescription(
      mass: 9,
      stiffness: 700,
      damping: 1.5,
    );
    _springSimulation = SpringSimulation(_springDescription, 0, 1, 5.0);
    _springAnimation = Tween(begin: 2.0, end: endAlignY).animate(_springController);

    super.initState();
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adjust config For Debug.
    // _springDescription = SpringDescription(
    //   mass: 9,
    //   stiffness: 700,
    //   damping: 1.5,
    // );
    // _springSimulation = SpringSimulation(_springDescription, 0, 1, 5.0);
    // _springAnimation = Tween(begin: 2.0, end: endAlignY).animate(_springController);

    _springController.animateWith(_springSimulation);

    void Function(dynamic) _dismiss = (value) {
      _springController.animateBack(-1.0, duration: Duration(milliseconds: 5260));
      Navigator.of(context).pop(value);
    };

    var elements = <Widget>[];

    String title = widget.title;
    double totalH = 0.0;
    double maxWidth = SCALE_WIDTH(277);
    var titleWidget;
    if ((title?.length ?? 0) > 0) {
      totalH += 46;
      titleWidget = Container(
        child: SizedBox(
          child: GLText(title, '511'),
          height: 46,
        ),
      );
    }
    if (titleWidget != null) {
      elements.add(titleWidget);
    }

    String content = widget.content;
    var contentWidget;
    if ((content?.length ?? 0) > 0) {
      var tP = TextPainter(
          text: GLTextSpan(content, '612'), maxLines: 6, textDirection: TextDirection.ltr)
        ..layout(maxWidth: maxWidth - 24);

      contentWidget =
          Container(padding: EdgeInsets.symmetric(horizontal: 12),
              child: GLText(content, '612', textAlign: TextAlign.center), height: tP.height);
      totalH += tP.height;
    }

    if (contentWidget != null) {
      elements.add(contentWidget);
    }

    List<Widget> actions = [];
    if (actions.isEmpty) {
      actions.add(Expanded(
          child: FlatButton(
            onPressed: () => _dismiss(false),
            child: GLText(widget.cancelTitle, '552'),
            height: 50,
          )));
    }
    String okTitle = widget.okTitle;
    if (okTitle.isNotEmpty) {
      actions.add(Expanded(
          child: FlatButton(
            onPressed: () => _dismiss(true),
            child: GLText(okTitle, widget.isDangerousAction ? '502' : '552'),
            height: 50,
          )));
    }

    Widget actionContainer;
    double cH = 0.0;
    if (widget.actionAxis == Axis.horizontal) {
      cH += 50.0;

      /// Calculate first
      if (actions.length > 1) {
        actions = actions
            .expand((e) =>
        [
          e,
          Container(
            height: 25,
            width: 1,
            color: GLAppStyle.instance.currentConfig.separatorColor,
          )
        ])
            .toList()
          ..removeLast();
      }
      actionContainer = Row(
        children: actions,
      );
    } else {
      cH = actions.length * 50.0;

      /// Calculate first
      actionContainer = Column(
        children: actions.reversed.toList(),
      );
    }

    totalH += cH;
    totalH += 13.0;
    totalH += 13.0;

    elements.add(Padding(
        padding: EdgeInsets.only(top: 13.0),
        child: SizedBox(
          height: cH,
          child: actionContainer,
        )));

    var board = Container(
      padding: EdgeInsets.only(top: 13.0),
      color: Colors.white,
      constraints: BoxConstraints(maxHeight: totalH),
      child: Column(
        children: elements,
      ),
    );

    var dialog = Container(
      width: maxWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: board,
    );

    var bg = Container(
      color: widget.maskColor,
      child: AnimatedBuilder(
        animation: _springAnimation,
        child: dialog,
        builder: (ctx, child) {
          return Align(
            alignment: Alignment(0, _springAnimation.value),
            child: child,
          );
        },
      ),
    );
    var customDialog = widget.tapAnywhereToDismiss
        ? GestureDetector(
      child: bg,
      onTap: () {
        _dismiss(false);
      },
    )
        : bg;

    return WillPopScope(
      child: customDialog,
      onWillPop: () async {
        _dismiss(false);
        return true;
      },
    );
  }
}
