import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context, String title){
  return AppBar(
    title: Text(title),
    toolbarHeight: 40,
  );
}

InputDecoration textFieldInputDecoration(String hint){
  return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white))
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 16
  );
}

TextStyle mediumTextStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 17
  );
}
