import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import 'common_popup_menu_button.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("このアプリについて"),
        actions: [
          CommonPopupMenuButton(context),
        ],
      ),
      body: _buildContent(context),
    );
  }

  // option + ↑ => option + command + M => shift + F6
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image.asset(
          //   "images/toeic.png",
          //   width: 180.0,
          //   height: 180.0,
          // ),
          SizedBox(height: 18.0),
          Text(Config.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              )),
          SizedBox(height: 18.0),
          // ElevatedButton(
          //   child: Text('お問い合わせ'),
          //   onPressed: () {},
          // ),
          // ElevatedButton(
          //   child: Text('プライバシーポリシー'),
          //   onPressed: () {},
          // ),
          // ElevatedButton(
          //   child: Text('著作権情報'),
          //   onPressed: () {},
          // ),
          ElevatedButton(
            child: Text('Clear Shared Preferences'),
            onPressed: () async {
              // SharedPreferences を削除
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Clear Shared Preferences"),
              ));
            },
          ),
        ],
      ),
    );
  }
}
