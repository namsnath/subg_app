import 'package:flutter/material.dart';
import 'register_page.dart';
import 'home-page.dart';

void main() => runApp(SUBGApp());

class SUBGApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    RegisterPage.tag: (context) => RegisterPage(),
    HomePage.tag: (context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUBG App Thingy',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen
      ),
      home: RegisterPage(),
      routes: routes,
    );
  }
}