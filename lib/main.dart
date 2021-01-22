import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:titan_chat/screens/login.dart';
import 'package:titan_chat/screens/mainscreen.dart';
import 'package:titan_chat/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



class MyApp extends StatefulWidget   {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
   // if(!_initialized)
   //   return Center(child: CircularProgressIndicator());

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            return Home();
          } else {
            return Login();
          }
        },
      ),
    );
  }
}

