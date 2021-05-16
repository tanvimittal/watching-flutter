import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watching_flutter/model/nickname_post.dart';
import 'package:watching_flutter/ui/alert_dialog_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watching_flutter/ui/common_bottom_navigation.dart';
import 'package:watching_flutter/globals.dart' as globals;

import '../http_service.dart';

class Nickname extends StatefulWidget {
  @override
  _NicknameState createState() => _NicknameState();
}

class _NicknameState extends State<Nickname> {
  final myController = TextEditingController();
  HttpService http;

  // this function is used to update nickname on server
  Future updateUser (NicknamePost nicknamePost) async {
    Response response;

    try {
      print(nicknamePost.toJson());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      response = await http.putRequest("/users", apiKey: globals.apiKey, data: nicknamePost.toJson());
      if(response.statusCode == 200) {
        prefs.setString('nickname', nicknamePost.nickname);
        globals.nickname = nicknamePost.nickname;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CommonBottomNavigation()),
              (Route<dynamic> route) => false,
        );
      } else if (response.statusCode == 500) {
        ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
      }
      //if (response)
    } on Exception catch(e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Clean the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    http = HttpService();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: const EdgeInsets.all(40.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "ニックネームを入力してください。"),
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                ],
                controller: myController, // Only numbers can be entered
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: _registerNickname,
                child: Text('登録'),
              )
            ],
          )),
    );
  }

  // This function will register user on server
  void _registerNickname() {
    String nickName = myController.text;
    NicknamePost postNickname = NicknamePost(nickname: nickName, fcmToken: "ABCD123456679fdjsbfbdsfbbfddgdhjaf");
    nickName = check(nickName);
    if (nickName!=null) {
      print(postNickname.nickname);
      updateUser(postNickname);
    }
  }

  /// Nickname should not be empty
  /// nickname should not be greater than 32 digits
  String check(String nickname) {
    if (nickname.isEmpty) {
      ShowDialog.showAlertDialog(context, 'エラー', 'ニックネームを入力してください。');
      return null;
    }

    if (nickname.length >32 ) {
      ShowDialog.showAlertDialog(context, 'エラー', 'ニックネームの桁数が32を超えています。');
      return null;
    }

    return nickname;

  }

}
