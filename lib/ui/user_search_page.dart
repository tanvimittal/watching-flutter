import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watching_flutter/globals.dart' as globals;
import 'package:watching_flutter/http_service.dart';
import 'package:watching_flutter/model/follow_request.dart';
import 'package:watching_flutter/model/user.dart';
import 'package:watching_flutter/repository/user_repository.dart';
import 'package:watching_flutter/util/phone_number_util.dart';

import 'alert_dialog_error.dart';
import 'overlay_loading.dart';

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

  bool visibleLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        _buildContent(),
        OverlayLoading(visible: visibleLoading),
      ],
    ));
  }

  Container _buildContent() {
    return Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
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
        ));
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

    // 検索処理
    User user;
    try {
      setState(() {
        visibleLoading = true;
      });

      user =
          await UserRepository.searchUserFromPhoneNumber(PhoneNumberUtil.toE164FormatFromJapanesePhoneNumber(number));
    } on UserRepositoryException catch (e) {
      await ShowDialog.showAlertDialog(context, 'エラー', e.message);
      return;
    } finally {
      setState(() {
        visibleLoading = false;
      });
    }

    if (user != null) {
      // 見つかった
      showConfirmDialog(context, user);
    } else {
      // 見つからなかった
      //TODO: ダイアログ表示は await しておいた方がいい？
      ShowDialog.showAlertDialog(context, 'エラー', '相手の電話番号が登録されていません。');
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
    setState(() {
      visibleLoading = true;
    });

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

    setState(() {
      visibleLoading = false;
    });
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
