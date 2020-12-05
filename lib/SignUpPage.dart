import 'package:flutter/material.dart';
import 'package:jour/LoginPage.dart';
import 'package:jour/auth.dart';
import 'loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: signUpPage(),
    );
  }
}

class signUpPage extends StatefulWidget {
  final Function toggleView;
  signUpPage({this.toggleView});

  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final Authservice _auth = Authservice();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome!",
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  "Sign Up to continue...",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Email",
                  style: TextStyle(fontSize: 23, color: Colors.black),
                ),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'enter an email' : null,
                  decoration: InputDecoration(hintText: "JohnDoe@gmail.com"),
                  style: TextStyle(fontSize: 20),
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Password",
                  style: TextStyle(fontSize: 23, color: Colors.black),
                ),
                TextFormField(
                  obscureText: true,
                  validator: (val) => val.length < 6
                      ? 'enter a password with more than 6 chars'
                      : null,
                  decoration: InputDecoration(hintText: "Enter your password"),
                  style: TextStyle(fontSize: 20),
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          email, password);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage(),
                        ),
                        (Route route) => false,
                      );
                      if (result == null) {
                        setState(() {
                          error = 'Please supply a valid email';
                          loading = false;
                        });
                      }
                    }
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    );
                  },
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 88.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text('SIGNUP'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    InkWell(
                      onTap: openLoginPage,
                      child: Text(" LOG IN",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  void openLoginPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
