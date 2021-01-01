import 'package:cloud_firestore/cloud_firestore.dart';
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

  addChatMessages(String roomId, Map messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(roomId)
        .collection("chats")
        .add(messageMap).catchError((e) {
          print(e.toString());
    });
  }
  getChatMessages(String roomId) async {
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .doc(roomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }


  }