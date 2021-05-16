import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watching_flutter/http_service.dart';
import 'package:watching_flutter/model/follow_request.dart';
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
    final http = HttpService();

    try {
      Response response = await http.getRequest(
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
        // TODO: ダイアログ表示は await しておいた方がいい？
      } else {
        // TODO: 普通はここに来ない？ドキュメントとか裏を取りたい。
        ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
      }
    } on DioError catch (e) {
      // TODO: エラー処理は UI 部分で行う
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          ShowDialog.showAlertDialog(context, 'エラー', '相手の電話番号が登録されていません。');
        } else {
          ShowDialog.showAlertDialog(context, 'エラー', 'サーバーからのレスポンスが不正です。');
        }
      } else {
        // 通信系のエラー
        ShowDialog.showAlertDialog(context, 'エラー', 'ネットワーク環境を確認するか、時間をおいて再度試してください。');
      }
    } catch (e) {
      // TODO: どう処理する？上に投げてもいいかも。
      ShowDialog.showAlertDialog(context, 'エラー', 'Fatal error occurred.');
      print(e);  // TODO: ログ出力 and もっとすぐに気づくように
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
                _sendPostFollowRequest(user.id);
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
    final http = HttpService();

    try {
      print(FollowRequest(userId: userId).toJson());
      await http.postRequest(
        "/follow_requests",
        apiKey: globals.apiKey,
        data: FollowRequest(userId: userId).toJson(),
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("見守りリクエストを送りました。"),
      ));
    } on Exception catch (e) {
      ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
    }
  }
}
