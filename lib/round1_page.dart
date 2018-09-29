import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:geolocator/geolocator.dart';

class Round1Page extends StatefulWidget {
  static String tag = 'round1-page';
  @override
  _Round1PageState createState() => new _Round1PageState();
}

class _Round1PageState extends State<Round1Page> {
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
  final btnTaskHeight = 150.0;
  final btnRefreshHeight = 42.0;

  final btnTaskMinWidth = 200.0;
  final btnRefreshMinWidth = 200.0;

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
    bool res = await SimplePermissions.requestPermission(Permission.AccessFineLocation);
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
        case 'sjt': {posString = "SJT (${currentDistances['sjt']}m away)";} break;
        case 'tt': {posString = "TT (${currentDistances['tt']}m away)";} break;
        case 'smv': {posString = "SMV (${currentDistances['smv']}m away)";} break;
        case 'gdn': {posString = "GDN (${currentDistances['gdn']}m away)";} break;
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
              minWidth: btnTaskMinWidth,
              height: btnTaskHeight,
              color: btnColor,
              child: Text('Task Type 1'),

              onPressed: () async {
                //Do Assign Task
              },  //onPressed
            )
        )
    );

    final btnType2 = Padding(
        padding: btnEdgeInsets,
        child: Material(
            child: MaterialButton(
              minWidth: btnTaskMinWidth,
              height: btnTaskHeight,
              color: btnColor,
              child: Text('Task Type 2'),

              onPressed: () async {

              },  //onPressed
            )
        )
    );

    final btnType3 = Padding(
        padding: btnEdgeInsets,
        child: Material(
            child: MaterialButton(
              minWidth: btnTaskMinWidth,
              height: btnTaskHeight,
              color: btnColor,
              child: Text('Task Type 3'),

              onPressed: () async {

              },  //onPressed
            )
        )
    );

    final btnRefresh = Padding(
        padding: btnEdgeInsets,
        child: Material(
            child: MaterialButton(
              minWidth: btnRefreshMinWidth,
              height: btnRefreshHeight,
              color: btnColor,
              child: Text('Refresh Location'),

              onPressed: () async {
                await getLocation();
                setState(() {
                  posString;
                });
              },  //onPressed
            )
        )
    );

    //Build UI
    return Scaffold(
        appBar: AppBar(
          title: Text('Round 1'),
        ),
        key: _round1ScaffoldKey,
        body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 50.0, right: 50.0),
              children: <Widget>[
                lblLocation,
                btnType1,
                btnType2,
                btnType3,
                btnRefresh,
              ],
            )
        )
    );
  }
}