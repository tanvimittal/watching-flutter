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
  Future<int> _mainPage;

  @override
  void initState() {
    super.initState();
    _mainPage = _getInitialPage();
  }

  @override
  Widget build(BuildContext context) {
    if (_mainPage == 1) {
      return PhoneNumber();
    }

    else if (_mainPage == 2) {
      return Nickname();
    }

    else {
     return CommonBottomNavigation();
    }
  }

  // This method returns which page to be called
  // 1: Call PhoneNumber
  // 2: Call Nickname
  // 3: Call CommmonBottomNavigation
  Future<int> _getInitialPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Both api_key and nickname are set
    if(prefs.containsKey('api_key') && prefs.containsKey('nickname')) {
        globals.apiKey = prefs.getString('api_key');
        globals.nickname = prefs.getString('nickname');
        return 3;
    }

    // if api_key is set but nickname isn't set
    else if(prefs.containsKey('api_key') && !prefs.containsKey('nickname')) {
      globals.apiKey = prefs.getString('api_key');
      return 2;
    }

    // both are not set then return 1
    return 1;

  }

}
