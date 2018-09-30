import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'round1_page.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final regs = [
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
  ];

  List<String> reglist;

  final reg = [
    'G18I1234 - Namit Nathwani',
    'G18I4321 - Yash Gupta',
    'G18I4123 - Shovan Singh',
    'G18I4132 - Manan Rajvir',
  ];

  List filter(String filtertext) {
    return reglist.where((f) => f.toUpperCase().contains(filtertext.toUpperCase())).toList();
  }

  final TextEditingController _typeAheadController1 = TextEditingController();
  final TextEditingController _typeAheadController2 = TextEditingController();

  @override
  void initState() {
    reglist = regs.map((reg) => (reg['gravitasID'].toString() + " - " + reg['name'].toString()).toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    GlobalKey<ScaffoldState> _registerScaffoldKey = new GlobalKey();
    bool _autoValidate = true;

    String p1, p2;

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
          onPressed: () {
            if (_formKey.currentState.validate()) {
              // No any error in validation
              _formKey.currentState.save();
              print("Participant 1: $p1");
              print("Participant 2: $p2");
              Navigator.of(context).pushReplacementNamed(Round1Page.tag);
            } else {
              print("Validation error part");
              /*_registerScaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text("Enter Data"),
              ));*/
            }


          },
          color: Theme.of(context).accentColor,
          child: Text('Log In'),

        ),
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      key: _registerScaffoldKey,
      body: Center(
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
          )
      )
    );
  }
}