import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:geolocator/geolocator.dart';



class Task1_Page extends StatelessWidget{
  final String location;
  Task1_Page({Key key, @required this.location }): super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Task1();
  }
}

class Task1 extends StatefulWidget{
  static final String tag= 'task1_page';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class Task1_State extends State<Task1>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}