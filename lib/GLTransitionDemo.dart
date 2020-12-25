import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';

import 'TestPage.dart';

/// Created by GrayLand119
/// on 2020/12/25
class GLTransitionDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GLAppBar(context, title: 'GLTransition Demo'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              GLCommonButton(title: 'GLCrossFadePageRoute', onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (cgx) => TestPage(title: 'From GLCrossFadePageRoute',)));
                Navigator.push(context, GLCrossFadePageRoute(page: TestPage(title: 'From GLCrossFadePageRoute',)));
              },),
            ].expand((element) => [element, SizedBox(height: 10,)]).toList(),
          ),
        ),
      ),
    );
  }
}