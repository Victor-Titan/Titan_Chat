import 'package:flutter/material.dart';
import 'package:titan_chat/screens/login.dart';
import 'package:titan_chat/screens/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return Login(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}
