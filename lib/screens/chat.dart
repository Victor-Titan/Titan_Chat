import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:titan_chat/services/database.dart';
import 'package:titan_chat/services/sharedpred_helper.dart';

class Chat extends StatefulWidget {
  final String chatWithUserName, name;
  Chat(this.chatWithUserName, this.name);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  String chatRoomId, messageId = "";
  String myName, myUserName, myEmail;
  TextEditingController messageTextEditingController = new TextEditingController();

  loadMyInfo() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    chatRoomId = getChatRoomId(widget.chatWithUserName, widget.name);
  }

  getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  doThisOnLaunch() async {
    await loadMyInfo();
    getMessagesFromFirebase();
  }

  sendMessage(bool sendClicked) {
    if(messageTextEditingController.text.isNotEmpty){
      String message = messageTextEditingController.text;

      var lastMessageTimeStamp = DateTime.now();
      Map<String, dynamic> messageMap = {
        "message" : message,
        "sendBy" : myUserName,
        "ts" : lastMessageTimeStamp,
      };
      if(messageId == ""){
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods().addMessage(chatRoomId, messageId, messageMap)
      .then((value) {

        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage" : message,
          "lastMessageSendTs" : lastMessageTimeStamp,
          "lastMessageSendBy" : myUserName
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if(sendClicked) {
          messageTextEditingController.clear();
          messageId = "";
        }
      });
    }
  }

  getMessagesFromFirebase() async {

  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message",
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6))
                          ),
                          controller: messageTextEditingController,
                        )),
                    GestureDetector(
                        onTap: () {
                          sendMessage(true);
                        },
                        child: Icon(Icons.send_rounded))
                  ],
                )),
            )
          ],
        ),
      ),
    );
  }
}
