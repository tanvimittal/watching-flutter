import 'package:flutter/material.dart';

/// 全画面ローディング表示
///
/// - https://qiita.com/quqjp/items/4e5cb808f829161bc259
///
class OverlayLoading extends StatelessWidget {
  OverlayLoading({@required this.visible});

  //表示状態
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return visible
        ? Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))],
            ),
          )
        : Container();
  }
}
