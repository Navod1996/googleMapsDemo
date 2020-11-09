import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riderApp/Screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riderApp/Screens/mainScreen.dart';
import 'package:riderApp/main.dart';
import 'package:riderApp/widgets/progressDialog.dart';

class RegistartionScreen extends StatelessWidget {
  static const String idScreen = 'register';

  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController phoneNoEditingController =
      TextEditingController();
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
              height: 300,
              width: 350,
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
                    controller: nameEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: 'Enter a name here',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
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
                    keyboardType: TextInputType.number,
                    controller: phoneNoEditingController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: 'Enter a phone no here',
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
                      if (nameEditingController.text.length < 3) {
                        displayToastMessage(
                            'name must be at least 3 characters', context);
                      } else if (!emailEditingController.text.contains('@')) {
                        displayToastMessage(
                            'Email address is not valid', context);
                      } else if (phoneNoEditingController.text.isEmpty) {
                        displayToastMessage(
                            'phone number is mandatory', context);
                      } else if (passwordEditingController.text.length < 6) {
                        displayToastMessage(
                            'Password must be contain 6 characters', context);
                      } else {
                        registerNewUser(context);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Register',
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
                    LoginScreen.idScreen, (route) => false);
              },
              child: Text('All ready have an account? Log in here.'),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: 'registring plzz wait',
          );
        });
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
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
      Map userDataMap = {
        'name': nameEditingController.text.trim(),
        'email': emailEditingController.text.trim(),
        'phone': phoneNoEditingController.text.trim(),
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage('Congratzz your account has created', context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      //error occur - display error massage
      displayToastMessage('new user acount is not cretaed', context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
