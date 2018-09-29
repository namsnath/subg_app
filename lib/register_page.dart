import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'home-page.dart';
import 'round1_page.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final regs = [
    {'id': 'G18I1234', 'name': 'Namit Nathwani'},
    {'id': 'G18I4321', 'name': 'Yash Gupta'},
    {'id': 'G18I4123', 'name': 'Shovan Singh'},
    {'id': 'G18I4132', 'name': 'Manan Rajvir'},
  ];

  final reglist = [
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
  Widget build(BuildContext context) {

    final tatxtParticipant1 = TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._typeAheadController1,
          decoration: InputDecoration(
            labelText: 'Participant 1',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          )
      ),
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
        if (value.isEmpty) {
          return 'Please select a participant';
        }
      },
      //onSaved: (value) => this._selectedCity = value,
    );


    final tatxtParticipant2 = TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._typeAheadController2,
          decoration: InputDecoration(
            labelText: 'Participant 2',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          )
      ),
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
        if (value.isEmpty) {
          return 'Please select a participant';
        }
      },
      //onSaved: (value) => this._selectedCity = value,
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
            Navigator.of(context).pushReplacementNamed(Round1Page.tag);
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

      body: Center(
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

    );
  }
}