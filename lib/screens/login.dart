import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:titan_chat/screens/mainscreen.dart';
import 'package:titan_chat/services/auth.dart';
import 'package:titan_chat/services/database.dart';
import 'package:titan_chat/services/helperfunctions.dart';
import 'package:titan_chat/widgets/widget.dart';

class Login extends StatefulWidget {
  final Function toggle;
  Login(this.toggle);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  AuthMethods _authMethods = new AuthMethods();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  HelperFunctions _helperFunctions = new HelperFunctions();
  bool isLoading = false;
  QuerySnapshot snapshot;

  signIn() {
    if (formKey.currentState.validate()) {
      _helperFunctions.saveEmail(emailTextEditingController.text.toString());

      _databaseMethods.getByUserEmail(
          emailTextEditingController.text.toString())
          .then((val) {
        snapshot = val;
        _helperFunctions
            .saveEmail(snapshot.docs[0]["email"]);
        _helperFunctions
            .saveUserName(snapshot.docs[0]["name"]);
      });

      setState(() {
        isLoading = true;
      });

      _authMethods
          .signInWithEmailAndPassword(
          emailTextEditingController.text.toString(),
          passwordTextEditingController.text.toString()
      ).then((value) {
        if (value != null) {
          _helperFunctions.saveLogInStatus(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Home()
          ));
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "Sign In"),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isNotEmpty ? null : "Enter correct email";
                        },
                        controller: emailTextEditingController,
                        decoration: textFieldInputDecoration("Email"),
                        style: simpleTextStyle(),
                      ),
                      TextFormField(
                          obscureText: true,
                          validator: (val){
                            return val.length > 6 ? null : "Please provide password of atleast 6 characters";
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Password")
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Forgot Password", style: simpleTextStyle()),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign In", style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                    )),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign In with Google", style: mediumTextStyle()),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?  ", style: mediumTextStyle()),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                            "Register now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline
                            )
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
