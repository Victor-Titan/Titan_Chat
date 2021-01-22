import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future addMessage(String roomId, String messageId, Map<String,dynamic> data) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(roomId)
        .collection("chats")
        .doc(messageId)
        .set(data);
  }

  updateLastMessageSend(String chatroomId, Map<String,dynamic> data) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomId)
        .update(data);
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if(snapShot.exists){
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

}