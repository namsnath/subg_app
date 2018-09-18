import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    final txtfrm_participant1 = TextFormField(
      decoration: InputDecoration(
        //hintText: 'Participant 1 ID',
        labelText: 'Participant 1 ID',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final txtfrm_participant2 = TextFormField(
      decoration: InputDecoration(
        //hintText: 'Participant 2 ID',
        labelText: 'Participant 2 ID',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final btn_submit = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        //borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightGreenAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            //Navigator.of(context).pushNamed(HomePage.tag);
          },
          color: Colors.lightGreenAccent,
          child: Text('Log In', style: TextStyle(color: Colors.black)),
        ),
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('SUBG Shall be the death of us all'),
      ),

      body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 50.0, right: 50.0),
            children: <Widget>[
              txtfrm_participant1,
              SizedBox(height: 18.0),
              txtfrm_participant2,
              SizedBox(height: 48.0),
              btn_submit,
            ],
          )
      ),

    );
  }
}