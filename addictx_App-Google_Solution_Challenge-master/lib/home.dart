import 'dart:io';
import 'package:addictx/helpers/badges.dart';
import 'package:addictx/pages/expertProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/pages/Addictions.dart';
import 'package:addictx/pages/chatBot.dart';
import 'package:addictx/pages/feed.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:addictx/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex=0;
  PageController pageController=PageController();
  FirebaseMessaging _firebaseMessaging=FirebaseMessaging();

  @override
  void initState() {
    if(currentUser!=null)
      {
        checkForBadges();
        updateNotificationToken();
      }
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  checkForBadges()async{
    List<String> badges=[];
    SharedPreferences prefs=await SharedPreferences.getInstance();
    DocumentSnapshot doc=await badgesReference.doc(currentUser.id).get();
    if(doc.exists)
    {
      badges=List.from(doc.data()['badges']);
    }
    checkForAddiction(badges, context);
    checkForHabitBuilding(badges, context, prefs);
    checkForRelaxationActivities(badges, context, prefs);
  }

  updateNotificationToken()async
  {
    final prefs = await SharedPreferences.getInstance();
    final String firebaseTokenPrefKey = 'firebaseToken';
    final String currentToken = prefs.getString(firebaseTokenPrefKey)??"";
    if(Platform.isIOS)
    {
      getIOSPermissions();
    }
    _firebaseMessaging.getToken().then((token) async{
      if(currentToken!=token||currentToken=="")
      {
        usersReference.doc(currentUser.id).update({
          "androidNotificationToken":token,
        });
        await prefs.setString(firebaseTokenPrefKey, token);
      }
    });
  }

  getIOSPermissions()
  {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(alert: true,badge: true,sound: true,));
    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      print("Settings Registered:  $settings");
    });
  }

  onTapChangePage(int pageIndex) async
  {
    if(pageIndex==2)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DexiChatBot()));
        setState(() {
          currentIndex=0;
        });
        pageController.animateToPage(0, duration: Duration(milliseconds: 400), curve: Curves.linear);
      }
    else
      {
        setState(() {
          currentIndex=pageIndex;
        });
        pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 400), curve: Curves.linear);
      }
  }

  whenPageChanges(int pageIndex)
  {
    currentIndex=pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageView(
        children: [
          HomeScreen(),
          Addictions(),
          DexiChatBot(),
          Feed(),
          currentUser!=null&&currentUser.isExpert?ExpertProfile(userModel: currentUser,isFromBottomNavigation: true,):Profile(),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedColor: Color(0xff9ad0e5),
        unSelectedColor: Colors.black,
        currentIndex: currentIndex,
        backgroundColor: const Color(0xfff0f0f0),
        strokeColor: Color(0xff9ad0e5),
        onTap: onTapChangePage,
        items: [
          CustomNavigationBarItem(icon: Icon(Icons.home),),
          CustomNavigationBarItem(icon: Icon(FontAwesomeIcons.wineBottle),),
          CustomNavigationBarItem(icon: Icon(FontAwesomeIcons.robot),),
          CustomNavigationBarItem(icon: Icon(FontAwesomeIcons.xing),),
          CustomNavigationBarItem(icon: Icon(Icons.dashboard),),
        ],
      ),
    );
  }
}