import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
class DatabaseMethods{

  addUserInfoToDB(
      {String userID,
      String email,
      String username,
      String name,
      String profileUrl}) {
    FirebaseFirestore.instance.collection("users").doc(userID).set({
      "email": email,
      "username": username,
      "name": name,
      "imgUrl": profileUrl
    });
  }

  Future<Stream<QuerySnapshot>>getUserByUserName(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }
}