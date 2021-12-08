import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';

/// Created by GrayLand119
/// on 2020/12/25
class TestPage extends StatefulWidget {
  String? title;

  String? content;

  TestPage({this.title, this.content, Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GLAppBar(context, title: widget.title ?? "title"),
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  _body() {
    return ListView(
      children: [
        GLText('${widget.content ?? ''}', '512'),
        GLCommonButton(title: 'Pop', onTap: () {
          Navigator.pop(context);
        },),
      ],
    );
  }
}
