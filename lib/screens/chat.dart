import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:titan_chat/model/user.dart';
import 'package:titan_chat/services/database.dart';
import 'package:titan_chat/services/helperfunctions.dart';
import 'package:titan_chat/widgets/widget.dart';

class Chat extends StatefulWidget {

  final String chatName,roomId;
  Chat(this.chatName, this.roomId);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {


  Stream chatMessageStream;
  HelperFunctions _helperFunctions = new HelperFunctions();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();


  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(snapshot.data.docs[index]["message"],
                  snapshot.data.docs[index]["sendBy"] == Usr.name);
            }) : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    _databaseMethods.getChatMessages(widget.roomId)
    .then((value) {
      setState(() {
        value = chatMessageStream;
      });
    });
    super.initState();
  }


  sendMessage() {
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message" : messageController.text.toString(),
        "sendBy" : Usr.name,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      _databaseMethods.addChatMessages(widget.roomId, messageMap);
      messageController.text = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, widget.chatName),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          decoration: InputDecoration(
                              hintText: "Type a message",
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png")
                      ),

                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ] : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
            ],
          ),
          borderRadius: isSendByMe ?
              BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )
        ),
        child: Text(message, style: TextStyle(
            color: Colors.white,
            fontSize: 17
        )),
      ),
    );
  }
}

