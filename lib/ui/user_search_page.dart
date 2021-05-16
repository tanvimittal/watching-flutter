import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watching_flutter/http_service.dart';
import 'package:watching_flutter/model/user.dart';
import 'package:watching_flutter/globals.dart' as globals;

import 'alert_dialog_error.dart';

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                maxLength: 11,
                keyboardType: TextInputType.number,
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  hintText: "ハイフン区切りなし、数字のみ",
                ),
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
    print(_phoneNumberController.text);
    // TODO: Validation
    // TODO: Transfer from Japanese phone number seriously
    _sendGetUsers("+81${_phoneNumberController.text.substring(1)}");
  }

  // TODO: UI では通信を意識させない
  void _sendGetUsers(String phoneNumber) async {
    final http = HttpService(); // TODO: Singleton
    Response response;

    try {
      response = await http.getRequest(
        "/users",
        apiKey: globals.apiKey,
        queryParameters: {"phone_number": phoneNumber},
      );
      print(response);
      // TODO: Add codes to show result of searching

      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        // TODO: ニックネームない場合はどうする？
        showConfirmDialog(context, user);
        // TODO: ダイアログが戻ってきたらここが動く？
      } else {
        // TODO: 見つからなかった場合の処理
        // TODO: エラー処理は UI 部分で行う
        ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
      }
    } on Exception catch (e) {
      ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
    }
  }

  // TODO: 後で別のファイルに
  // TODO: Future 返す必要あるか？
  Future<void> showConfirmDialog(BuildContext context, User user) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "リクエスト確認",
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "${user.nickname} さんにリクエストを送りますか？",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'いいえ',
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: 電話番号を残しておく？
              },
            ),
            TextButton(
              child: Text(
                'はい',
              ),
              onPressed: () {
                _sendPostFollowRequest(1);
                Navigator.of(context).pop();
                // TODO: 送る
              },
            ),
          ],
        );
      },
    );
  }

  void _sendPostFollowRequest(int userId) async {
    final http = HttpService(); // TODO: Singleton
    Response response;

    try {
      response = await http.postRequest(
        "/follow_requests",
        apiKey: globals.apiKey,
      );
      print(response);
    } on Exception catch (e) {
      ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
    }
  }
}
