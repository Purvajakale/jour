import 'package:flutter/material.dart';
import 'package:jour/auth.dart';
import 'package:jour/detailscard.dart';
import 'ForgotPassword.dart';
import 'auth.dart';
import 'package:jour/user.dart';
import 'package:provider/provider.dart';
import 'loading.dart';
import 'detailscard.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userData>(context);
    print(user);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: loginPage(),
    );
  }
}

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final Authservice _auth = Authservice();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Welcome Back!",
                      style: TextStyle(fontSize: 35),
                    ),
                    Text(
                      "Sign in to continue...",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Email",
                      style: TextStyle(fontSize: 23, color: Colors.black),
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'enter an email' : null,
                      decoration:
                          InputDecoration(hintText: "JohnDoe@gmail.com"),
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
                      decoration:
                          InputDecoration(hintText: "Enter your password"),
                      style: TextStyle(fontSize: 20),
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: openForgotPassword,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                fontSize: 16, color: Colors.blueAccent),
                          ),
                        )
                      ],
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) => DetailsCard(),
                            ),
                            (Route route) => false,
                          );
                          if (result == null) {
                            setState(() {
                              error = 'Invalid credentials';
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
                        constraints: const BoxConstraints(
                            minWidth: 88.0,
                            minHeight: 50.0), // min sizes for Material buttons
                        alignment: Alignment.center,

                        child: Text('LOGIN'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // InkWell(
                    //   onTap: openDetailscard,
                    //   child: Text(
                    //     "card details",
                    //     style:
                    //         TextStyle(fontSize: 16, color: Colors.blueAccent),
                    //   ),
                    // )
                  ],
                ), //Column
              ),
            ),
          );
  }

  void openForgotPassword() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPassword()));
  }

  void openDetailsCard() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => detailscard()));
  }
}

// dynamic result = await _auth.signInAnon();
// if (result == null) {
// print('error');
// } else {
// print('success');
// print(result.uid);
// }
