import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';
import 'home-page.dart';
import 'round1_page.dart';
import 'task1_page.dart';
import 'task2_page.dart';
import 'task3_page.dart';


void main() => runApp(SUBGApp());

class SUBGApp extends StatelessWidget {
  var page;
  var teamID = null;

  final routes = <String, WidgetBuilder>{
    RegisterPage.tag: (context) => RegisterPage(),
    HomePage.tag: (context) => HomePage(),
    Round1Page.tag: (context) => Round1Page(),
    Task1.tag: (context) => Task1(),
    Task2.tag: (context) => Task2(),
    Task3.tag: (context) => Task3(),
  };

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    teamID = prefs.getString('teamID') ?? null;
    print('TeamID: $teamID');
  }

  @override
  void initState() {
    init();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'SUBG App Thingy',
      theme: ThemeData(
        //primarySwatch: Colors.lightGreen,
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent[700],
        accentColor: Colors.blue,
      ),
      home: (teamID == null) ? RegisterPage() : Round1Page(),
      routes: routes,
    );
  }
}