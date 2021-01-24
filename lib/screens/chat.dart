import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:titan_chat/services/database.dart';
import 'package:titan_chat/services/sharedpref_helper.dart';
class Chat extends StatefulWidget {
  final String chatWithUsername, name;
  Chat(this.chatWithUsername, this.name);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String chatRoomId, messageId = "";
  Stream messageStream;
  String myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextEdittingController = TextEditingController();

  loadData() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();

    chatRoomId = getChatRoomId(widget.chatWithUsername, myUserName);
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  sendMessage(bool sendClicked) {
    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          messageTextEdittingController.text = "";
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      });
    }
  }

  Widget messageTile(String message, bool sendByMe, Timestamp time) {
    DateTime dT = time.toDate();
    String now = DateFormat('kk:mm:a').format(dT) + " ${dT.day.toString()}/${dT.month.toString()}/${dT.year.toString().substring(2)}";
    return Row(
      mainAxisAlignment:
      sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Time Stamp"),
                  content: Text(now),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text("Close")
                    )
                  ],
                );
              }
            );
          },
          child: Flexible(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomRight:
                    sendByMe ? Radius.circular(0) : Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft:
                    sendByMe ? Radius.circular(24) : Radius.circular(0),
                  ),
                  color: sendByMe ? Colors.blue : Color(0xfff1f0f0),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  message,
                  style: TextStyle(color: sendByMe ? Colors.white : Colors.black, fontSize: 20),
                )
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            padding: EdgeInsets.only(bottom: 70, top: 16),
            itemCount: snapshot.data.docs.length,
            reverse: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return messageTile(
                ds["message"],
                myUserName == ds["sendBy"],
                ds["ts"]
              );
            })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  loadMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  onInit() async {
    await loadData();
    loadMessages();
  }

  @override
  void initState() {
    onInit();
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
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageTextEdittingController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message",
                              hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                        )),
                    GestureDetector(
                      onTap: () {
                        sendMessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}