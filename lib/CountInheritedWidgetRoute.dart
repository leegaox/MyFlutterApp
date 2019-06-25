import 'package:flutter/material.dart';

class CountInheritedWidgetRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CountInheritedWidgetState();
  }
}

class CountInheritedWidgetState extends State<CountInheritedWidgetRoute> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Center(
        child: CounterDataWidget(
          data: count,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CountWidget(),//子widget中依赖CountDataWidget
              ),
              RaisedButton(
                child: Text("Increment"),
                //每点击一次，将count自增，然后重新build,ShareDataWidget的data将被更新
                onPressed: () => setState(() => ++count),
              )
            ],),
        ),
      ),
    );
  }
}

class CountWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CountState();
  }
}

class CountState extends State<CountWidget> {
  @override
  Widget build(BuildContext context) {
    // 使用InheritedWidget中的共享数据
    return Text(CounterDataWidget.of(context).data.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //父或祖先widget中的InheritedWidget改变(updateShouldNotify返回true)时会被调用。
    //如果build中没有依赖InheritedWidget，则此回调不会被调用。
    print("Dependencies change");
  }
}

class CounterDataWidget extends InheritedWidget {
  //需要在子树钟共享的数据，保存点击次数
  final int data;

  CounterDataWidget({@required this.data, Widget child}) : super(child: child);

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static CounterDataWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CounterDataWidget);
  }

  //该回调决定当前data发生变化时，是否通知子树中依赖data的widget
  @override
  bool updateShouldNotify(CounterDataWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return oldWidget.data != data;
  }
}
