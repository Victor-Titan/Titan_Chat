import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:titan_chat/screens/login.dart';
import 'package:titan_chat/services/auth.dart';
import 'package:titan_chat/services/database.dart';
import 'package:titan_chat/services/sharedpred_helper.dart';

import 'chat.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  bool isSearching = false;
  TextEditingController searchEditingController = new TextEditingController();
  Stream userStream;
  String myName, myUserName, myEmail;

  loadMyInfo() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
  }

  @override
  void initState() {
    loadMyInfo();
    super.initState();
  }

  onSearchButtonClicked() async {
    isSearching = true;
    setState(() {});
    userStream = await DatabaseMethods().getUserByUserName(searchEditingController.text);
    setState(() {});
  }

  getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget searchTile({String name, String email, String username}){
    return GestureDetector(
      onTap: (){
        var chatRoomId = getChatRoomId(myUserName, username);
        Map<String, dynamic> chatRoomInfoMap = {
          "users" : [myUserName, username]
        };

        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

        Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(username, name)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          Text(email)
        ],
      ),
    );
  }

  Widget searchUsersList(){
    return StreamBuilder(
        stream: userStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              DocumentSnapshot ds = snapshot.data.docs[index];
              return searchTile(
                  name:ds["name"],
                  email:ds["email"],
                  username: ds["username"]
              );
            },
          ) : Center(child:CircularProgressIndicator());
        }
    );
  }

  Widget chatRoomsList(){
    return Container();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          InkWell(
            onTap: (){
              AuthMethods().signOut().then((s){
                Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
            });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                isSearching ? GestureDetector(
                  onTap: (){
                    isSearching = false;
                    searchEditingController.clear();
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ) : Container(),

                Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                    style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search"
                        ),
                      )),
                    GestureDetector(
                      onTap: (){
                        if(searchEditingController.text.isNotEmpty){
                          onSearchButtonClicked();
                        }
                      },
                        child: Icon(Icons.search)
                    )
                  ],
                )),
              ]
            ),
            isSearching ? searchUsersList() : chatRoomsList()
          ],
        ),
      ),
    );
  }
}