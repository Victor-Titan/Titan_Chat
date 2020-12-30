import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class DatabaseMethods{

  getByUsername(String username) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("name", isEqualTo: username).get();
  }

  uploadUserInfo(Map<String,String> userMap){
    FirebaseFirestore.instance.collection("users")
    .add(userMap);
  }
}