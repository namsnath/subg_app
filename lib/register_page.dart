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

  String p1, p2;
  bool _autoValidate = false;
  bool visibilityForm = false;


  /*final regs = [
    {
      "registered": false,
      "_id": "5bb06bd98884a4659421cda5",
      "name": "Namit Nathwani",
      "email": "namsnath@gmail.com",
      "phone": "123456789",
      "gravitasID": "G18I1234",
      "regNo": "17BCI0113"
    },
    {
      "registered": false,
      "_id": "5bb06c1e8884a4659421cda6",
      "name": "Yash Gupta",
      "email": "abc@gmail.com",
      "phone": "321654987",
      "gravitasID": "G18I4321",
      "regNo": "17BME0532"
    },
    {
      "registered": false,
      "_id": "5bb06c668884a4659421cda7",
      "name": "Shovan Singh",
      "email": "bahdhj@gmail.com",
      "phone": "798456123",
      "gravitasID": "G18I4123",
      "regNo": "17BCE0123"
    },
    {
      "registered": false,
      "_id": "5bb06c978884a4659421cda8",
      "name": "Manan Rajvir",
      "email": "jaksdhjdh@gmail.com",
      "phone": "456789123",
      "gravitasID": "G18I4132",
      "regNo": "17BCE0987"
    }
  ];*/
  var regs;
  var resp;
  List<dynamic> reglist;

  List filter(String filtertext) {
    return reglist.where((f) => f.toUpperCase().contains(filtertext.toUpperCase())).toList();
  }

  final TextEditingController _typeAheadController1 = TextEditingController();
  final TextEditingController _typeAheadController2 = TextEditingController();

  void submitTeam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      var p1Data = p1.split(" - ");
      var p2Data = p2.split(" - ");

      var url = 'http://104.196.117.29/team/registerTeam';
      var body = {'name1': p1Data[1], 'gravitasID1': p1Data[0], 'name2': p2Data[1], 'gravitasID2': p2Data[0]};
      print(body);
      await http.post(url, body: body)
          .then((res) {
            print("Post Successfull"+res.body);
            resp=res.body;

      });
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Round1Page(teamID: resp)
          ));

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



  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var teamID = prefs.getInt('teamID') ?? null;
    print('Team ID: $teamID');

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
        else if (value == _typeAheadController2.text)
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
        else if (value == _typeAheadController1.text)
          return 'Both participants cannot be the same';
      },
      onSaved: (value) => p2 = value,
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
      body: //visibilityForm?
      new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage('assets/images/LandingPage.jpg'),
                  fit: BoxFit.cover,
                )
            ),
          ),
          new Column(
            children: <Widget>[
              new Container(height: 20.0,),
              new Text("REGISTER",textScaleFactor: 3.0, style: new TextStyle(
                color: Colors.white,
              ),),
              new Container(height: 30.0,),
              new Center(
                child: new Container(
                  height: 400.0,
                  width: 270.0,

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
                              tatxtParticipant1,
                              SizedBox(height: 18.0),
                              tatxtParticipant2,
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
      )
    );
  }
}