import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watching_flutter/model/get_events.dart';
import 'package:watching_flutter/model/post_events.dart';

import '../http_service.dart';
import 'alert_dialog_error.dart';
import 'package:watching_flutter/globals.dart' as globals;

// This class is used for events
class Events extends StatefulWidget {
  const Events({Key key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events>{
  HttpService http;
  bool _isLoaded = false;
  ScrollController _scrollController;
  List<GetEvents> _getEvents = [];

  // This function is used to get messages.
  Future _getMessages() async {
    Response response;

    try {
      print("in get messages");
      response = await http.getRequest("/events", apiKey: globals.apiKey);
      if(response.statusCode == 200) {
        var getAllEvents = response.data;
        _getEvents = List<GetEvents>.from(getAllEvents.map((i) => GetEvents.fromJson(i)));
        print(globals.id);
      } else if (response.statusCode == 500) {
        ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
      }
      setState(() {
        _isLoaded = true;
      });

    } on Exception catch(e) {
      print(e);
    }
  }

  // this function is used to send events to server
  Future _postEvents(String eventName) async {
    Response response;

    try {
      print("in post events function");
      response = await http.postRequest("/events", data: PostEvents(name: eventName).toJson(),apiKey: globals.apiKey);
      if(response.statusCode == 200) {
        _getMessages();
      } else if (response.statusCode == 500) {
        ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
      }
      setState(() {
        _isLoaded = true;
      });
    } on Exception catch(e) {
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    http = HttpService();
    _scrollController = ScrollController();
    _getMessages();
  }

  @override
  Widget build(BuildContext context) {
    // scroll to the bottom
    if(_isLoaded == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) { _scrollController.jumpTo(_scrollController.position.maxScrollExtent); });
    }
    return _isLoaded ? Column(
       children: [
         Expanded(
             child: Scrollbar(
                 child: ListView.builder(
                     padding: const EdgeInsets.all(8),
                     itemCount: _getEvents.length,
                     controller: _scrollController,
                     itemBuilder: (BuildContext context, int index) {
                       return Container(
                         height: 100,
                         child: Column(
                           crossAxisAlignment: (_getEvents[index].user.id == globals.id?CrossAxisAlignment.end:CrossAxisAlignment.start),
                           children: [
                             SizedBox(
                               height: 10,
                             ),
                             Text( _displayTime(_getEvents[index].createdAt)),
                             SizedBox(
                               height: 10,
                             ),
                             Row(
                               mainAxisAlignment: (_getEvents[index].user.id == globals.id?MainAxisAlignment.end:MainAxisAlignment.start),
                               children: [
                                 Container(
                                   //width: 200,
                                   padding: EdgeInsets.all(10.0),
                                   height: 50,
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(24.0),
                                     color: Colors.blue,
                                   ),
                                   child: Center (
                                     child: Text(
                                       _getEvents[index].name == 'get_up' ? '${_getEvents[index].user.nickname}さんが起きました！': '${_getEvents[index].user.nickname}さんが寝ました！',
                                       style: TextStyle(
                                         fontFamily: 'Arial',
                                         fontSize: 18,
                                         color: Colors.white,
                                         height: 1,
                                       ),
                                       textAlign: TextAlign.center,
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       );
                     }
                   // This takes user to the end of list
                 )
             ),
         ),
         Row(
           children: [
             SizedBox(
               width: 10,
             ),
             SizedBox(
               width: 100,
               height: 50,
               child: TextButton(onPressed: () => _postEvents("get_up"),
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                 ),
                 child: Text(
                   'おはよう',
                   style: TextStyle(
                     color: Colors.white,
                   ),
                 ),
               ),
             ),
             const Spacer(),
             SizedBox(
               width: 100,
               height: 50,
               child: TextButton(onPressed: _getMessages,
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                 ),
                 child: Text(
                   '再読み込み',
                   style: TextStyle(
                     color: Colors.white,
                   ),
                 ),
               ),
             ),
             const Spacer(),
             SizedBox(
               width: 100,
               height: 50,
               child: TextButton(onPressed:() => _postEvents("go_to_bed"),
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                 ),
                 child: Text(
                   'おやすみ',
                   style: TextStyle(
                     color: Colors.white,
                   ),
                 ),
               ),
             ),
             SizedBox(
               width: 10,
             ),
           ],
         )
       ]
    )
        : CircularProgressIndicator();
  }

  // This function returns messages in the format to be shown to user
  String _displayTime(String time) {
    DateTime dateTime = DateTime.parse(time).toLocal();
    return DateFormat.Md().add_jm().format(dateTime);
  }

}
