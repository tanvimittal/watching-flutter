import 'package:flutter/material.dart';

import '../repository/user_repository.dart';
import '../util/phone_number_util.dart';
import 'alert_dialog_error.dart';
import 'nickname.dart';
import 'overlay_loading.dart';

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

  bool visibleLoading = false;

  @override
  void dispose() {
    // Clean the controller when the widget is disposed.
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildContent(),
          OverlayLoading(visible: visibleLoading),
        ],
      ),
    );
  }

  Container _buildContent() {
    return Container(
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
        ));
  }

  void _registerUser() async {
    String phoneNumber = _phoneNumberController.text;

    // Validation
    if (!PhoneNumberUtil.isValid(phoneNumber)) {
      ShowDialog.showAlertDialog(context, 'エラー', '電話番号の形式が正しくありません。');
      return;
    }

    try {
      setState(() {
        visibleLoading = true;
      });

      await UserRepository.registerUser(phoneNumber);
    } on UserRepositoryException catch (e) {
      await ShowDialog.showAlertDialog(context, 'エラー', e.message);
      return;
    } finally {
      setState(() {
        visibleLoading = false;
      });
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Nickname()),
          (Route<dynamic> route) => false,
    );
  }
}
