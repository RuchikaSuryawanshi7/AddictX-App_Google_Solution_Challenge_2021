import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/main.dart';
import 'package:addictx/pages/pedometer.dart';
import 'package:addictx/pages/poses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Challenge extends StatefulWidget {
  final String challengeName;
  final String imagePath;
  final String details;
  final String duration;
  final int participants;
  final List rewardsPath;
  final String note;

  Challenge({this.challengeName,this.imagePath,this.details,this.participants,this.duration,this.rewardsPath,this.note});
  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {

  void joinChallenge()async{
    await challengeReference.doc(currentUser.id).collection('participation').doc(widget.challengeName).get().then((doc)async{
      if(!doc.exists)
        {
          await leaderBoardReference.doc(widget.challengeName=="Walking League"?"Walking":"Yoga").update({
            'participants': FieldValue.increment(1),
          });
          await challengeReference.doc(currentUser.id).collection('participation').doc(widget.challengeName).set({
            'join':DateTime.now(),
            'challengeName':widget.challengeName,
          });
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.3,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.challengeName,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                        Text(
                          "Lead yourself to the victory",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: ()=>Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
                      ),
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.more_horiz,color: Colors.white,),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                color: const Color(0xfff0f0f0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      widget.details,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xab000000),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Duration:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                "Participants:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.duration,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                widget.participants.toString(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                color: const Color(0xfff0f0f0),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rewards",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 10,),
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.rewardsPath.length,
                      separatorBuilder: (context,index)=>SizedBox(height: 5,),
                      itemBuilder: (context,index){
                        return Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                              image: AssetImage(widget.rewardsPath[index]),
                              fit: BoxFit.cover,
                            )
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Note:"),
                        SizedBox(width: 3,),
                        Expanded(child: Text(widget.note)),
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  if(currentUser!=null)
                    {
                      joinChallenge();
                      if(widget.challengeName=='Yoga League')
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Poses(
                          cameras: cameras,
                          title: "Yoga",
                          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
                          asanas: [
                            'Trikonasana',
                            'Vrikshasana',
                            'Virbhadrasana',
                          ],
                          color: Colors.red,
                        ),));
                      }
                      else if(widget.challengeName=='Walking League')
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DailyStepsPage()));
                      }
                    }
                  else
                    showToast('Login to participate...');
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  color: const Color(0xff9ad0e5),
                  child: Text(
                    "JOIN CHALLENGE",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
