import 'package:flutter/material.dart';

/**
 * 查看原图Widget
 */
class BigPictureRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: "head", //唯一标记，前后两个路由页Hero的tag必须相同
        child: Image.asset("assets/graphics/sea.png"),
      ),
    );
  }
}
