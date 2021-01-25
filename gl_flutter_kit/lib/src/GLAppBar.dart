import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'GLUtils.dart';

import 'GLNavigationItem.dart';

/**
 * Created by GrayLand119
 * on 2020/12/3
 */
AppBar GLAppBar(
  BuildContext context, {
  Widget leading,
  String title = '',
  BoolCallback willPopBack,
  List<GLNavigationItem> rightItems,
  Color backgroundColor,
  bool showLeading = true,
  Key key,
}) {
  /// Navigator.of(context).canPop() some time return true unexspected.
  /// So, add `showLeading` property to manual control leading widget's show/hide.
  // if (leading == null && Navigator.of(context).canPop() && showLeading) {
  if (showLeading) {
    if (leading == null) {
      leading = IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
          ),
          onPressed: () async {
            if (willPopBack == null || (await willPopBack?.call() ?? true)) {
              Navigator.of(context).pop();
            }
          });
    }
  }else {
    // leading = Container();
    leading = null;
  }

  return AppBar(
    key: key,
    leading: leading,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: GLText(title, "441"),
    centerTitle: true,
    actions: rightItems,
    backgroundColor: backgroundColor,
  );
}
