import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(SUBGApp());

class SUBGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUBG App Thingy',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen
      ),
      home: LoginPage()
    );
  }
}