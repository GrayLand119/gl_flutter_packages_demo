import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';

/// Created by GrayLand119
/// on 2020/12/25
class GLDialogDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GLAppBar(context, title: 'GLDialog Demo'),
      body: SafeArea(
        child: _cells(context),
      ),
    );
  }

  _cells(BuildContext context) {
    return ListView(
      children: [
        GLCommonCell(
          title: 'AlertDialog - normal',
          onTap: () async {
            bool _res = await GLAlertDialog(
                title: 'Your Title',
                content: 'Your content blablabla...',
                cancelTitle: 'Cancel',
                okTitle: 'Go to Setting').show(context);
          },
        ),
        GLCommonCell(
          title: 'AlertDialog - dangerous action style',
          onTap: () async {
            bool _res = await GLAlertDialog(
                title: 'Your Title',
                content: 'Your content blablabla...',
                cancelTitle: 'Cancel',
                okTitle: 'Delete',
                isDangerousAction: true).show(context);
          },
        ),
        GLCommonCell(
          title: 'AlertDialog - Vertical action',
          onTap: () async {
            bool _res = await GLAlertDialog(
                title: 'Your Title',
                content: 'Your content blablabla...',
                cancelTitle: 'Cancel',
                okTitle: 'Ignore',
              actionAxis: Axis.vertical,
            ).show(context);
          },
        ),
        GLCommonCell(
          title: 'GLSelectDialog',
          onTap: () async {
            var _res = await GLSelectDialog(
                title: 'Your Title',
                content: 'Your content blablabla...',
                cancelTitle: 'Cancel',
              selectionItems: ['item0', 'item1'],
              tapAnywhereToDismiss: true,
            ).show(context);
            print('tapped index: $_res');
          },
        ),
      ],
    );
  }
}
