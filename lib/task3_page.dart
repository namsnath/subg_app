import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:geolocator/geolocator.dart';


class Task3_Page extends StatelessWidget{
   final String location;
  Task3_Page({Key key, @required this.location }): super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Task3();
  }
}

class Task3 extends StatefulWidget {

  static final String tag= "task3_page";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Task3_State();
  }
}

class Task3_State extends State<Task3>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Task Type 3",
      home: new Scaffold(
        appBar: new AppBar(title: new Text("Task Type 3"),),
        body: new Container(
            child: new Text('All tasks will be shown here')
        ),
      ),
    );
  }
}