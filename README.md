# gl_flutter_packages_demo

Building...

`main.dart` 包含各个组件的应用

## Packages

### gl_flutter_kit

高效开发 flutter apps 的 UI组件包.

#### GLHUD

轻量级 HUD.

#### GLTapped

点击控件, 在`Tapped`的基础上添加了快速点按过滤, 防止快速点击会瞬间触发多次的问题.

#### GLBaseDialog

仿UIAlertDialog, 高度自定义弹出对话窗, 具有Spring弹簧效果.

#### GLImage

GLImage.netImage:
内部使用了 `CachedNetworkImage`. 自动缓存加载的图片.

imgUrl - 支持网络图片和本地图片(filePath)
width, height - 指定宽高.
placeholder - 自定义加载占位图, 不填则使用默认.

```dart
GLImage.netImage (
      {@required String imgUrl,
      double width,
      double height,
      BoxFit fit = BoxFit.cover,
      Widget placeholder}
```

GLImage.svgAsset:
支持 Svg 资源.

```dart
GLImage.svgAsset(
    String name, {
    String base = ICON_BASE,
    String extension = SVG_EXTENSION,
    double width,
    double height,
    Color color,
    BoxFit fit = BoxFit.contain,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) 
  
```
