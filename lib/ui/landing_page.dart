import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watching_flutter/globals.dart' as globals;
import 'package:watching_flutter/model/nickname_post.dart';
import 'package:watching_flutter/ui/common_bottom_navigation.dart';
import 'package:watching_flutter/ui/nickname.dart';
import 'package:watching_flutter/ui/phone_number.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
'high_importance_channel', // id
'High Importance Notifications', // title
'This channel is used for important notifications.', // description
importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _messageHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) await Firebase.initializeApp();
  print('Message recieved');
  print('Handling a background message ${message.messageId}');
  await showNotification(message);
}

Future<void> showNotification(RemoteMessage message) async {
  var eventName;
  RemoteNotification notification = message.notification;
  print(notification.hashCode);
  print(message.data);
  var userNickname = message.data['user_nickname'];
  if ("get_up" == message.data['name']) {
    eventName = userNickname + "さんが起きました。";
  }
  else {
    eventName = userNickname + "さんが寝ました。";
  }
  flutterLocalNotificationsPlugin.show(
      0,
      '見守りアプリ',
      eventName,
      //notification.title,
      //notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ));
  // }
}



class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseMessaging messaging;
  Widget _body = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    _getUserPermission();
    checkForInitialMessage();
    _getInitialPage();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }

  // This method returns which page to be called
  // 1: Call PhoneNumber
  // 2: Call Nickname
  // 3: Call CommmonBottomNavigation
  Future _getInitialPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Both api_key and nickname are set
    if (prefs.containsKey('api_key') &&
        prefs.containsKey('nickname') &&
        prefs
            .getString('api_key')
            .isNotEmpty &&
        prefs
            .getString('nickname')
            .isNotEmpty) {
      globals.apiKey = prefs.getString('api_key');
      globals.nickname = prefs.getString('nickname');
      globals.id = prefs.getInt('id');
      setState(() => _body = CommonBottomNavigation());
    }

    // if api_key is set but nickname isn't set
    else if (prefs.containsKey('api_key') &&
        !prefs.containsKey('nickname') &&
        prefs
            .getString('api_key')
            .isNotEmpty) {
      globals.apiKey = prefs.getString('api_key');
      globals.id = prefs.getInt('id');
      setState(() => _body = Nickname());
    }

    // both are not set then return 1
    else {
      setState(() => _body = PhoneNumber());
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    RemoteMessage initialMessage;
    if (initialMessage == null) {
      await FirebaseMessaging.instance.getInitialMessage();
    }
  }

  Future<void> _getUserPermission() async {
    // https://blog.logrocket.com/flutter-push-notifications-with-firebase-cloud-messaging/#buildingtheui
    // On iOS, this helps to take the user permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );


      // https://medium.com/firebase-tips-tricks/how-to-use-firebase-cloud-messaging-in-flutter-a15ca69ff292
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("message received");
        var eventName;
        RemoteNotification notification = message.notification;
        print(notification.hashCode);
        print(message.data);
        var userNickname = message.data['user_nickname'];
        if ("get_up" == message.data['name']) {
          eventName = userNickname + "さんが起きました。";
        }
        else {
          eventName = userNickname + "さんが寝ました。";
        }
        //AndroidNotification android = message.notification?.android;
       // if (notification != null && android != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              '見守りアプリ',
              eventName,
              //notification.title,
              //notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'launch_background',
                ),
              ));
       // }
      });

      messaging.getToken().then((value) =>
      {
        globals.fcmToken = value
      });

      FirebaseMessaging.onBackgroundMessage(_messageHandler);

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((value) => value != null ? _messageHandler : false);

      // on Token refresh
      Stream<String> fcmStream = messaging.onTokenRefresh;
      fcmStream.listen((token) {
        globals.fcmToken = token;
        Nickname nickname = Nickname();
        nickname.updateFcmToken(NicknamePost(
            nickname: globals.nickname, fcmToken: globals.fcmToken));
      });
    }
  }
}
