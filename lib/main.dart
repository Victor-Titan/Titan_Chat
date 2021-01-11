import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:titan_chat/screens/chat.dart';
import 'package:titan_chat/screens/mainscreen.dart';
import 'package:titan_chat/services/authenticate.dart';
import 'package:titan_chat/services/helperfunctions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}



class MyApp extends StatefulWidget   {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userLoggedIn = false;
  bool _initialized = false;
  bool _error = false;

  void initFlutterFire() async {
    try {
      //await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    getLoginState();
    //initFlutterFire();
    super.initState();
  }

  getLoginState() async {
    await HelperFunctions().getLogInStatus().then((value) {
      userLoggedIn = value;
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
   // if(!_initialized)
   //   return Center(child: CircularProgressIndicator());

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userLoggedIn != null ? userLoggedIn ? Home() : Authenticate() : Authenticate(),
    );
  }
}

