import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watching_flutter/globals.dart' as globals;
import 'package:watching_flutter/ui/common_bottom_navigation.dart';
import 'package:watching_flutter/ui/nickname.dart';
import 'package:watching_flutter/ui/phone_number.dart';

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
    messaging.getToken().then((value) => {
     globals.fcmToken = value
    });
    _getInitialPage();
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
        prefs.getString('api_key').isNotEmpty &&
        prefs.getString('nickname').isNotEmpty) {
      globals.apiKey = prefs.getString('api_key');
      globals.nickname = prefs.getString('nickname');
      globals.id = prefs.getInt('id');
      setState(() => _body = CommonBottomNavigation());
    }

    // if api_key is set but nickname isn't set
    else if (prefs.containsKey('api_key') &&
        !prefs.containsKey('nickname') &&
        prefs.getString('api_key').isNotEmpty) {
      globals.apiKey = prefs.getString('api_key');
      globals.id = prefs.getInt('id');
      setState(() => _body = Nickname());
    }

    // both are not set then return 1
    else {
      setState(() => _body = PhoneNumber());
    }
  }
}
