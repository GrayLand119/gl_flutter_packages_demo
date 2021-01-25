import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';
import 'GLMarco.dart';
import 'GLUtils.dart';

/// Created by GrayLand119
/// on 2020/12/28
class GLSelectDialog extends StatefulWidget {
  final String title;
  final String content;
  final String cancelTitle;
  final Color maskColor;
  final bool tapAnywhereToDismiss;
  final List<String> selectionItems;

  @override
  _State createState() => _State();

  GLSelectDialog(
      {this.title,
      this.content,
      this.selectionItems,
      this.cancelTitle,
      this.maskColor,
      this.tapAnywhereToDismiss = false,
      Key key})
      : super(key: key);

  static Future<dynamic> show(BuildContext context,
      {String title,
      String content,
      String cancelTitle,
      List<String> selectionItems,
      Color maskColor = const Color(0x4DAEAE),
      bool tapAnywhereToDismiss = false}) async {
    return await showDialog(
            context: context,
            child: GLSelectDialog(
              title: title,
              content: content,
              cancelTitle: cancelTitle,
              maskColor: maskColor,
              tapAnywhereToDismiss: tapAnywhereToDismiss,
              selectionItems: selectionItems,
            )) ??
        false;
  }
}

class _State extends State<GLSelectDialog> with SingleTickerProviderStateMixin {
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
    _buildAnimation();

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
    Widget actionContainer;
    double cH = 0.0;

    for (String item in widget.selectionItems) {
      actions.add(SizedBox(
        height: 40,
          child: GLTapped(onTap: () {
            _onSelectItem(item);
          }, child: GLText(item, '552'))));

      cH += 40.0;
    }


    // Cancel action
    if (widget?.cancelTitle?.isNotEmpty ?? false) {
      actions.add(Expanded(
          child: FlatButton(
            onPressed: () => _dismiss(-1),
            child: GLText(widget.cancelTitle, '552'),
            height: 50,
          )));
      cH = actions.length * 50.0;
    }else{
      // cH += 8;
    }

    /// Calculate first
    actionContainer = Column(
      // children: actions.reversed.toList(),
      children: actions.toList(),
    );

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
              _dismiss(-1);
            },
          )
        : bg;

    return WillPopScope(
      child: customDialog,
      onWillPop: () async {
        if (widget.tapAnywhereToDismiss) {
          _dismiss(-1);
          return true;
        }else{
          return false;
        }
      },
    );
  }

  _dismiss(dynamic result) {
    _springController.animateBack(-1.0, duration: Duration(milliseconds: 220));
    Navigator.of(context).pop(result);
  }

  void _buildAnimation() {
    _springDescription = SpringDescription(
      mass: 9,
      stiffness: 700,
      damping: 1.5,
    );
    _springSimulation = SpringSimulation(_springDescription, 0, 1, 5.0);
    _springAnimation = Tween(begin: 2.0, end: endAlignY).animate(_springController);
    _springController.animateWith(_springSimulation);
  }

  _onSelectItem(String item) {
    _dismiss(widget.selectionItems.indexOf(item));
  }
}
