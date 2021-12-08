import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';

import 'GLDialogDemo.dart';
import 'GLHUDDemo.dart';
import 'GLTransitionDemo.dart';
import 'GLUIComponents.dart';
import 'TestPage.dart';

/// Created by GrayLand119
/// on 2020/12/25
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _hud = GLHUD.genKey();


  @override
  Widget build(BuildContext context) {
    return GLHUD(
      onWillPop: () async {
        if (_hud.currentState?.hudState == GLHUDType.dismissed) {
          _hud.currentState?.showMessage(message: '再按一次退出');
          return false;
        }
        return true;
      },
      key: _hud,
      child: Scaffold(
        appBar: GLAppBar(context, title: 'HomePage', showLeading: false),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              GLCommonCell(title: 'GLHUD', desc: 'An light and easy used HUD Widget', onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (ctx) => GLHUDDemo()));
              },),
              GLCommonCell(title: 'GLUIComponents', desc: 'Widgets', onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (ctx) => GLUIComponents()));
              },),
              GLCommonCell(title: 'GLAlertDialog', desc: 'Widgets', onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (ctx) => GLDialogDemo()));
              },),
              GLCommonCell(title: 'GLTransitionDemo', desc: 'Widgets', onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (ctx) => GLTransitionDemo()));
              },),
              // GLCommonButton(title: 'Push', onTap: () {
              //   Navigator.push(context, CupertinoPageRoute(builder: (ctx)=>TestPage()));
              // },),
            ],
          ),
        ),
      ),
    );
  }
}