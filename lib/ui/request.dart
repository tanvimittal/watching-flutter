import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:watching_flutter/model/follow_request.dart';
import 'package:watching_flutter/ui/alert_dialog_error.dart';
import 'package:watching_flutter/globals.dart' as globals;

import '../http_service.dart';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool _widgetLoaded = false;
  HttpService http;
  List<FollowRequest> getFollowRequests = [];

  // this function is used to reject requests
  Future _rejectRequest (String id, int index) async {
    Response response;

    try {
      response = await http.postRequest("/follow_requests/$id/decline", apiKey: globals.apiKey);
      if(response.statusCode == 200) {
        _updateState(index);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("リクエストを拒否しました。"),
        ));
        print('Request Rejected');
      } else if (response.statusCode == 500) {
        ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
      }
      //if (response)
    } on Exception catch(e) {
      print(e);
    }
  }

  // this function is used to accept requests
  Future _acceptRequest (String id, int index) async {
    Response response;

    try {
      response = await http.postRequest("/follow_requests/$id/accept", apiKey: globals.apiKey);
      if(response.statusCode == 200) {
        _updateState(index);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("リクエストを承認しました。"),
        ));
      } else if (response.statusCode == 500) {
        ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
      }
    } on Exception catch(e) {
      print(e);
    }
  }

  // This is used for removing id from list
  void _updateState(int index) {
    setState(() {
      getFollowRequests.removeAt(index);
    });
  }

  Future _getRequests() async {
    Response response;
    try {
      response = await http.getRequest("/follow_requests", apiKey: globals.apiKey);
      if (response.statusCode == 200) {
        var getAllRequests = response.data;
        getFollowRequests = List<FollowRequest>.from(getAllRequests.map((i) => FollowRequest.fromJson(i)));
      } else {
        ShowDialog.showAlertDialog(context, 'エラー',
            'Some error occured on server side please try after sometime.');
      }
      setState(() {
        _widgetLoaded = true;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override void initState() {
    http = HttpService();
    super.initState();
    _getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return _widgetLoaded ? ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: getFollowRequests.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
          key: UniqueKey(),
            height: 100,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('${getFollowRequests[index].getUserRequests
                    .nickname}からリクエストが来ました。!'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(onPressed:() => _acceptRequest(getFollowRequests[index].id.toString(), index),
                        child: Text('承認')),
                    TextButton( child: Text('拒否'),
                      onPressed:() => _rejectRequest(getFollowRequests[index].id.toString(), index) ,
                    )
                  ],
                ),
              ],
            ),
          );
        }
    ): CircularProgressIndicator();
  }
}
