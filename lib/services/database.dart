import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseMethods{

  getByUsername(String username) async {
    return await Firestore.instance.collection("users")
        .where("name", isEqualTo: username).getDocuments();
  }

  getByUserEmail(String email) async {
    return await Firestore.instance.collection("users")
        .where("email", isEqualTo: email).getDocuments();
  }

  uploadUserInfo(Map<String,String> userMap){
    Firestore.instance.collection("users")
    .add(userMap);
  }

  createChatRoom(String roomId, Map chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(roomId)
        .setData(chatRoomMap)
        .catchError((e) {
          print(e.toString());
    });
  }

  addChatMessages(String roomId, Map messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(roomId)
        .collection("chats")
        .add(messageMap).catchError((e) {
          print(e.toString());
    });
  }
  getChatMessages(String roomId) async {
    return await Firestore.instance.collection("ChatRoom")
        .document(roomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String username) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}