import 'package:flutter/material.dart';
import 'package:titan_chat/model/user.dart';
import 'package:titan_chat/screens/login.dart';
import 'package:titan_chat/screens/search.dart';
import 'package:titan_chat/services/auth.dart';
import 'package:titan_chat/services/authenticate.dart';
import 'package:titan_chat/services/helperfunctions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthMethods _authMethods = new AuthMethods();
  HelperFunctions _helperFunctions = new HelperFunctions();

  @override
  void initState() {

    super.initState();
  }

  getUserInfo() async {
    Usr.name = await _helperFunctions.getUserName();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lists"),
        toolbarHeight: 50,
        actions: [
          GestureDetector(
            onTap: () {
              _authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
          },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Search()
          ));
        },
      ),
    );
  }

}
