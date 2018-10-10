import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:geolocator/geolocator.dart';

import 'task1_page.dart';
import 'task2_page.dart';
import 'task3_page.dart';

class Round1Page extends StatefulWidget {
  String teamID;
  Round1Page({Key key, @required this.teamID}):super(key:key);
  static String tag = 'round1-page';
  @override
  _Round1PageState createState() {
    print("Our teamID is "+teamID);
    return new _Round1PageState(teamID:teamID);
  }
}

class _Round1PageState extends State<Round1Page> {
  String teamID;
  _Round1PageState({Key key, @required this.teamID}):super();
  //Essential Variables
  GlobalKey<ScaffoldState> _round1ScaffoldKey = new GlobalKey();
  Permission permission;
  static var ctxt;

  //Location Variables
  final latTT = 12.970591;
  final lonTT = 79.159510;

  final latSJT = 12.970928;
  final lonSJT = 79.163906;

  final latSMV = 12.969258;
  final lonSMV = 79.157736;

  final latGDN = 12.969871;
  final lonGDN = 79.154794;

  final radius = 300;

  var currentDistances = {'sjt': 0, 'tt': 0, 'smv': 0, 'gdn': 0};
  var position;

  String posString = "Unknown";
  String closestStr;
  int closestDist;

  //Global UI Variables
  var btnColor;
  var btnEdgeInsets;

  //Dimension Variables
  final btnTaskHeight = 380.0;
  final btnRefreshHeight = 80.0;

  final btnTaskMinWidth = 380.0;
  final btnRefreshMinWidth = 80.0;

  _onTimeout() async {
    print("GPS Not Enabled.");
    //position = await Geolocator().getLastKnownPosition(LocationAccuracy.high);
    //print(position);
    if(position == null)
      _round1ScaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text("GPS Not Enabled"),
      ));
    //return position;
  }

  reqPermission() async {
    final res = await SimplePermissions.requestPermission(Permission.AccessFineLocation);
    print("permission request result is " + res.toString());
  }

  getDistance(double lat, double lon) async {
    double sjtDist = await Geolocator().distanceBetween(lat, lon, latSJT, lonSJT);
    double ttDist = await Geolocator().distanceBetween(lat, lon, latTT, lonTT);
    double smvDist = await Geolocator().distanceBetween(lat, lon, latSMV, lonSMV);
    double gdnDist = await Geolocator().distanceBetween(lat, lon, latGDN, lonGDN);

    print("SJT: " + sjtDist.toString());
    print("TT: " + ttDist.toString());
    print("SMV: " + smvDist.toString());
    print("GDN: " + gdnDist.toString());

    currentDistances['sjt'] = sjtDist.round();
    currentDistances['tt'] = ttDist.round();
    currentDistances['smv'] = smvDist.round();
    currentDistances['gdn'] = gdnDist.round();

    var dist = currentDistances.values.toList();
    dist.sort();
    closestDist = dist[0];
    if(closestDist < radius)
      closestStr = currentDistances.keys.firstWhere(
              (k) => currentDistances[k] == dist[0], orElse: () => '');
    else closestStr = '';
    print("Closest: " + closestStr);
  }

  getLocation() async{
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    if(geolocationStatus != GeolocationStatus.granted)
      await reqPermission();

    Future<Position> pos = Geolocator().getCurrentPosition();
    pos.timeout(const Duration (seconds: 5), onTimeout: () => _onTimeout())
        .catchError((err){
      print("Timeout Handler");
      posString = "Unknown";

      setState(() {
        posString;
      });
    });

    pos.then((post) async {
      await getDistance(post.latitude, post.longitude);


      switch(closestStr) {
        case 'sjt': {posString = "Current Location-Silver Jubliee Tower";} break;
        case 'tt': {posString = "Current Location-Technology Tower";} break;
        case 'smv': {posString = "Current Location-SMV";} break;
        case 'gdn': {posString = "Current Location-GDN";} break;
        default: posString = "Unknown";
      }

      setState(() {
        posString;
      });

    }).catchError((err) {
      print("Then Handler");
      posString = "Unknown";

      setState(() {
        posString;
      });
    });
  }

  @override
  void initState() {
    getLocation();
  }

  Widget build(BuildContext context) {
    _Round1PageState.ctxt = context;
    this.btnColor = Theme.of(context).accentColor;
    this.btnEdgeInsets = EdgeInsets.symmetric(vertical: 16.0);

    //Widgets
    final lblLocation = Text(
      "Location: " + posString,
      textAlign: TextAlign.center,
      style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0
      ),
    );

    final btnType1 = Padding(
        padding: btnEdgeInsets,
        child: Material(
            child: MaterialButton(
              minWidth: 340.0,
              height: 70.0,
              color: Color.fromRGBO(247, 247, 247, 0.99),
              child: Text('Task Type 1'),

              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Task1_Page(location: posString,)),
                );
                //Do Assign Task
              },  //onPressed
            )
        )
    );

    final btnType2 = Padding(
        padding: btnEdgeInsets,
        child: Material(
            child: MaterialButton(
              minWidth: 340.0,
              height: 70.0,
              color: Color.fromRGBO(247, 247, 247, 0.99),
              child: Text('Task Type 2'),

              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Task2_Page(location: posString,)),
                );
              },  //onPressed
            )
        )
    );

    final btnType3 = Padding(
        padding: btnEdgeInsets,
        child: Material(
            child: MaterialButton(
              minWidth: 340.0,
              height: 70.0,
              color: Color.fromRGBO(247, 247, 247, 0.99),
              child: Text('Task Type 3'),

              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Task3_Page(location: posString,)),
                );
              },  //onPressed
            )
        )
    );

    final btnRefresh = MaterialButton(
              minWidth: 320.0,
              height: 40.0,
              color: Colors.blue,
              child: Text('Refresh Location'),

              onPressed: () async {
                await getLocation();
                setState(() {
                  posString;
                });
              },  //onPressed
            );



    //Build UI
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Round 1!"),
        ),
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
                      child:new Text(posString,textScaleFactor: 1.5, style: new TextStyle(
                        color: Colors.black,
                      ),),
                    )
                  ),
                ),
              ),
              new Container( height: 20.0,),
              btnType1,
              new Container(height: 5.0,),
              btnType2,
              new Container(height: 5.0,),
              btnType3,
              new Container(height: 50.0,),
              btnRefresh,
            ],
          )
        ],
      ),
    );
  }
}