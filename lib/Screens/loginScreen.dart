import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:riderApp/Screens/mainScreen.dart';
import 'package:riderApp/Screens/registrationScreen.dart';
import 'package:riderApp/main.dart';
import 'package:riderApp/widgets/progressDialog.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = 'login';

  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 350,//must edit using mediaQuary
              width: 200,
              child: Image.asset(
                'images/logo.png',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: emailEditingController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: 'Enter a email here',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: passwordEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: 'Enter a password here',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  RaisedButton(
                    onPressed: () {
                      if (!emailEditingController.text.contains('@')) {
                        displayToastMessage(
                            'Email address is not valid', context);
                      } else if (passwordEditingController.text.length < 6) {
                        displayToastMessage(
                            'Password must be contain', context);
                      } else {
                        loginANdAuthenticateUser(context);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2,
            ),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RegistartionScreen.idScreen, (route) => false);
                },
                child: Text('Do not have an account? Register here.'))
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginANdAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: 'authenticating plzz wait',
          );
        });
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailEditingController.text,
                password: passwordEditingController.text)
            .catchError((e) {
      Navigator.pop(context);
      displayToastMessage('Error : ' + e.toString(), context);
    }))
        .user;

    if (firebaseUser != null) //user created
    {
      //save user into database

      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage('Succesfully loged in', context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage('No record about you plz log in', context);
        }
      });
    } else {
      Navigator.pop(context);
      //error occur - display error massage
      displayToastMessage('error occured cannot log in', context);
    }
  }
}
