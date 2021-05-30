import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:watching_flutter/model/phone_number_post.dart';
import 'package:watching_flutter/model/user.dart';
import 'package:watching_flutter/model/user_post.dart';
import 'package:watching_flutter/ui/alert_dialog_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watching_flutter/ui/nickname.dart';
import 'package:watching_flutter/globals.dart' as globals;
import 'package:watching_flutter/util/phone_number_util.dart';

import '../http_service.dart';

/// 電話番号登録 画面
///
/// 電話番号を入力して、ユーザー登録を行う。(iOS では電話番号を自動で取得できないため)
///
class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    // Clean the controller when the widget is disposed.
    _phoneNumberController.dispose();
    super.dispose();
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
              Text(
                "自分の電話番号を入れてください。",
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 8.0,
              ),
              PhoneNumberUtil.buildTextFieldForPhoneNumber(
                controller: _phoneNumberController,
                onChanged: (String s) {
                  setState(() {
                    // 送信ボタンを Enable にするためだけの setState()
                    // TODO: Is there more smart way?
                  });
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: PhoneNumberUtil.isValidForInputting(_phoneNumberController.text) ? _registerUser : null,
                child: Text('登録'),
              )
            ],
          )),
    );
  }

  // TODO: To layer of Repository
  // Dio を意識してよい。画面に依存しない？ダイアログだけは許す？
  // This function will register user on server
  void _registerUser() async {
    String phoneNumber = _phoneNumberController.text;

    // Validation
    if (!PhoneNumberUtil.isValid(phoneNumber)) {
      ShowDialog.showAlertDialog(context, 'エラー', '電話番号の形式が正しくありません。');
      return;
    }

    UserPost userPost = UserPost(countryCode: "JP", original: phoneNumber);
    print(userPost.original);

    try {
      User user = await _sendPostUsers(PhoneNumberPost(userPost: userPost));
      print(user.apiKey);

      // TODO: SharedPreferences リファクタリング
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('api_key', user.apiKey);
      globals.apiKey = user.apiKey;
      prefs.setInt('id', user.id);
      globals.id = user.id;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Nickname()),
            (Route<dynamic> route) => false,
      );

    } on DioError catch (e) {
      if (e.response == null) {
        // ネットワークのエラー
        ShowDialog.showAlertDialog(context, 'エラー', 'ネットワーク環境を確認するか、時間をおいて再度試してください。');
      } else {
        // サーバーのエラー
        ShowDialog.showAlertDialog(context, 'エラー', 'サーバーからのレスポンスが不正です。');
      }

      // TODO: ここ例外投げていい？
      // ここで例外投げてもアプリは落ちない。
      throw e;
    }
  }

  // TODO: To layer of API
  // 画面に依存しない処理のみ。モデル変換の責任もここ
  // 通信エラーの時は　DioError を投げる
  Future<User> _sendPostUsers(PhoneNumberPost phoneNumber) async {
    final http = HttpService();

    Response response = await http.postRequest(
      "/users",
      data: phoneNumber.toJson(),
    );

    return User.fromJson(response.data);
  }
}
