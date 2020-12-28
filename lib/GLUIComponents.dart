import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';

/// Created by GrayLand119
/// on 2020/12/25
class GLUIComponents extends StatelessWidget {

  String testUrl = 'https://www.baidu.com/img/dong_e70247ce4b0a3e5ba73e8b3b05429d84.gif';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GLAppBar(context, title: 'GLUIComponents Demo'),
      body: ListView(
        children: _cells(),
      ),
    );
  }

  List<Widget> _cells() {
    return [
      GLDemoCell(
        title: 'GLTapped',
        child: _tapped(),
      ),
      GLDemoCell(
        title: 'GLPolygenButton',
        child: _polygenButton(),
      ),
      GLDemoCell(
        title: 'GLImage.netImage - ok',
        child: GLImage.netImage(imgUrl: 'https://www.baidu.com/img/dong_e70247ce4b0a3e5ba73e8b3b05429d84.gif', width: 120),
      ),
      GLDemoCell(
        title: 'GLImage.netImage - loading',
        child: GLImage.netImage(imgUrl: 'https://www.baidu.com/img/not_exist_image_for_test_loading_placeholder.jpg', width: 120),
      ),
      GLDemoCell(
        title: 'GLImage.netImage - loading - custom placeholder',
        child: GLImage.netImage(imgUrl: 'https://www.baidu.com/img/not_exist_image_for_test_loading_placeholder.jpg', width: 120, placeholder: SpinKitThreeBounce(color: GLAppStyle.instance.currentConfig.primaryColor,)),
      ),
      GLDemoCell(
        title: 'GLCircleAvatar',
        child: GLCircleAvatar(imageUrl: 'https://box.bdimg.com/static/fisp_static/common/img/searchbox/logo_news_276_88_1f9876a.png',
          borderWidth: 2, width: 44, height: 44,),
      ),
    ].expand((element) => [element, Divider()]).toList();
  }

  Widget _tapped() {
    return GLTapped(
      child: GLText('Tap me quickly or Double Tap', '552'),
      onTap: () {
        print('Tapped at ${DateTime.now().millisecondsSinceEpoch}');
      },
    );
  }

  Widget _polygenButton() {
    Path _path = Path();
    _path.moveTo(60, 0);
    _path.lineTo(120, 10);
    _path.lineTo(110, 20);
    _path.lineTo(300, 50);
    _path.lineTo(55, 50);
    _path.close();

    return GLPolygenButton(
      // child: CustomPainter(color: Colors.deepOrange.withOpacity(0.2),),
      maskPath: _path,
      maskColor: Colors.redAccent,
      onTap: () {
        print('Tapped GLPolygenButton');
      },
    );
  }


}

class GLDemoCell extends StatelessWidget {
  String title;

  Widget child;

  GLDemoCell({this.title, this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GLText('$title', '512'),
        ),
        Center(child: child),
      ],
    );
  }
}
