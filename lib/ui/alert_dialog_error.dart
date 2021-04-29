import 'package:flutter/material.dart';

class ShowDialog {

 static Future<void> showAlertDialog(BuildContext context, String title, String errorMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
          style: TextStyle(
            color: Colors.black
          ),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorMessage,
              style: TextStyle(
                  color: Colors.black
              ),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
