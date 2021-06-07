import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config.dart';
import 'alert_dialog_error.dart';
//import 'common_popup_menu_button.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("このアプリについて"),
        actions: [
          // 全ページにメニューは入れない？
          //CommonPopupMenuButton(context),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildColumnChildren(context),
      ),
    );
  }

  List<Widget> _buildColumnChildren(BuildContext context) {
    List<Widget> widgets = [
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _infoTile('App name', _packageInfo.appName),
            _infoTile('Package name', _packageInfo.packageName),
            _infoTile('App version', _packageInfo.version),
            _infoTile('Build number', _packageInfo.buildNumber),
          ],
        ),
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
      ];

    if (Config.isRelease == false) {
      widgets.add(
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
          )
      );
      widgets.add(
        ElevatedButton(
          child: Text('Local Notification'),
          onPressed: () async {
            // Local Notification Test
            await _showNotification();
          },
        ),
      );
    }

    return widgets;
  }

  //
  // Package Info
  // - https://pub.dev/packages/package_info/example
  //
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    print("111111");
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isNotEmpty ? subtitle : 'Not set'),
    );
  }

  //
  // Local Notification
  //

  // Initialize
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // ↓なくても動きそう。
  var initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings(
      'launch_background',
    ),
    iOS: IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // your call back to the UI
      },
    ),
  );

  // Channel
  var androidChannelSpecifics = AndroidNotificationDetails(
    'About page CHANNEL_ID',
    'About page CHANNEL_NAME',
    "About page CHANNEL_DESCRIPTION",
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    //timeoutAfter: 5000,  // これを付けると消える
    //styleInformation: DefaultStyleInformation(true, true),
    icon: 'launch_background',
  );
  var iosChannelSpecifics = IOSNotificationDetails();

  //
  Future<void> _onSelectNotification(String payload) async {
    ShowDialog.showAlertDialog(context, 'onSelectNotification', payload);
  }

  Future<void> _showNotification() async {
    // ↓なくても動く
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification,
    );

    // TODO: 必要？
    // landing_page.dart
    //   await flutterLocalNotificationsPlugin
    //       .resolvePlatformSpecificImplementation<
    //       AndroidFlutterLocalNotificationsPlugin>()
    //       ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.show(
      0,
      'About page title',
      'About page body',
      NotificationDetails(
        android: androidChannelSpecifics,
        iOS: iosChannelSpecifics,
      ),
      payload: 'About page payload',
    );
  }
}
