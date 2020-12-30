import 'package:flutter/material.dart';
import 'package:titan_chat/screens/login.dart';
import 'package:titan_chat/screens/search.dart';
import 'package:titan_chat/services/auth.dart';
import 'package:titan_chat/services/authenticate.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthMethods _authMethods = new AuthMethods();
  
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
