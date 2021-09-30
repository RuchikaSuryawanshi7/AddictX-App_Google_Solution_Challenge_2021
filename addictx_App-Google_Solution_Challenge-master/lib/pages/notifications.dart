import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/widgets/notificationWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool loading=true;
  List<NotificationsItems> notifications=[];
  Map title={
    'English':"Notification",
    'Hindi':'अधिसूचना',
    'Spanish':'Notificación',
    'German':'Benachrichtigung',
    'French':"Notification",
    'Japanese':'お知らせ',
    'Russian':'Уведомление',
    'Chinese':'通知',
    'Portuguese':'Notificação',
  };

  @override
  void initState()
  {
    getData();
    super.initState();
  }

  getData()async
  {
    if(currentUser!=null)
    {
      QuerySnapshot snapshotForNotifications=await notificationsReference.doc(currentUser.id).collection("notificationItems").orderBy("timeStamp",descending: true).limit(20).get();
      snapshotForNotifications.docs.forEach((documentSnapshot) {
        notifications.add(NotificationsItems.fromDocument(documentSnapshot));
      });
    }
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Center(
            child: Text(
              title[lang]+' ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
        title: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: const Color(0xfff0f0f0),
      ),
      body: loading?Center(child: CircularProgressIndicator(),):ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context,index){
          return notifications[index];
        },
      ),
    );
  }
}
