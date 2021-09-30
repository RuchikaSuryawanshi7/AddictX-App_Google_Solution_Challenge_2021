import 'dart:io';
import 'package:flutter/material.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

configureRealTimePushNotification(String id)async
{
  FirebaseMessaging _firebaseMessaging=FirebaseMessaging();
  final prefs = await SharedPreferences.getInstance();
  final String firebaseTokenPrefKey = 'firebaseToken';
  if(Platform.isIOS)
  {
    getIOSPermissions(_firebaseMessaging);
  }
  _firebaseMessaging.getToken().then((token) async{
    usersReference.doc(id).update({
      "androidNotificationToken":token,
    });
    await prefs.setString(firebaseTokenPrefKey, token);
  });
  _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> msg) async
      {
        final String recipientId=msg["data"]["recipient"];
        final String body=msg["notification"]["body"];
        if(recipientId==id)
        {
          SnackBar snackBar=SnackBar(
            backgroundColor: Colors.grey,
            content: Text("$body",overflow: TextOverflow.ellipsis,),
          );
          //_scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
  );
}
getIOSPermissions(FirebaseMessaging _firebaseMessaging)
{
  _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(alert: true,badge: true,sound: true,));
  _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
    print("Settings Registered:  $settings");
  });
}