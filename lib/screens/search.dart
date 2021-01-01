import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titan_chat/model/user.dart';
import 'package:titan_chat/services/database.dart';
import 'package:titan_chat/services/helperfunctions.dart';
import 'package:titan_chat/widgets/widget.dart';

import 'chat.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DatabaseMethods _databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapShot;
  HelperFunctions _helperFunctions = new HelperFunctions();

  initSearch(){
    _databaseMethods
        .getByUsername(searchTextEditingController.text.toString())
        .then((val) {
          setState(() {
            searchSnapShot = val;
          });
        });
  }

  openChat(String username){
    if(username != Usr.name) {
      String roomId = getChatRoomId(username, Usr.name);
      _helperFunctions.saveChatName(username);
      List<String> users = [username, Usr.name];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": roomId
      };
      _databaseMethods.createChatRoom(roomId, chatRoomMap);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Chat(username, roomId)
      ));
    } else {
      Scaffold.of(context)
          .showSnackBar(
          new SnackBar(
              content: new Text("You can't send message to yourself")
          )
      );
    }
  }

  Widget SearchTile({String username, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            children: [
              Text(username, style: mediumTextStyle()),
              Text(userEmail, style: mediumTextStyle())
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () => {
            openChat(username)
          },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text("Message", style: mediumTextStyle())
            ),
          )
        ],
      ),
    );
  }

  Widget searchList(){
    return searchSnapShot != null ? ListView.builder(
        itemCount: searchSnapShot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
            username: searchSnapShot.docs[index]["name"],
            userEmail: searchSnapShot.docs[index]["email"],
          );
        }) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "Search"),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          hintText: "Search Username",
                          hintStyle: TextStyle(
                            color: Colors.white54
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      initSearch();
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
                        child: Icon(Icons.search)
                    ),

                  ),

                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}