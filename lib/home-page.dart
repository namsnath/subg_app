import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Permission permission;
  Position position;
  String posString = "Unknown";

  double sjtDistance, ttDistance, smvDistance, gdnDistance;

  TextEditingController _c = new TextEditingController();
  TextEditingController _sjt = new TextEditingController();
  TextEditingController _tt = new TextEditingController();
  TextEditingController _smv = new TextEditingController();
  TextEditingController _gdn = new TextEditingController();

  final latTT = 12.970591;
  final lonTT = 79.159510;

  final latSJT = 12.970928;
  final lonSJT = 79.163906;

  final latSMV = 12.969258;
  final lonSMV = 79.157736;

  final latGDN = 12.969871;
  final lonGDN = 79.154794;

  final radius = 50;

  @override
  onRequest(Permission permission) {
    setState(() => this.permission = permission);
    print(permission);
  }

  reqPermission() async {
    bool res = await SimplePermissions.requestPermission(Permission.AccessFineLocation);
    print("permission request result is " + res.toString());
  }

  getDistance(double lat, double lon) async {
    //return await Geolocator().distanceBetween(p1Lat, p1Lon, p2Lat, p2Lon);
    double sjtDist = await Geolocator().distanceBetween(lat, lon, latSJT, lonSJT);
    double ttDist = await Geolocator().distanceBetween(lat, lon, latTT, lonTT);
    double smvDist = await Geolocator().distanceBetween(lat, lon, latSMV, lonSMV);
    double gdnDist = await Geolocator().distanceBetween(lat, lon, latGDN, lonGDN);

    sjtDistance = sjtDist;
    ttDistance = ttDist;
    smvDistance = smvDist;
    gdnDistance = gdnDist;

    _sjt.text = sjtDist.toString();
    _tt.text = ttDist.toString();
    _smv.text = smvDist.toString();
    _gdn.text = gdnDist.toString();
  }

   getLastLocation() async {
    print("Couldn't get accurate location. Check GPS.");
    position = await Geolocator().getLastKnownPosition(LocationAccuracy.high);
    print(position);
    return position;
  }

  _onTimeout() async {
    print("GPS Not Enabled.");
    position = await Geolocator().getLastKnownPosition(LocationAccuracy.high);
    print(position);
    if(position == null)
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text("GPS Not Enabled"),
      ));
    return position;
  }

  getLocation() async {
    Future<Position> pos = Geolocator().getCurrentPosition();
    pos.timeout(const Duration (seconds: 5), onTimeout: () => _onTimeout())
        .catchError((err){
          print("Handle 1");
          setState(() {
            posString = "Unknown";
          });
        });

    pos.then((post) async {
      await getDistance(post.latitude, post.longitude);

      if(sjtDistance < 205)
        posString = "SJT";
      else if (ttDistance < 205)
        posString = "TT";
      else if(smvDistance < 205)
        posString = "SMV";
      else if(gdnDistance < 205)
        posString = "GDN";
      else
        posString = "Unknown";

      setState(() {
        posString;
      });
      print(pos);
      _c.text = post.toString();
      print(post.latitude);
      print(post.longitude);
      getDistance(post.latitude, post.longitude);
    }).catchError((err) =>
      //Do something maybe?
      print(err));
      //print("Handle 2"));
  }



  Widget build(BuildContext context) {
    final btnPermission = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          //borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.lightGreenAccent.shade100,
          //elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () {
              reqPermission();
            },
            color: Colors.lightGreenAccent,
            child: Text('Get Permission', style: TextStyle(color: Colors.black)),
          ),
        )
    );

    final txtLocation = TextField(
      controller: _c,
        decoration: InputDecoration(
          labelText: 'Current Location',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        )
    );

    final txtSJTDistance = TextField(
      controller: _sjt,
        decoration: InputDecoration(
          labelText: 'Distance from SJT',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        )
    );

    final txtTTDistance = TextField(
      controller: _tt,
        decoration: InputDecoration(
          labelText: 'Distance from TT',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        )
    );

    final txtSMVDistance = TextField(
      controller: _smv,
        decoration: InputDecoration(
          labelText: 'Distance from SMV',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        )
    );

    final txtGDNDistance = TextField(
      controller: _gdn,
        decoration: InputDecoration(
          labelText: 'Distance from GDN',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        )
    );

    final lblLoc = Text(
      "Location: " + posString,
      textAlign: TextAlign.center,
      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)
    );

    final btnUpdate = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          //borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.lightGreenAccent.shade100,
          //elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,

            onPressed: () async {
              GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
              print(geolocationStatus);

              if(geolocationStatus == GeolocationStatus.granted) {
                //pos = await Geolocator().getCurrentPosition(LocationAccuracy.high);
                await getLocation();
                /*Future<Position> pos = Geolocator().getCurrentPosition();
                pos.timeout(const Duration (seconds: 5), onTimeout: _onTimeout);
                pos.then((post) async {
                  _c.text = post.toString();
                  print(post.latitude);
                  print(post.longitude);
                  getDistance(post.latitude, post.longitude);
                });*/
                //_sjt = getDistances(p1Lat, p1Lon, p2Lat, p2Lon)
              }
              else print("Not granted I guess.");

            },
            color: Colors.lightGreenAccent,
            child: Text('Update Location', style: TextStyle(color: Colors.black)),
          ),
        )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      key: _scaffoldKey,
      body: new Builder(
        builder: (BuildContext context) {
          return new Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 50.0, right: 50.0),
              children: <Widget>[
                lblLoc,
                btnPermission,
                btnUpdate,
                txtLocation,
                SizedBox(height: 18.0),
                txtSJTDistance,
                SizedBox(height: 18.0),
                txtTTDistance,
                SizedBox(height: 18.0),
                txtSMVDistance,
                SizedBox(height: 18.0),
                txtGDNDistance,
              ],
            ),
          );
        }
      )


    );
  }
}