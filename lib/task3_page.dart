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



class Task3_Page extends StatelessWidget{
  final String location;
  String teamID;

  Task3_Page({Key key,   this.location}): super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Task3(location: location,);
  }
}

class Task3 extends StatefulWidget{
  static final String tag = 'task3_page';
  final String location;
  Task3({Key key,   this.location }): super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Task3_State(location:location,);
  }
}

class Task3_State extends State<Task3>{
  final String location;
  var taskData1, taskData2, taskData3;
  String teamID;
  bool visible = false;
  bool txt1 = false;
  bool txt2 = false;
  bool txt3 = false;
  Task3_State({Key key,   this.location }): super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(visible);
    return Scaffold(
          appBar: new AppBar(title: new Text("Task Type 3"), backgroundColor: Colors.blueAccent[700],),
          body: new Stack(
            children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(image: new AssetImage('assets/images/LandingPage.jpg'),
                      fit: BoxFit.cover,
                    )
                ),
              ),

              new Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(image: new AssetImage('assets/images/SUBG_background.png'),
                      fit: BoxFit.cover,
                    )
                ),
              ),

              visible ? new SingleChildScrollView(
                child: new Column(
                children: <Widget>[
                  new Container(height: 90.0,),
                  new SingleChildScrollView(child: new Center(
                    child: new Container(
                      height: 200.0,
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
                          child:new Center( child: new Padding(padding: new EdgeInsets.all(8.0),
                            child: new SingleChildScrollView( child: new Text(
                              txt1 ? taskData1.toString() : "No Task",
                              textScaleFactor: 1.5,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Colors.black,
                              ),
                            )),
                          ))
                      ),
                    ),
                  )),

                  new Container(height: 20.0),

                  txt2 ? new SingleChildScrollView(child: new Center(
                    child: new Container(
                      height: 200.0,
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
                          child:new Center( child: new Padding(padding: new EdgeInsets.all(8.0),
                            child: new SingleChildScrollView( child:new Text(
                              txt2 ? taskData2.toString() : "No Task",
                              textScaleFactor: 1.5,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Colors.black,
                              ),
                            ) ),
                          )
                      ),
                      )),
                  )) : new Container(),


                  new Container(height: 20.0),

                  txt3 ? new Center(
                    child: new Container(
                      height: 200.0,
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
                          child:new Center( child: new Padding(padding: new EdgeInsets.all(8.0),
                            child: new SingleChildScrollView( child:new Text(
                              txt3 ? taskData3.toString() : "No Task",
                              textScaleFactor: 1.5,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Colors.black,
                              ),
                            )),
                          )
                          )),
                    ),
                  ) : new Container(),

              ],
              )
              ) : new Center(child: new Text('Loading Data'))
            ],
          ),
          /*body: new Container(
            child: visible ? new Text(txt1 ? taskData.toString() : "No Tasks")
                : new Center(child: new Text("Loading Data"))
        ),*/



    );
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    teamID = prefs.getString('teamID');
    //teamID = teamID.substring(1, teamID.length - 1);

    if(location == 'Unknown'){
      taskData1 = "Location Unknown\nNo tasks available";
      txt1 = true;
      txt2 = false;
      txt3 = false;
    } else {
      var ongoingURL = 'http://104.196.117.29/task/getSpecificOngoing';
      var ongoingBody = {
        'teamID': teamID,
        'location': location,
        'type': '3',
      };
      await http.post(ongoingURL, body: ongoingBody)
          .then((res) async {
        print('Get Specific Ongoing');
        //print(res.body);
        var data = await jsonDecode(res.body);
        print(data);
        if(data.length == 0) {
          var url = "http://104.196.117.29/task/assignTask";
          var body = {
            "type":"3",
            "location":location,
            "teamID": teamID
          };
          //print(body);
          await http.post(url,body:body).then((ares) async{
            print('Assign Task');
            //print(res.body);
            var adata = await jsonDecode(ares.body);
            print(adata);
            if(adata['reqTask'].length == 0)
            {
              txt1 = false;
              txt2 = false;
              txt3 = false;
            }

            if(adata['reqTask'].length == 1) {
              taskData1 = adata[0]['reqTask']['name'] + "\n" + adata[0]['reqTask']['description'];
              txt1 = true;
              txt2 = false;
              txt3 = false;
            }
            if(adata['reqTask'].length == 2) {
              taskData1 = adata['reqTask'][0]['name'] + "\n" + adata['reqTask'][0]['description'];
              taskData2 = adata['reqTask'][1]['name'] + "\n" + adata['reqTask'][1]['description'];
              txt1 = true;
              txt2 = true;
              txt3 = false;
            }
            if(adata['reqTask'].length == 3) {
              taskData1 = adata['reqTask'][0]['name'] + "\n" + adata['reqTask'][0]['description'];
              taskData2 = adata['reqTask'][1]['name'] + "\n" + adata['reqTask'][1]['description'];
              taskData3 = adata['reqTask'][2]['name'] + "\n" + adata['reqTask'][2]['description'];
              txt1 = true;
              txt2 = true;
              txt3 = true;
            }
          });
        }
        else {
          //print(data[0]['name']);
          if(data.length == 1) {
            taskData1 = data[0]['name'] + "\n" + data[0]['description'];
            txt1 = true;
            txt2 = false;
            txt3 = false;
          }
          if(data.length == 2) {
            taskData1 = data[0]['name'] + "\n" + data[0]['description'];
            taskData2 = data[1]['name'] + "\n" + data[1]['description'];
            txt1 = true;
            txt2 = true;
            txt3 = false;
          }
          if(data.length == 3) {
            taskData1 = data[0]['name'] + "\n" + data[0]['description'];
            taskData2 = data[1]['name'] + "\n" + data[1]['description'];
            taskData3 = data[2]['name'] + "\n" + data[2]['description'];
            txt1 = true;
            txt2 = true;
            txt3 = true;
          }
        }
      });
    }

    //print(taskData1);
    //print(taskData2);

    setState(() {
      taskData1;
      taskData2;
      taskData3;
      print("Invoked");
      visible = true;
      txt1;
      txt2;
      txt3;
    });
  }

  @override
  void initState() {
    init();

  }
}