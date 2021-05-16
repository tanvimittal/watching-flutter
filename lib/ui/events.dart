import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watching_flutter/model/get_events.dart';

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
  Future getMessages() async {
    Response response;

    try {
      print("in get messages");
      response = await http.getRequest("/events", apiKey: globals.apiKey);
      if(response.statusCode == 200) {
        var getAllEvents = response.data;
        _getEvents = List<GetEvents>.from(getAllEvents.map((i) => GetEvents.fromJson(i)));
      } else if (response.statusCode == 500) {
        ShowDialog.showAlertDialog(context, 'エラー', 'Some error occured on server side please try after sometime.');
      }
      setState(() {
        _isLoaded = true;
        /**_scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut); */
      });
    } on Exception catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    http = HttpService();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
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
                           crossAxisAlignment: (_getEvents[index].id == globals.id?CrossAxisAlignment.end:CrossAxisAlignment.start),
                           children: [
                             SizedBox(
                               height: 10,
                             ),
                             Text( _displayTime(_getEvents[index].createdAt)),
                             SizedBox(
                               height: 10,
                             ),
                             Row(
                               crossAxisAlignment: (_getEvents[index].id == globals.id?CrossAxisAlignment.end:CrossAxisAlignment.start),
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
                                       _getEvents[index].name == 'get_up' ? '${_getEvents[index].user.nickname}が起きました！': '${_getEvents[index].user.nickname}が寝ました！',
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
             TextButton(onPressed: () {},
                 child: Text(
                   'おはよう'
                 ),
             ),
             const Spacer(),
             SizedBox(
               width: 100,
               height: 50,
               child: TextButton(onPressed: () {},
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all(Colors.indigo),
                 ),
                 child: Text(
                   'おやすみ',
                   style: TextStyle(
                     color: Colors.white,
                   ),
                 ),
               ),
             )

           ],
         )
       ]
    )


        : CircularProgressIndicator();
  }

  // This function returns messages in the format to be shown to user
  String _displayTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    print(DateFormat.Md().add_jm().format(dateTime));
    return DateFormat.Md().add_jm().format(dateTime);
  }

}
