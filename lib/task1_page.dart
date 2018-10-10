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
  String teamID;
  Task1_Page({Key key, this.location}): super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Task1(location: location);
  }
}

class Task1 extends StatefulWidget{
  static final String tag= 'task1_page';
  final String location;
  String teamID;
  Task1({Key key, this.location}): super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Task1_State(location:location);
  }
}

class Task1_State extends State<Task1>{
  final String location;
  var taskData;
  String teamID;
  bool visible = false;
  bool txt1 = false;
  Task1_State({Key key, this.location}): super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(visible);
    return new MaterialApp(
      title: "Task Type 1",
      home: new Scaffold(
        appBar: new AppBar(title: new Text("Task Type 1"), backgroundColor: Colors.blueAccent[700],),
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(image: new AssetImage('assets/images/LOcation.png'),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            new Column(
              children: <Widget>[
                new Container(height: 20.0,),
                new Center(
                  child: new Container(
                    height: 120.0,
                    width: 380.0,
                    child:new Container(
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(247, 247, 247, 0.99),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0),
                            bottomLeft: const Radius.circular(30.0),
                            bottomRight: const Radius.circular(30.0),
                          ),
                        ),
                        child:new Center(
                          child: new Text(
                            txt1 ? taskData.toString() : "No Tasks",
                            textScaleFactor: 1.5,
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        /*body: new Container(
            child: visible ? new Text(txt1 ? taskData.toString() : "No Tasks")
                : new Center(child: new Text("Loading Data"))
        ),*/
      )
    );
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    teamID = prefs.getString('teamID');

    if(location == 'Unknown'){
      taskData = "Location Unknown\nNo tasks available";
      txt1 = true;
    } else {
      var ongoingURL = 'http://104.196.117.29/task/getSpecificOngoing';
      var ongoingBody = {
        'teamID': teamID,
        'location': location,
        'type': '1',
      };
      await http.post(ongoingURL, body: ongoingBody)
          .then((res) async {
            print('Get Specific Ongoing');
            print(res.body);
            var data = await jsonDecode(res.body);
        if(data.length == 0) {
          var url = "http://104.196.117.29/task/assignTask";
          var body = {
            "type":"1",
            "location":location,
            "teamID": teamID
          };
          print(body);
          await http.post(url,body:body).then((res) async{
            print('Assign Task');
            print(res.body);
            data = await jsonDecode(res.body);
            taskData = data[0].name + "\n" + data[0].description;
            txt1 = true;
          });
        }
        else {
          txt1 = true;
          taskData = data[0].name + "\n" + data[0].description;
        }
      });
    }

    print(taskData);

    setState(() {
      taskData;
      print("Invoked");
      visible = true;
    });

  }

  @override
  void initState() {
    init();
  }
}