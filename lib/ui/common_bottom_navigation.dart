import 'package:flutter/material.dart';
import 'package:watching_flutter/ui/events.dart';
import 'package:watching_flutter/ui/request.dart';
import 'package:watching_flutter/ui/user_search_page.dart';

import '../config.dart';
import 'common_popup_menu_button.dart';

class CommonBottomNavigation extends StatefulWidget {
  @override
  _CommonBottomNavigationState createState() => _CommonBottomNavigationState();
}

class _CommonBottomNavigationState extends State<CommonBottomNavigation> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Events(),
    Request(),
    UserSearchPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Config.appName),
        actions: [
          CommonPopupMenuButton(context),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'イベント一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later_outlined),
            label: 'リクエスト',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '相手を探す',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
