import 'package:flutter/material.dart';
import 'Index.dart';
import 'SplashScreen.dart';
import 'builder/SurahViewBuilder.dart';
import 'localNotification.dart';
import 'package:ion/library/Globals.dart' as globals;
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          'index': (context) => SurahViewBuilder(pages: globals.bookmarkedPage - 1),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          primaryColor: Colors.lightBlue,
          backgroundColor: Colors.white,
        ),
        home: SplashScreen());
  }
}
