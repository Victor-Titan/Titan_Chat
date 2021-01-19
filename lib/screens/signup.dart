
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:titan_chat/services/auth.dart';
import 'package:titan_chat/services/database.dart';
import 'package:titan_chat/services/sharedpred_helper.dart';
import 'package:titan_chat/widgets/widget.dart';

import 'mainscreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  HelperFunctions _helperFunctions = new HelperFunctions();

  signUp(){

    if(formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": usernameTextEditingController.text.toString(),
        "email": emailTextEditingController.text.toString()
      };

      _helperFunctions.saveUserName(usernameTextEditingController.text.toString());
      _helperFunctions.saveEmail(emailTextEditingController.text.toString());

      setState(() {
        isLoading = true;
      });


      authMethods.signUpWithEmailAndPassword(
          emailTextEditingController.text.toString(),
          passwordTextEditingController.text.toString()
      ).then((value) {
        //print("$value");

        _databaseMethods.uploadUserInfo(userInfoMap);

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Home()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "Sign Up"),
        body: isLoading ? Container(
          child: Center(child: CircularProgressIndicator()),
        ) : SingleChildScrollView(
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
                            return val.isEmpty || val.length<3 ? "Enter a username with atleast 3 characters" : null;
                          },
                          controller: usernameTextEditingController,
                          decoration: textFieldInputDecoration("Username"),
                          style: simpleTextStyle(),
                        ),
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
                    onTap: (){
                      signUp();
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
                      child: Text("Sign Up", style: TextStyle(
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
                    child: Text("Sign Up with Google", style: mediumTextStyle()),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?  ", style: mediumTextStyle()),
                      GestureDetector(
                        onTap: (){
                          widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                              "Sign In",
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
        )
    );
  }
}
