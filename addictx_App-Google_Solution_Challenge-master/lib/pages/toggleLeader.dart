import 'package:addictx/SplashScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class ToggleLeader extends StatefulWidget {
  final String challengeName;
  final bool isWatch;
  final String docId;
  const ToggleLeader({this.challengeName,this.isWatch,this.docId});
  @override
  _ToggleLeaderState createState() => _ToggleLeaderState();
}

class _ToggleLeaderState extends State<ToggleLeader> {
  int index = 0;
  bool loading=true;
  QuerySnapshot localSnapshot;
  QuerySnapshot globalSnapshot;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData()async{
    if(widget.isWatch){
      localSnapshot=await addictXWatchReference.where('challengeName',isEqualTo: widget.challengeName).orderBy('likeCount',descending: true).limit(10).get();
      globalSnapshot=await globalAddictXWatchReference.where('challengeName',isEqualTo: widget.challengeName).orderBy('likeCount',descending: true).limit(10).get();
    }
    else{
      localSnapshot=await leaderBoardReference.doc(widget.docId).collection('scores').orderBy('score',descending: true).limit(10).get();
      globalSnapshot=await globalLeaderBoardReference.doc(widget.docId).collection('scores').orderBy('score',descending: true).limit(10).get();
    }
    setState(() {
      loading=false;
    });
  }

  Widget position(int index){
    switch (index) {
      case 0:
        return Image.asset('assets/rank1.png');
        break;
      case 1:
        return Image.asset('assets/rank2.png');
        break;
      case 2:
        return Image.asset('assets/rank3.png');
        break;
      default:
        return Text(
          index.toString(),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
          ),
        );
    }
  }

  Widget tile(AsyncSnapshot<DocumentSnapshot> snapshot, int index){
    QuerySnapshot querySnapshot;
    if(globalSnapshot.docs.isEmpty)
      querySnapshot=localSnapshot;
    else
      querySnapshot=globalSnapshot;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xfff0f0f0),
      ),
      padding: EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10,),
            Container(child: position(index),width: 40,alignment: Alignment.center,),
            SizedBox(width: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.data.data()['username'],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Score:- '+(widget.isWatch?querySnapshot.docs[index].data()['likeCount']:querySnapshot.docs[index].data()['score']).toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff737373),
                  ),
                ),
              ],
            ),
            Spacer(),
            VerticalDivider(
              width: 20,
              thickness: 0.3,
              color: const Color(0xff737373),
            ),
            snapshot.data.data()['url']!=''?CircleAvatar(
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(snapshot.data.data()['url']),
            ):CircleAvatar(
              radius:30,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person,color: Colors.black26),
            ),
          ],
        ),
      ),
    );
  }

  Widget global(){
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: globalSnapshot.docs.isEmpty?localSnapshot.docs.length:globalSnapshot.docs.length,
      separatorBuilder: (context,index)=>SizedBox(height: 5,),
      itemBuilder: (context,index){
        return FutureBuilder(
          future: usersReference.doc(globalSnapshot.docs.isEmpty?localSnapshot.docs[index].data()[widget.isWatch?'ownerId':'id']:globalSnapshot.docs[index].data()[widget.isWatch?'ownerId':'id']).get(),
          builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
            if(!snapshot.hasData)
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color(0xfff0f0f0),
                ),
                child: Center(child: CircularProgressIndicator(),),
              );
            return tile(snapshot,index);
          },
        );
      },
    );
  }
  Widget local(){
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: localSnapshot.docs.length,
      separatorBuilder: (context,index)=>SizedBox(height: 5,),
      itemBuilder: (context,index){
        return FutureBuilder(
          future: usersReference.doc(localSnapshot.docs[index].data()[widget.isWatch?'ownerId':'id']).get(),
          builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
            if(!snapshot.hasData)
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color(0xfff0f0f0),
                ),
                child: Center(child: CircularProgressIndicator(),),
              );
            return tile(snapshot,index);
          },
        );
      },
    );
  }

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
      body: loading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: FlutterToggleTab(
                width: 50,
                borderRadius: 15,
                initialIndex: index,
                selectedTextStyle: TextStyle(
                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                unSelectedTextStyle: TextStyle(
                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                labels: ["Local", "Global"],
                selectedBackgroundColors: [Colors.white],
                unSelectedBackgroundColors: [Colors.blue[200]],
                selectedLabelIndex: (selected) {
                  setState(() {
                    index = selected;
                  });
                },
              ),
            ),
            SizedBox(height: 10,),
            index==0?local():global(),
          ],
        ),
      ),
    );
  }
}