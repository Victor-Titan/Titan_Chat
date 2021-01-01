
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  final String sharedPrefIsLoggedIn = "ISLOGGEDIN";
  final String sharedPrefUserNameKey = "user";
  final String sharedPrefUserEmailKey = "email";
  Future<void> saveLogInStatus(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefIsLoggedIn, isUserLoggedIn);
  }

  Future<void> saveChatName(String chatName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("chatName", chatName);
  }

  Future<void> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserNameKey, userName);
  }

  Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserEmailKey, email);
  }

  Future<bool> getLogInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPrefIsLoggedIn);
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPrefUserNameKey);
  }

  Future<String> getChatName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString("chatName");
  }

  Future<String> getEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPrefUserEmailKey);
  }


}