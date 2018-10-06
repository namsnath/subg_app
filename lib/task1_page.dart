import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:geolocator/geolocator.dart';



class Task1_Page extends StatelessWidget{
  final String location;

  Task1_Page({Key key, @required this.location }): super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Task1(location: location,);
  }
}

class Task1 extends StatefulWidget{
  static final String tag= 'task1_page';
  final String location;
  Task1({Key key, @required this.location }): super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Task1_State(location:location,);
  }
}

class Task1_State extends State<Task1>{
  final String location;
  var taskData;
  bool visible = false;
  Task1_State({Key key, @required this.location }): super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(visible);
    return new MaterialApp(
      title: "Task Type 1",
      home: new Scaffold(
        appBar: new AppBar(title: new Text("Task Type 1"),),
        body: new Container(
            child: visible?new Text('Your Location'+location)
                :new Center(child:new Text("Loading Data"))
        ),
      )
    );
  }

  void init() async{
    var url= "http://104.196.117.29/startTask";
    var body={
      'teamId': '1',
      'location':location,
      'type':'1'
    };
    await http.post(url,body:body).then((res) async{
      print(res.body);
      taskData= await jsonDecode(res.body);

    });

    setState(() {
      taskData;
      print("Invoked");
      visible=true;
    });

  }

  @override
  void initState() {
    init();

  }
}