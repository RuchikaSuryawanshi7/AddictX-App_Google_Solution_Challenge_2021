import 'dart:async';
import 'package:addictx/pages/addFaceData.dart';
import 'package:addictx/pages/tutorial.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:addictx/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Reference usersStorageReference=FirebaseStorage.instance.ref().child("Users");
final Reference momentsStorageReference=FirebaseStorage.instance.ref().child("Moments");
final Reference postsStorageReference=FirebaseStorage.instance.ref().child("Posts");
final Reference challengeStorageReference=FirebaseStorage.instance.ref().child("challenge");
final Reference messageStorageReference=FirebaseStorage.instance.ref().child("Messages");
final Reference verificationStorageReference=FirebaseStorage.instance.ref().child("Verification");
final usersReference=FirebaseFirestore.instance.collection('users');
final questionnaireReference=FirebaseFirestore.instance.collection('questionnaire');
final momentsReference=FirebaseFirestore.instance.collection('moments');
final expertsReference=FirebaseFirestore.instance.collection('experts');
final postsReference=FirebaseFirestore.instance.collection('posts');
final problemsReference=FirebaseFirestore.instance.collection('problems');
final notificationsReference=FirebaseFirestore.instance.collection('notifications');
final plansReference=FirebaseFirestore.instance.collection('plans');
final planDetailsReference=FirebaseFirestore.instance.collection('planDetails');
final commentsReference=FirebaseFirestore.instance.collection('comments');
final reportReference=FirebaseFirestore.instance.collection("Reports");
final resourcesReference=FirebaseFirestore.instance.collection("resources");
final audioTherapiesReference=FirebaseFirestore.instance.collection("audioTherapies");
final chatRoomReference=FirebaseFirestore.instance.collection("chatRoom");
final toDoTodayReference=FirebaseFirestore.instance.collection("toDoToday");
final contestReference=FirebaseFirestore.instance.collection("contests");
final campaignsReference=FirebaseFirestore.instance.collection("campaigns");
final couponsReference=FirebaseFirestore.instance.collection("coupons");
final myCouponsReference=FirebaseFirestore.instance.collection("myCoupons");
final expertRequestReference=FirebaseFirestore.instance.collection("expertRequest");
final badgesReference=FirebaseFirestore.instance.collection("badges");
final leaderBoardReference=FirebaseFirestore.instance.collection("leaderBoard");
final globalLeaderBoardReference=FirebaseFirestore.instance.collection("globalLeaderBoard");
final clinicDetailsReference=FirebaseFirestore.instance.collection("clinicDetails");
final doYouKnowReference=FirebaseFirestore.instance.collection("doYouKnow");
final spotlightReference=FirebaseFirestore.instance.collection("spotlight");
final promotionReference=FirebaseFirestore.instance.collection("promotions");
final quickSurveyReference=FirebaseFirestore.instance.collection("quickSurvey");
final sessionsReference=FirebaseFirestore.instance.collection("sessions");
final addictXWatchReference=FirebaseFirestore.instance.collection("addictXWatch");
final globalAddictXWatchReference=FirebaseFirestore.instance.collection("globalAddictXWatch");
final addictXWatchChallengeReference=FirebaseFirestore.instance.collection("addictXWatchChallenge");
final dietPlanReference=FirebaseFirestore.instance.collection("dietPlan");
final challengeReference=FirebaseFirestore.instance.collection("challenge");

UserModel currentUser;
List<Map> promotion=[];

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedInWithGmail=false;
  final GoogleSignIn googleSignIn=GoogleSignIn();
  SharedPreferences sharedPreferences;
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  bool loggedInWithEmail=false;
  String email,password;

  @override
  void initState() {
    isSignedIn();
    super.initState();
  }

  isSignedIn()async
  {
    DocumentSnapshot doc=await promotionReference.doc('promotions').get();
    if(doc.exists)
      {
        promotion=List.from(doc.data()['data']);
        precacheImage(CachedNetworkImageProvider(promotion[0]['url']),context);
      }
    sharedPreferences=await SharedPreferences.getInstance();
    String startDate=sharedPreferences.getString('appStartDate')??'';
    if(startDate=='')
      {
        DateTime now=DateTime.now();
        sharedPreferences.setString('appStartDate', DateTime(now.year, now.month, now.day).toString());
      }
    isLoggedInWithGmail=await googleSignIn.isSignedIn();
    if(isLoggedInWithGmail)
    {
      User user=FirebaseAuth.instance.currentUser;
      DocumentSnapshot doc= await usersReference.doc(user.uid).get();
      currentUser=UserModel.fromDocument(doc);
    }
    else
    {

      loggedInWithEmail = sharedPreferences.getBool('loggedIn') ?? false;
      email=sharedPreferences.getString("email")??null;
      password=sharedPreferences.getString("password")??null;
      if(loggedInWithEmail) {
        await signIn();
        await sharedPreferences.setString('email', email);
        await sharedPreferences.setString('password', password);
        await sharedPreferences.setBool('loggedIn', true);
      }
    }
    bool shown=sharedPreferences.getBool('shown')??false;
    if(shown)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFaceData()));
    else
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Tutorial()));
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      return user.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  signIn() async {
    await signInWithEmailAndPassword(
        email, password)
        .then((result) async {
      if (result != null)  {
        DocumentSnapshot documentSnapshot=await usersReference.doc(result).get();
        currentUser=UserModel.fromDocument(documentSnapshot);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/logo.png'),context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(45, 45, 45, 0),
                child: Image.asset("assets/logo.png"),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.copyright,size: 18,color: Colors.black,),
                  Text("Tech Exordium",style: TextStyle(fontSize: 16,color: Colors.black),),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
