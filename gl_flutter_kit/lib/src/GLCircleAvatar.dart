import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gl_flutter_kit/gl_flutter_kit.dart';
import 'package:gl_flutter_kit/src/GLUtils.dart';

/**
 * Created by GrayLand119
 * on 2020/12/3
 */
class GLCircleAvatar extends StatelessWidget {
  final String? imageUrl;

  final double borderWidth;
  final double radius;

  PlaceholderWidgetBuilder? placeHolder;

  final Widget? image;

  final BoxFit fit;

  final double? width;

  final double? height;

  GLCircleAvatar(
      {this.imageUrl,
      this.image,
      this.borderWidth = 0,
      this.radius = 44.0,
      this.width,
      this.height,
      this.placeHolder,
      this.fit = BoxFit.cover,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (placeHolder == null) {
      placeHolder = (ctx, url) {
        return Container(
          child: SpinKitFadingCircle(size: 25, color: GLAppStyle.instance.currentConfig.primaryColor),
          color: Colors.white,
        );
      };
    }

    var _avatar;
    if (imageUrl != null) {
      _avatar = CachedNetworkImage(
        fit: fit,
        imageUrl: imageUrl!,
        placeholder: placeHolder,
      );
    } else if (image != null) {
      _avatar = image;
    } else {
      _avatar = Container(
        color: Colors.grey[300],
      );
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Colors.white, width: borderWidth)),
          shape: BoxShape.circle),
      child: Center(
        child: SizedBox(
          width: radius*2,
          height: radius*2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: _avatar,
          ),
        ),
      ),
    );
  }
}
