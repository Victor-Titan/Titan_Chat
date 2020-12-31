import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:titan_chat/screens/chat.dart';
import 'package:titan_chat/services/authenticate.dart';
import 'package:titan_chat/services/helperfunctions.dart';

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

  bool userLoggedIn = false;

  @override
  void initState() {
    getLoginState();
    super.initState();
  }

  getLoginState() async {
    await HelperFunctions().getLogInStatus().then((value) {
      setState(() {
        userLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userLoggedIn ? Chat() : Authenticate(),
    );
  }
}

