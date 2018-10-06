import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:geolocator/geolocator.dart';


class Task2_Page extends StatelessWidget{
  final String location;
  Task2_Page({Key key, @required this.location }): super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Task2();
  }
}

class Task2 extends StatefulWidget {

  static final String tag= "task2_page";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Task2_State();
  }
}

class Task2_State extends State<Task2>{
  @override
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Task Type 2",
      home: new Scaffold(
        appBar: new AppBar(title: new Text("Task Type 2"),),
        body: new Container(
            child: new Text('All tasks will be shown here')
        ),
      ),
    );
  }
}