import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:titan_chat/model/user.dart';
import 'package:titan_chat/screens/search.dart';
import 'package:titan_chat/services/auth.dart';
import 'package:titan_chat/services/authenticate.dart';
import 'package:titan_chat/services/database.dart';
import 'package:titan_chat/services/helperfunctions.dart';
import 'package:titan_chat/widgets/widget.dart';

import 'chat.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  AuthMethods _authMethods = new AuthMethods();
  HelperFunctions _helperFunctions = new HelperFunctions();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  Stream chatListsStream;

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  Widget chatList(){
    return StreamBuilder(
      stream: Firestore.instance
      .collection("ChatRoom")
      .where("users", arrayContains: Usr.name)
      .snapshots(),
      builder: (context, snapshot){

      },
    );
  }

  Widget chatLists(){
    return StreamBuilder(
     stream: chatListsStream,
      builder: (context, snapshot){
        return snapshot.hasData ?
        ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ChatRoomTile(
                  snapshot.data.documents[index].data["chatroomId"]
                      .toString().replaceAll("_", "")
                      .replaceAll(Usr.name, ""),
                  snapshot.data.documents[index].data["chatroomId"]
              );
            }) : Center(child: CircularProgressIndicator());
      },
    );
  }

  getUserInfo() async {
    Usr.name = await _helperFunctions.getUserName();
    _databaseMethods.getChatRooms(Usr.name).then((snapshots){
      setState(() {
        chatListsStream = snapshots;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lists"),
        toolbarHeight: 50,
        actions: [
          GestureDetector(
            onTap: () {
              _authMethods.signOut();
              _helperFunctions.saveLogInStatus(false);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
          },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)
            ),
          )
        ],
      ),
      body: chatLists(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Search()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String roomId;
  ChatRoomTile(this.username, this.roomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(username,roomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${username.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 8,),
            Text(username, style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}
