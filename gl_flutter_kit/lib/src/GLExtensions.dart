part of 'package:gl_flutter_kit/gl_flutter_kit.dart';

/**
 * Created by GrayLand119
 * on 2020/12/2
 */
// class GLImage extends SvgPicture {
//   GLImage.asset(String assetName) : super.asset(assetName);
// }

// TextPainter(
// text: TextSpan(text: text, style: textStyle),
// maxLines: 1,
// textScaleFactor: MediaQuery.of(context).textScaleFactor,
// textDirection: TextDirection.ltr)
// ..layout())
// .size;
extension GLTextSize on Text {
  static Size _size;

  Size layout({double minWidth = 0.0, double maxWidth = double.maxFinite}) {
    TextPainter _p = TextPainter(
        text: TextSpan(text: this.data, style: this.style),
        maxLines: this.maxLines,
        textDirection: TextDirection.ltr,)
      ..layout(minWidth: minWidth, maxWidth: maxWidth);
    _size = _p.size;
    return _size;
  }

  Size get size => _size;
}

extension GLString on String {
  double toDouble() {
    return double.parse(this) ?? 0.0;
  }
  int toInt() {
    return int.parse(this) ?? 0;
  }
}

extension GLDynamic on dynamic {
  double toDouble() {
    print ('GLDynamic toDouble call!');
    if (this is String) return double.parse(this) ?? 0.0;
    if (this is double) return this;
    if (this is int) return this.toDouble();
    return 0.0;
  }

  int toInt() {
    if (this is String) return int.parse(this) ?? 0;
    if (this is double) return this.toInt();
    if (this is int) return this;
    return 0;
  }
}

extension GLIntSeconds on int {
  String toTimeString() {
    int sec = this;
    int h = sec ~/ 3600.0;
    sec = sec % 3600;
    int m = sec ~/ 60.0;
    sec = sec % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}