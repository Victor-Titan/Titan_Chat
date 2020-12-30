import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class DatabaseMethods{

  getByUsername(String username) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("name", isEqualTo: username).get();
  }

  getByUserEmail(String email) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("email", isEqualTo: email).get();
  }

  uploadUserInfo(Map<String,String> userMap){
    FirebaseFirestore.instance.collection("users")
    .add(userMap);
  }

  createChatRoom(String roomId, Map chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(roomId)
        .set(chatRoomMap)
        .catchError((e) {
          print(e.toString());
    });
  }
}