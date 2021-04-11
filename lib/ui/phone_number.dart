import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watching_flutter/http_service.dart';

class PhoneNumber extends StatelessWidget {

  HttpService http;
  Future getUser () async {
    //http.postRequest("/users", "fd");
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
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                  onPressed: (
                      ){},
              child: Text('登録'),)
            ],
          )),
    );
  }


  
}
