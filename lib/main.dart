import 'package:flutter/material.dart';
import 'register_page.dart';
import 'home-page.dart';
import 'round1_page.dart';

void main() => runApp(SUBGApp());

class SUBGApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    RegisterPage.tag: (context) => RegisterPage(),
    HomePage.tag: (context) => HomePage(),
    Round1Page.tag: (context) => Round1Page(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUBG App Thingy',
      theme: ThemeData(
        //primarySwatch: Colors.lightGreen,
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      home: RegisterPage(),
      routes: routes,
    );
  }
}