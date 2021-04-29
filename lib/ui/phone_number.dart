import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watching_flutter/model/phone_number_post.dart';
import 'package:watching_flutter/model/user.dart';
import 'package:watching_flutter/model/user_post.dart';
import 'package:watching_flutter/ui/alert_dialog_error.dart';

import '../http_service.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final myController = TextEditingController();
  HttpService http;


  Future getUser (PhoneNumberPost phoneNumber) async {
    Response response;

    try {
      response = await http.postRequest("/users", phoneNumber.toJson());
      print('In api');
      if(response.statusCode == 200) {
        User user = User.fromJson(response.data);
        print(user.apiKey);
      } else {
        print("Some error occured");
      }
      //if (response)
    } on Exception catch(e) {
      print(e);
    }
    //http.postRequest("/users", "fd");
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
              new TextField(
                decoration: new InputDecoration(labelText: "Enter your number"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: myController, // Only numbers can be entered
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('登録'),
              )
            ],
          )),
    );
  }

  // This function will register user on server
  void _registerUser() {
    String phoneNumber = myController.text;
    UserPost userPost = UserPost(countryCode: "JP", original: phoneNumber);
    phoneNumber = check(phoneNumber);
    if (phoneNumber!=null) {
      print(userPost.original);
      getUser(PhoneNumberPost(userPost: userPost));
    }
  }

  /// This function takes phoneNumber and returns phone number after deleting first
  /// number, if it is of 11 digits
  String check(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      ShowDialog.showAlertDialog(context, 'エラー', '電話番号を入力してください。');
      return null;
    }

    if (phoneNumber.length !=11 ) {
      ShowDialog.showAlertDialog(context, 'エラー', '電話番号の桁数に誤りがあります。');
      return null;
    }

    return phoneNumber.substring(1);

  }

}
