import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'config.dart';
import 'ui/landing_page.dart';

Future<void> main() async {
  // referred Andrea's video for initializing firebase app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}
