import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserSearchPage extends StatelessWidget {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: const EdgeInsets.all(40.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "見守りたい相手の電話番号を入れてください。",
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                ],
                controller: myController, // Only numbers can be entered
                maxLength: 11,  // Only for Japan
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: _searchUser,
                child: Text('探す'),
              )
            ],
          )),
    );
  }

  void _searchUser() {
    print(myController.text);
  }
}
