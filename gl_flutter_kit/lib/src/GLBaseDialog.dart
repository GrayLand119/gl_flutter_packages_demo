import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';
import 'GLMarco.dart';
import 'GLUtils.dart';

/// Created by GrayLand119
/// on 2020/12/3
class GLAlertDialog extends StatefulWidget {
  final String? title;
  final String? content;
  final String cancelTitle;
  final String okTitle;
  final Color maskColor;
  final Color backgroundColor;
  final Axis actionAxis;
  final bool isDangerousAction;
  final bool tapAnywhereToDismiss;
  final String titleStyle;
  final String contentStyle;
  final String cancelTitleStyle;
  final String okTitleStyle;

  GLAlertDialog({
    this.title,
    this.titleStyle = '511',
    this.contentStyle = '612',
    this.content,
    this.cancelTitle = '取消',
    this.cancelTitleStyle = '552',
    this.okTitleStyle = '552',
    this.okTitle = '',
    this.maskColor = const Color(0x4DAEAE),
    this.backgroundColor = Colors.white,
    this.actionAxis = Axis.horizontal,
    this.tapAnywhereToDismiss = false,
    this.isDangerousAction = false,
    Key? key})
      : super(key: key);

  // static Future<dynamic> show(BuildContext context,
  //     {String title,
  //       String titleStyle = '511',
  //       String content,
  //       String contentStyle = '612',
  //       String cancelTitle = '取消',
  //       String cancelTitleStyle = '552',
  //       String okTitle = '',
  //       String okTitleStyle = '552',
  //       Color maskColor = const Color(0x4DAEAE),
  //       Axis actionAxis = Axis.horizontal,
  //       bool isDangerousAction = false,
  //       bool tapAnywhereToDismiss = false,
  //       Key key,}) async {
  //   return await showDialog(
  //       context: context,
  //       child: GLAlertDialog(
  //         key: key,
  //         title: title,
  //         titleStyle: titleStyle,
  //         content: content,
  //         contentStyle: contentStyle,
  //         cancelTitle: cancelTitle,
  //         cancelTitleStyle: cancelTitleStyle,
  //         okTitle: okTitle,
  //         okTitleStyle: okTitleStyle,
  //         maskColor: maskColor,
  //         actionAxis: actionAxis,
  //         tapAnywhereToDismiss: tapAnywhereToDismiss,
  //         isDangerousAction: isDangerousAction,
  //       )) ??
  //       false;
  // }

  show(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) => GLAlertDialog(
        key: key,
        title: title,
        titleStyle: titleStyle,
        content: content,
        contentStyle: contentStyle,
        cancelTitle: cancelTitle,
        cancelTitleStyle: cancelTitleStyle,
        okTitle: okTitle,
        okTitleStyle: okTitleStyle,
        maskColor: maskColor,
        actionAxis: actionAxis,
        backgroundColor: backgroundColor,
        tapAnywhereToDismiss: tapAnywhereToDismiss,
        isDangerousAction: isDangerousAction,
      )
    ) ?? false;

    // return await showDialog(
    //     context: context,
    //     child: GLAlertDialog(
    //       key: key,
    //       title: title,
    //       titleStyle: titleStyle,
    //       content: content,
    //       contentStyle: contentStyle,
    //       cancelTitle: cancelTitle,
    //       cancelTitleStyle: cancelTitleStyle,
    //       okTitle: okTitle,
    //       okTitleStyle: okTitleStyle,
    //       maskColor: maskColor,
    //       actionAxis: actionAxis,
    //       backgroundColor: backgroundColor,
    //       tapAnywhereToDismiss: tapAnywhereToDismiss,
    //       isDangerousAction: isDangerousAction,
    //     )) ??
    //     false;
  }

  @override
  _GLAlertDialogState createState() => _GLAlertDialogState();
}

class _GLAlertDialogState extends State<GLAlertDialog> with SingleTickerProviderStateMixin {
  late AnimationController _springController;
  late Animation _springAnimation;
  late SpringDescription _springDescription;
  late SpringSimulation _springSimulation;
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

    String? title = widget.title;
    double totalH = 0.0;
    double maxWidth = SCALE_WIDTH(277);
    var titleWidget;
    if ((title?.length ?? 0) > 0) {
      totalH += 46;
      titleWidget = Container(
        child: SizedBox(
          child: GLText(title ?? "", widget.titleStyle),
          height: 46,
        ),
      );
    }
    if (titleWidget != null) {
      elements.add(titleWidget);
    }

    String content = widget.content ?? "";
    var contentWidget;
    if (content.length > 0) {
      var tP = TextPainter(
          text: GLTextSpan(content, widget.contentStyle), maxLines: 6, textDirection: TextDirection.ltr)
        ..layout(maxWidth: maxWidth - 24);

      contentWidget =
          Container(padding: EdgeInsets.symmetric(horizontal: 12),
              child: GLText(content, widget.contentStyle, textAlign: TextAlign.center), height: tP.height);
      totalH += tP.height;
    }

    if (contentWidget != null) {
      elements.add(contentWidget);
    }

    List<Widget> actions = [];
    if (actions.isEmpty) {
      actions.add(Expanded(
          child: TextButton(
            onPressed: () => _dismiss(false),
            child: GLText(widget.cancelTitle, widget.cancelTitleStyle),
            style: TextButton.styleFrom(minimumSize: Size(0, 50)),
            // height: 50,
          )));
    }

    String okTitle = widget.okTitle;
    if (okTitle.isNotEmpty) {
      actions.add(Expanded(
          child: TextButton(
            onPressed: () => _dismiss(true),
            child: GLText(okTitle, widget.isDangerousAction ? '502' : widget.okTitleStyle),
            style: TextButton.styleFrom(minimumSize: Size(0, 50)),
            // height: 50,
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
      color: widget.backgroundColor,
      constraints: BoxConstraints(maxHeight: totalH),
      child: Column(
        children: elements,
      ),
    );

    var dialog = Container(
      width: maxWidth,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
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
