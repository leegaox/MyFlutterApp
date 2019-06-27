import 'package:flutter/material.dart';
import 'dart:developer';
import 'login.dart';
import 'LayoutTestRoute.dart';
import 'CountInheritedWidgetRoute.dart';
import 'package:english_words/english_words.dart';
import 'GestureDetectorRoute.dart';
import 'AnimationRoute.dart';
import 'BigPictureRoute.dart';
import 'CustomWidgetRoute.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Flutter Tutorial',
    home: new ScaffoldRoute(),
    //注册路由表
    routes: {
      "login": (context) => new LoginRoute(),
      "layout": (context) => new LayoutTestRoute(),
      "counter": (context) => new CountInheritedWidgetRoute(),
      "gesture": (context) => new GestureDetectorRoute(),
//      "animation": (context) => new AnimationRoute()
    },
    debugShowCheckedModeBanner: true,
//    showPerformanceOverlay: true,
  ));
//  debugDumpLayerTree();
}

class ScaffoldRoute extends StatefulWidget {
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  TabController _tabController; //需要定义一个Controller
  List tabs = ["新闻", "历史", "图片"];

  @override
  void initState() {
    super.initState();
    //创建了一个TabController ，它是用于控制/监听Tab菜单切换
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      switch (_tabController.index) {
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        leading: Builder(builder: (context) {
          return new IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            tooltip: 'Navigation menu',
            onPressed: () {
              // 打开抽屉菜单
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Text("Home"),
        bottom: TabBar(
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList()),
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      drawer: new MyDrawer(key: Key("Drawer")),
      //抽屉
//      bottomNavigationBar: BottomNavigationBar(
//        // 底部导航
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.business), title: Text('Business')),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.school), title: Text('School')),
//        ],
//        currentIndex: _selectedIndex,
//        fixedColor: Colors.blue,
//        onTap: _onItemTapped,
//      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.home),onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context){return new CustomWidgetRoute();}));},),
            SizedBox(), //中间位置空出
            IconButton(
                icon: Icon(Icons.business),
                onPressed: () =>
                {
                Navigator.of(context).pushNamed("gesture")
                }),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
      ),

      //body占屏幕的大部分

      body: TabBarView(
        controller: _tabController,
        children: [
          InfiniteListView(),
//          ListView3(),
          CustomScrollViewTestRoute(),
          InfiniteGridView(),
        ],
      ),

//      new Column(
//        children: <Widget>[
//          new MyButton(),
//          new Counter(),
//        ],
//      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        //悬浮按钮
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("counter");
          }),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAdd() {}
}

class InfiniteListView extends StatefulWidget {
  @override
  _InfiniteListViewState createState() {
    // TODO: implement createState
    return _InfiniteListViewState();
  }
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##";
  var _words = <String>[loadingTag];

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    ListTile(title: Text("我是表头"));
    return ListView.separated(
        itemBuilder: (context, index) {
          //如果到了表尾
          if (_words[index] == loadingTag) {
            //不足100条，继续获取数据
            if (_words.length - 1 < 100) {
              //获取数据
              _retrieveData();
              //加载时显示loading
              return Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0)),
              );
            } else {
              //已经加载了100条数据，不再获取数据。
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "没有更多了",
                    style: TextStyle(color: Colors.grey),
                  ));
            }
          }

          //显示单词列表项
          return GestureDetector(
            child: ListTile(title: Text(_words[index])),
            onTap: () =>
            {
//                  Navigator.push(
//                      context,
//                      new MaterialPageRoute(
//                          builder: (context) => new AnimationRoute()))

            //自定义路由动画 渐隐渐入动画
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (BuildContext ctx, Animation animation,
                        Animation secondaryAnimation) {
                      return new FadeTransition(
                        opacity: animation,
                        child: AnimationRoute(),
                      );
                    }))
            },
          );
        },
        separatorBuilder: (context, index) => Divider(height: .0),
        itemCount: _words.length);
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      setState(() {
        //重新构建列表
        _words.insertAll(_words.length - 1,
            generateWordPairs().take(20).map((e) => e.asPascalCase).toList());
      });
    });
  }
}

class ListView3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //下划线widget预定义以供复用。
    Widget divider1 = Divider(color: Colors.blue);
    Widget divider2 = Divider(
      color: Colors.green,
    );
    return Column(
      children: <Widget>[
        ListTile(title: Text("商品列表")),
        Expanded(
            child: ListView.separated(
              //列表项构造器
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text("$index"),
                  );
                },
                //分割线构造器
                separatorBuilder: (BuildContext context, int index) {
                  return index % 2 == 0 ? divider1 : divider2;
                },
                itemCount: 100))
      ],
    );
  }
}

class InfiniteGridView extends StatefulWidget {
  @override
  _InfiniteGridViewState createState() => new _InfiniteGridViewState();
}

class _InfiniteGridViewState extends State<InfiniteGridView> {
  List<IconData> _icons = []; //保存Icon数据

  @override
  void initState() {
    // 初始化数据
    _retrieveIcons();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //每行三列
            childAspectRatio: 1.0 //显示区域宽高相等
        ),
        itemCount: _icons.length,
        itemBuilder: (context, index) {
          //如果显示到最后一个并且Icon总数小于200时继续获取数据
          if (index == _icons.length - 1 && _icons.length < 200) {
            _retrieveIcons();
          }
          return Icon(_icons[index]);
        });
  }

  //模拟异步获取数据
  void _retrieveIcons() {
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      setState(() {
        _icons.addAll([
          Icons.ac_unit,
          Icons.airport_shuttle,
          Icons.all_inclusive,
          Icons.beach_access,
          Icons.cake,
          Icons.free_breakfast
        ]);
      });
    });
  }
}

class CustomScrollViewTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //因为本路由没有使用Scaffold，为了让子级Widget(如Text)使用
    //Material Design 默认的样式风格,我们使用Material作为本路由的根。
    return Material(
      child: CustomScrollView(
        slivers: <Widget>[
          //AppBar，包含一个导航栏
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Demo'),
              background: Image.asset(
                "assets/graphics/sea.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: new SliverGrid(
              //Grid
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //Grid按两列显示
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建子widget
                  return new Container(
                    alignment: Alignment.center,
                    color: Colors.cyan[100 * (index % 9)],
                    child: new Text('grid item $index'),
                  );
                },
                childCount: 20,
              ),
            ),
          ),
          //List
          new SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建列表项
                  return new Container(
                    alignment: Alignment.center,
                    color: Colors.lightBlue[100 * (index % 9)],
                    child: new Text('list item $index'),
                  );
                }, childCount: 50 //50个列表项
            ),
          ),
        ],
      ),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  CounterDisplay({this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return new Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  CounterIncrementor({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      onPressed: onPressed,
      child: new Text('Increment'),
    );
  }
}

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => new _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    Timeline.startSync("_increment");
    setState(() {
      ++_counter;
    });
    Timeline.finishSync();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _counter = 0;
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return new Row(children: <Widget>[
      new CounterIncrementor(onPressed: _increment),
//      new Text("xxx"),
      new CounterDisplay(count: _counter),
    ]);
  }

  @override
  void didUpdateWidget(Counter oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("deactive");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didChangeDependencies");
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        //导航到新路由
//              Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (context) {
//                        return new NewRoute();
//                      },
//                      maintainState: false,
//                      fullscreenDialog: false));
        //通过路由名来打开新的路由页
//              Navigator.pushNamed(context, "login");
        //打开路由时传递参数
        Navigator.of(context).pushNamed("login", arguments: "hi");
      },
      child: new Container(
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: new Center(
          child: new Text('open login router'),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        // DrawerHeader consumes top MediaQuery padding.
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: InkWell(
                        child: Hero(
                          tag: "head",
                          child: ClipOval(
                            child: Image.asset(
                              'assets/graphics/sea.png',
                              width: 80,
                            ),
                          ),
                        ),
                        onTap: () {
                          //打开个人中心路由
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation animation,
                                      Animation secondaryAnimation) {
                                    return new FadeTransition(
                                      opacity: animation,
                                      child:  BigPictureRoute());
                                  }));
                        },
                      )),
                  Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add account'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Manage accounts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
