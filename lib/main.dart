
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return Login();
          }
        },
      ),
    );
  }
}