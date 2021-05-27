import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:watching_flutter/http_service.dart';
import 'package:watching_flutter/model/follow_request.dart';
import 'package:watching_flutter/model/user.dart';
import 'package:watching_flutter/globals.dart' as globals;
import 'package:watching_flutter/util/phone_number_util.dart';

import 'alert_dialog_error.dart';

/// 相手を探す 画面
///
/// 電話番号を入力して、見守る相手を探し、見守りリクエストを送信する
///
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
                onPressed: PhoneNumberUtil.isValidForInputting(_phoneNumberController.text) ? _searchUser : null,
                //onPressed: _searchUser,
                child: Text('探す'),
              )
            ],
          )),
    );
  }

  void _searchUser() async {
    final String number = _phoneNumberController.text;
    // TODO: デバッグログには何がいい？
    print(number);

    // Validation
    if (!PhoneNumberUtil.isValid(number)) {
      await ShowDialog.showAlertDialog(context, 'エラー', '電話番号の形式が正しくありません。');
      return;
    }

    // ここでは例外が起こったときは何事もなかったかのように振る舞う
    User user = await _searchUserFromPhoneNumber(PhoneNumberUtil.toE164FormatFromJapanesePhoneNumber(number));

    if (user != null) {
      // 見つかった
      showConfirmDialog(context, user);
    } else {
      // 見つからなかった
      //TODO: ダイアログ表示は await しておいた方がいい？
      ShowDialog.showAlertDialog(context, 'エラー', '相手の電話番号が登録されていません。');
    }
  }

  // TODO: To layer of Repository
  // Dio を意識してよい。画面に依存しない？ダイアログだけは許す？
  // TODO: Dart ドキュメントコメント
  Future<User> _searchUserFromPhoneNumber(String phoneNumber) async {
    try {
      // 検索成功
      return await _sendGetUsers(phoneNumber);
    } on DioError catch (e) {
      if (e.response == null) {
        // ネットワークのエラー
        ShowDialog.showAlertDialog(context, 'エラー', 'ネットワーク環境を確認するか、時間をおいて再度試してください。');
      } else {
        // サーバーのエラー
        ShowDialog.showAlertDialog(context, 'エラー', 'サーバーからのレスポンスが不正です。');
      }

      // TODO: 検索失敗例外
      throw e;
    }
  }

  // TODO: To layer of API
  // 画面に依存しない処理のみ。モデル変換の責任もここ
  Future<User> _sendGetUsers(String phoneNumber) async {
    final http = HttpService();

    try {
      Response response = await http.getRequest(
        "/users",
        apiKey: globals.apiKey,
        queryParameters: {"phone_number": phoneNumber},
      );

      if (response.statusCode != 200) {
        // TODO: 普通はここに来ない？ドキュメントとかで裏を取りたい。
        assert(false);
      }

      return User.fromJson(response.data);
    } on DioError catch (e) {
      // 404 の時だけは特殊 (エラーではなく、見つからなかったという意味)
      // TODO: 空の配列を返すように API を修正した方がいいかも
      if (e.response != null && e.response.statusCode == 404) {
        return null;
      }

      throw e;
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
                // TODO: 電話番号を残しておく？
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'はい',
              ),
              onPressed: () async {
                _sendFollowRequest(user.id);
                // 送信完了する前に閉じる
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendFollowRequest(int userId) async {
    try {
      await _sendPostFollowRequests(userId);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("見守りリクエストを送りました。"),
      ));
    } on DioError catch (e) {
      if (e.response == null) {
        // ネットワークのエラー
        ShowDialog.showAlertDialog(context, 'エラー', 'ネットワーク環境を確認するか、時間をおいて再度試してください。');
      } else {
        // サーバーのエラー
        ShowDialog.showAlertDialog(context, 'エラー', 'サーバーからのレスポンスが不正です。');
      }
    }
  }

  // TODO: To layer of API
  // 画面に依存しない処理のみ。モデル変換の責任もここ
  Future<void> _sendPostFollowRequests(int userId) async {
    final http = HttpService();

    await http.postRequest(
      "/follow_requests",
      apiKey: globals.apiKey,
      data: FollowRequest(userId: userId).toJson(),
    );
  }
}
