import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:watching_flutter/model/follow_requests.dart';
import 'package:watching_flutter/ui/alert_dialog_error.dart';
import 'package:watching_flutter/globals.dart' as globals;

import '../http_service.dart';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  Widget _body = CircularProgressIndicator();
  HttpService http;
  List<GetFollowRequests> getFollowRequests;

  Future _getRequests() async {
    Response response;

    try {
      response = await http.getRequest("/follow_requests", globals.apiKey);
      if (response.statusCode == 200) {
        final map = Map<String, dynamic>();
        var getAllRequests = response.data;
        getFollowRequests = List<GetFollowRequests>.from(getAllRequests.map((i) => GetFollowRequests.fromJson(i)));
        setState(() =>
        _body = ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: getFollowRequests.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                child: Center(
                  child: Text(
                    '${getFollowRequests[index].getUserRequests
                        .nickname}からリクエストが来ました。!'),
                ),
              );
            }
        ));
      } else {
        ShowDialog.showAlertDialog(context, 'エラー',
            'Some error occured on server side please try after sometime.');
      }
    } on Exception catch (e) {
      print(e);
    }
    //http.postRequest("/users", "fd");
  }

  @override void initState() {
    http = HttpService();
    super.initState();
    _getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }

}
