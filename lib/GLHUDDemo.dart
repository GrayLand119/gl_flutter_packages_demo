import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';

/// Created by GrayLand119
/// on 2020/12/25
class GLHUDDemo extends StatefulWidget {
  @override
  _GLHUDDemoState createState() => _GLHUDDemoState();
}

class _GLHUDDemoState extends State<GLHUDDemo> {
  var _hud = GLHUD.genKey();

  @override
  Widget build(BuildContext context) {
    return GLHUD(
      key: _hud,
      child: Scaffold(
        appBar: GLAppBar(context, title: 'GLHUD Demo'),
        body: SafeArea(
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            children: [
              GLCommonCell(
                title: 'Show HUD',
                desc: 'With cancel button',
                onTap: () {
                  _hud.currentState?.showLoading(onCancel: () {});
                  Future.delayed(Duration(seconds: 10), () {
                    _hud.currentState?.hide();
                  });
                },
              ),
              GLCommonCell(
                title: 'Show Loading HUD',
                desc: 'Loading only',
                onTap: () {
                  _hud.currentState?.showLoading();
                  Future.delayed(Duration(seconds: 2), () {
                    _hud.currentState?.hide();
                  });
                },
              ),
              GLCommonCell(
                title: 'Show Loading HUD',
                desc: 'With title',
                onTap: () {
                  _hud.currentState?.showLoading(title: 'Title');
                  Future.delayed(Duration(seconds: 2), () {
                    _hud.currentState?.hide();
                  });
                },
              ),
              GLCommonCell(
                title: 'Show Loading HUD',
                desc: 'With title and messagae',
                onTap: () {
                  _hud.currentState?.showLoading(title: 'Title', message: 'Loading message');
                  Future.delayed(Duration(seconds: 2), () {
                    _hud.currentState?.hide();
                  });
                },
              ),
              GLCommonCell(
                title: 'Show Loading HUD',
                desc: 'With extend widget',
                onTap: () {
                  _hud.currentState?.showLoading(title: 'Title',
                      // message: 'Loading message',
                      extendWidgetHeight: 40, extendWidget: CupertinoButton(child: GLText('Stop Request', '651', textAlign: TextAlign.center), onPressed: () {
                        _hud.currentState?.hide();
                      }));
                  Future.delayed(Duration(seconds: 50), () {
                    _hud.currentState?.hide();
                  });
                },
              ),
              GLCommonCell(
                title: 'Show messagae HUD',
                desc: 'message only',
                onTap: () {
                  // _hud.currentState?.showMessage(message: 'This is a message.');
                  _hud.currentState?.showMessage(message: 'message.');
                },
              ),
              GLCommonCell(
                title: 'Show messagae HUD',
                desc: 'title and message',
                onTap: () {
                  _hud.currentState?.showMessage(title: 'Title', message: 'This is a message.');
                },
              ),
              GLCommonCell(
                title: 'Show Loading, then show message',
                desc: '',
                onTap: () async {
                  _hud.currentState?.showLoading();
                  await Future.delayed(Duration(seconds: 1));
                  _hud.currentState?.showMessage(
                      message: 'Show message after showLoading, GLHUD will auto hide.');
                },
              ),
              GLCommonCell(
                title: 'Show Progress',
                desc: 'Title and content can be null',
                onTap: () async {

                  double i = 0;
                  Timer.periodic(Duration(milliseconds: 100), (timer) {
                    i += 0.05;
                    _hud.currentState?.showProgress(
                        title: 'OTA',
                        message: 'OTA progress ${(i * 100).toInt()}%',
                        progress: i);
                    if (i >= 1.0) {
                      timer.cancel();
                      _hud.currentState?.hide();
                    }
                  });

                },
              ),
              GLCommonCell(
                title: 'Show Success',
                desc: 'TODO: show success icon',
                onTap: () async {
                  _hud.currentState?.showSuccessMessage(message: 'Success');
                },
              ),
              GLCommonCell(
                title: 'Show Error',
                desc: 'TODO: show failed icon',
                onTap: () async {
                  _hud.currentState?.showErrorMessage(message: 'Error');
                },
              ),
              GLCommonCell(
                title: 'Show Custom',
                desc: '',
                onTap: () async {
                  // _hud.currentState?.showCustom();
                  _hud.currentState?.showCustom(
                      child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SpinKitChasingDots(
                      color: Colors.deepOrange,
                    ),
                  ));
                  await Future.delayed(Duration(seconds: 5));
                  _hud.currentState?.hide();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
