import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'round1_page.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _registerScaffoldKey = new GlobalKey();

  String p1, p2, p3;
  bool _autoValidate = false;
  bool visibilityForm = false;

  var resp ="";
  List<dynamic> reglist;

  List filter(String filtertext) {
    return reglist.where((f) => f.toUpperCase().contains(filtertext.toUpperCase())).toList();
  }

  final TextEditingController _typeAheadController1 = TextEditingController();
  final TextEditingController _typeAheadController2 = TextEditingController();
  final TextEditingController _typeAheadController3 = TextEditingController();

  void submitTeam() async {
    var p3Data, name3, gravitasID3, body;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      var p1Data = p1.split(" - ");
      var p2Data = p2.split(" - ");

      if(p3 != "") {
        p3Data = p3.split(" - ");
        name3 = p3Data[0];
        gravitasID3 = p3Data[1];
      }

      var url = 'http://104.196.117.29/team/registerTeam';

      if(p3 != "") {
        body = {'name1': p1Data[1], 'gravitasID1': p1Data[0],
          'name2': p2Data[1], 'gravitasID2': p2Data[0],
          'name3': name3, 'gravitasID3': gravitasID3};
      } else
        body = {'name1': p1Data[1], 'gravitasID1': p1Data[0], 'name2': p2Data[1], 'gravitasID2': p2Data[0]};
      print(body);
      await http.post(url, body: body)
          .then((res) {
            print("Post Successfull"+res.body);
            resp=res.body.toString();
            prefs.setString('teamID', resp);

      });
      Navigator.of(context).pushReplacementNamed(Round1Page.tag);

    } else {
      print("Validation error part");
      setState(() {
        _autoValidate = true;
      });
      /*_registerScaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text("Enter Data"),
              ));*/
    }
  }
  var regs;


  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var teamID = prefs.getString('teamID') ?? null;
    print('Team ID: $teamID');

    if(teamID == null) {
      var url = 'http://104.196.117.29/user/getNotRegistered';
      await http.get(url)
          .then((response) async {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        regs = await jsonDecode(response.body);

        /*_registerScaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Participant Data loaded"),
      ));*/
      });
      //print('response decoded '+regs);
      reglist = regs.map((reg) => (reg['gravitasID'] + " - " + reg['name']).toString()).toList();
      setState(() {
        reglist;
        visibilityForm = true;
      });
    } else
      Navigator.of(context).pushReplacementNamed(Round1Page.tag);
  }

  @override
  void initState() {
    init();
  }

  @override
  Widget build(BuildContext context) {

    final tatxtParticipant1 = TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._typeAheadController1,
          decoration: InputDecoration(
            labelText: 'Participant 1',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          )
      ),
      debounceDuration: Duration(milliseconds: 100),
      suggestionsCallback: (pattern) {
        return filter(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        this._typeAheadController1.text = suggestion;
      },
      validator: (value) {
        if (value.length == 0) {
          return 'Participant name cannot be empty';
        }
        else if (!reglist.contains(value))
          return 'Enter valid participant name';
        else if (value == _typeAheadController2.text || value == _typeAheadController3.text)
          return 'Both participants cannot be the same';
      },
      onSaved: (value) => p1 = value,
    );

    final tatxtParticipant2 = TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._typeAheadController2,
          decoration: InputDecoration(
            labelText: 'Participant 2',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          )
      ),
      debounceDuration: Duration(milliseconds: 100),
      suggestionsCallback: (pattern) {
        return filter(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        this._typeAheadController2.text = suggestion;
      },
      validator: (value) {
        if (value.length == 0) {
          return 'Participant name cannot be empty';
        }
        else if (!reglist.contains(value))
          return 'Enter valid participant name';
        else if (value == _typeAheadController1.text || value == _typeAheadController3.text)
          return 'Both participants cannot be the same';
      },
      onSaved: (value) => p2 = value,
    );

    final tatxtParticipant3 = TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._typeAheadController3,
          decoration: InputDecoration(
            labelText: 'Participant 3 (Optional)',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          )
      ),
      debounceDuration: Duration(milliseconds: 100),
      suggestionsCallback: (pattern) {
        return filter(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        this._typeAheadController3.text = suggestion;
      },
      validator: (value) {
        /*if (value.length == 0) {
          return 'Participant name cannot be empty';
        }*/
        if (!reglist.contains(value))
          return 'Enter valid participant name';
        else if (value == _typeAheadController1.text || value == _typeAheadController2.text)
          return 'Both participants cannot be the same';
      },
      onSaved: (value) => p3 = value,
    );


    final btnSubmit = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        //borderRadius: BorderRadius.circular(30.0),
        //shadowColor: Colors.lightGreenAccent.shade100,
        //elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: submitTeam,
          color: Theme.of(context).primaryColor,
          child: Text('Log In', style: new TextStyle(
            color: Colors.white,
          ),),

        ),
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      key: _registerScaffoldKey,
      body: visibilityForm?
      new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage('assets/images/LandingPage.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                )
            ),
          ),
          new ListView(
            children: <Widget>[
              //new Container(height: 90.0),
              /*new Text("Register",textScaleFactor: 3.0,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                ),
              ),*/
              new Container(height: 30.0),
              new Center(
                child: new Container(
                  height: 500.0,
                  width: 350.0,

                  child: new Container(
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(247, 247, 247, 0.99),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0),
                            bottomLeft: const Radius.circular(30.0),
                            bottomRight: const Radius.circular(30.0),
                          ),
                    ),
                    child: new Center(
                      child: Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 50.0, right: 50.0),
                            children: <Widget>[
                              SizedBox(height: 18.0),
                              new Text("Register",textScaleFactor: 3.0,
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              tatxtParticipant1,
                              SizedBox(height: 18.0),
                              tatxtParticipant2,
                              SizedBox(height: 18.0),
                              tatxtParticipant3,
                              SizedBox(height: 48.0),
                              btnSubmit,
                            ],
                          )
                      ),
                    )
                  ),
                )
              )
            ]
          )
        ]
      ):new Center(
        child: new Text("Loading Data"),
      )
    );
  }
}