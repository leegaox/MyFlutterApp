import 'package:flutter/material.dart';

class AnimationRoute extends StatelessWidget {
  AnimationRoute();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gesture"),
        ),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Column(
              children: <Widget>[
                new ScaleAnimationRoute(),
                new StaggerDemo(),
              ],
            )),
      ),
    );
  }
}

class ScaleAnimationRoute extends StatefulWidget {
  @override
  _ScaleAnimationRouteState createState() => new _ScaleAnimationRouteState();
}

//需要继承TickerProvider，如果有多个AnimationController，则应该使用TickerProviderStateMixin。
class _ScaleAnimationRouteState extends State<ScaleAnimationRoute>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(seconds: 3), vsync: this);
    //使用弹性曲线
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);

    // 1
//    //图片宽高从0变到300
//    animation = new Tween(begin: 0.0, end: 300.0).animate(controller)
//      ..addListener(() {
//        setState(() => {});
//      });

    // 2
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end: 300.0).animate(animation);

    //动画状态监听
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画执行结束时反向执行动画
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //动画恢复到初始状态时执行动画（正向）
        controller.forward();
      }
    });

    //启动动画(正向执行)
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    //1
//    return new Center(
//      child: Image.asset("assets/graphics/sea.png",
//          width: animation.value, height: animation.value),
//    );

    //2
//    return AnimatedImage(
//      animation: animation,
//    );

    // 3 用AnimatedBuilder重构，将渲染逻辑分离出来
    return AnimatedBuilder(
        animation: animation,
        child: Image.asset("assets/graphics/sea.png"),
        builder: (BuildContext ctx, Widget child) {
          return new Center(
            child: Container(
              height: animation.value,
              width: animation.value,
              child: child,
            ),
          );
        });
  }

  dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }
}

//用AnimatedWidget重构，从动画中分离出Widget
class AnimatedImage extends AnimatedWidget {
  AnimatedImage({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Center(
      child: Image.asset("assets/graphics/sea.png",
          width: animation.value, height: animation.value),
    );
  }
}

class StaggerAnimation extends StatelessWidget {
  final Animation<double> controller;
  Animation<double> height;
  Animation<EdgeInsets> padding;
  Animation<Color> color;

  StaggerAnimation({Key key, this.controller}) : super(key: key) {
    //g高度动画
    height = Tween<double>(begin: 0, end: 300.0).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.6, //间隔。前60%的动画时间
            curve: Curves.ease)));

    color = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );

    padding = Tween<EdgeInsets>(
      begin: EdgeInsets.only(left: .0),
      end: EdgeInsets.only(left: 100.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.6, 1.0, //间隔，后40%的动画时间
          curve: Curves.ease,
        ),
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: padding.value,
      child: Container(
        color: color.value,
        width: 50.0,
        height: height.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class StaggerDemo extends StatefulWidget {
  @override
  _StaggerDemoState createState() => _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  Future<Null> _playAnimation() async {
    try {
      //先正向执行动画
      await _controller.forward().orCancel;
      //再反向执行动画
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _playAnimation();
      },
      child: Center(
        child: Container(
          width: 200.0,
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            border: Border.all(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          //调用我们定义的交错动画Widget
          child: StaggerAnimation(controller: _controller),
        ),
      ),
    );
  }
}
