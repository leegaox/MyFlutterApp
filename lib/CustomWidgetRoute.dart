import 'package:flutter/material.dart';

class CustomWidgetRoute extends StatelessWidget {
  CustomWidgetRoute();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Custom Widget"),
        ),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Column(
              children: <Widget>[
                GradientButton(
                  colors: [Colors.orange, Colors.red],
                  height: 50.0,
                  child: Text("Submit"),
                  onTap: () {
                    print("button clicked");
                  },
                )
              ],
            )),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  GradientButton({
    this.colors,
    this.width,
    this.height,
    this.onTap,
    @required this.child,
  });

  // 渐变色数组
  final List<Color> colors;

  // 按钮宽高
  final double width;
  final double height;

  final Widget child;

  //点击回调
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    //确保colors数组不空
    List<Color> _colors = colors ??
        [theme.primaryColor, theme.primaryColorDark ?? theme.primaryColor];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _colors),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: colors.last,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height, width: width),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultTextStyle(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
