import 'package:addictx/SplashScreen.dart';
import 'package:addictx/pages/toggleLeader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderBoard extends StatefulWidget {

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
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
              'Leaderboard ',
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
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:15.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.trophy, size: 24.0, color: const Color(0xff737373),),
                  SizedBox(width: 10.0,),
                  Text(
                    'Challenges',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: const Color(0xff737373),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: addictXWatchChallengeReference.orderBy('timeStamp',descending: true).get(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData)
                  return Center(child: CircularProgressIndicator(),);
                else if(snapshot.data.docs.isEmpty)
                  return Container();
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  separatorBuilder: (context,index)=>SizedBox(height: 5,),
                  itemBuilder: (context,index){
                    return LeaderBoardTile(
                      url: snapshot.data.docs[index].data()['leaderBoardUrl'],
                      challengeName: snapshot.data.docs[index].data()['challengeName'],
                      participants: snapshot.data.docs[index].data()['participants'],
                      isWatch: true,
                      docId: snapshot.data.docs[index].id,
                    );
                  },
                );
              },
            ),
            SizedBox(height: 5,),
            FutureBuilder(
              future: leaderBoardReference.get(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData)
                  return Center(child: CircularProgressIndicator(),);
                else if(snapshot.data.docs.isEmpty)
                  return Container();
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  separatorBuilder: (context,index)=>SizedBox(height: 5,),
                  itemBuilder: (context,index){
                    return LeaderBoardTile(
                      url: snapshot.data.docs[index].data()['leaderBoardUrl'],
                      challengeName: snapshot.data.docs[index].data()['challengeName'],
                      participants: snapshot.data.docs[index].data()['participants'],
                      isWatch: false,
                      docId: snapshot.data.docs[index].id,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderBoardTile extends StatelessWidget {
  final String url;
  final String challengeName;
  final int participants;
  final bool isWatch;
  final String docId;
  LeaderBoardTile({this.url,this.challengeName,this.participants,this.isWatch,this.docId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ToggleLeader(
        docId: docId,
        challengeName: challengeName,
        isWatch: isWatch,
      ))),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.22,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(url),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  challengeName,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Tap to check leaderboard  |  ",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                    Icon(FontAwesomeIcons.running, color: Colors.white, size: 16,),
                    Text(
                      " ${participants.toString()} Participants",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 20,),
          ),
        ],
      ),
    );
  }
}

