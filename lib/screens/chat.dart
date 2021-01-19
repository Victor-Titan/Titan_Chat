import 'package:flutter/material.dart';
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
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          
                        )),
                    Icon(Icons.send_rounded)
                  ],
                )),
            )
          ],
        ),
      ),
    );
  }
}
