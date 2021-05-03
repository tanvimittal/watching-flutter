import 'package:flutter/material.dart';

class CommonBottomNavigation extends StatefulWidget {
  @override
  _CommonBottomNavigationState createState() => _CommonBottomNavigationState();
}

class _CommonBottomNavigationState extends State<CommonBottomNavigation> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: イベント一覧',
      style: optionStyle,
    ),
    Text(
      'Index 1: リクエスト',
      style: optionStyle,
    ),
    Text(
      'Index 2: 相手を探す',
      style: optionStyle,
    ),
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
        title: const Text('見守りアプリ'),
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
