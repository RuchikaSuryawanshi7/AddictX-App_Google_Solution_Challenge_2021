import 'package:addictx/SplashScreen.dart';
import 'package:addictx/widgets/challengeTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class ChallengeList extends StatefulWidget {
  const ChallengeList({Key key}) : super(key: key);

  @override
  _ChallengeListState createState() => _ChallengeListState();
}

class _ChallengeListState extends State<ChallengeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Center(
            child: Text(
              'Challenges ',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.calendarAlt, size: 24.0, color: Color(0xff737373),),
                  SizedBox(width: 10.0,),
                  Text(
                    'Upcoming & Ongoing',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xff737373),
                    ),
                  ),
                ],
              ),
            ),
            ChallengeTile(challengeName: 'Yoga League',),
            ChallengeTile(challengeName: 'Walking League',),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.calendarAlt, size: 24.0, color: Color(0xff737373),),
                  SizedBox(width: 10.0,),
                  Text(
                    'Your Challenges',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xff737373),
                    ),
                  ),
                ],
              ),
            ),
            currentUser!=null?StreamBuilder(
              stream: challengeReference.doc(currentUser.id).collection('participation').snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData)
                  return Center(child: CircularProgressIndicator(),);
                else if(snapshot.data.docs.isEmpty)
                  return Container(
                    padding: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    child: Text(
                      "You have not participated\nin any challenge yet..",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                      ),
                    ),
                  );
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  separatorBuilder: (context,index)=>SizedBox(height: 5,),
                  itemBuilder: (context,index){
                    return ChallengeTile(
                      challengeName: snapshot.data.docs[index].data()['challengeName'],
                    );
                  },
                );
              },
            ):Container(
              padding: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Text(
                "Login to see your challenges..",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
