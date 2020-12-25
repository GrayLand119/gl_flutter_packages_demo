import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'GLUtils.dart';

import 'GLTapped.dart';

/**
 * Created by GrayLand119
 * on 2020/12/3
 */
class GLCommonCell extends StatelessWidget {
  final String title;
  final String desc;
  final Widget trailing;
  final VoidCallback onTap;
  final int index;

  final bool showBottomSeperator;

  final double height;

  GLCommonCell({this.title, this.desc='', this.height=60.0, this.trailing, this.onTap, this.index, this.showBottomSeperator = true, Key key}):super(key: key);

  bool _tapped = false;
  @override
  Widget build(BuildContext context) {

    List<Widget> _rowElements = [];
    _rowElements.add(Expanded(child: GLText(title, '512')));
    if (desc.isNotEmpty) {
      _rowElements.add(GLText(desc, '522'));
    }
    if (trailing != null) {
      _rowElements.add(trailing);
    }
    var border;
    if (showBottomSeperator) {
      border = Border(bottom: BorderSide(
          width: 0.5,
          color: GLSeperatorColor
      ));
    }

    var _w = Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPaddingHorizontal),
      decoration: BoxDecoration(
        border: border,
      ),
      height: height,
      child: Row(
        children: _rowElements,
      ),
    );
    if (onTap != null) {
      return GLTapped(
          child: _w,
          onTap: () async {
            if (_tapped)
              return;
            _tapped = true;
            await onTap();
            _tapped = false;
          });
    }else {
      return _w;
    }
  }
}