import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/models/campaignModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Campaigns extends StatelessWidget {

  launchMeet(String link) async
  {
    if (await canLaunch(link)) {
      await launch(
        link,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String,String>{'header_key':'header_value'},
      );
    } else {
      showToast("Something went wrong!! Please try again later");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "CAMPAIGNS",
          textAlign: TextAlign.center,
          style: GoogleFonts.gugi(
            textStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          Builder(
            builder: (context)=>Container(
                height: AppBar().preferredSize.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(26)),
                  color: Color(0xff9ad0e5),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios,color: Colors.black,),
                  onPressed: ()=>Navigator.pop(context),
                )
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: campaignsReference.orderBy('startTime',descending: false).get(),
          builder: (context,snapshot){
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator(),);
            List<CampaignModel> campaignModels=[];
            snapshot.data.docs.forEach((doc){
              CampaignModel campaignModel=CampaignModel.fromDocument(doc);
              if(campaignModel.endTime.millisecondsSinceEpoch>DateTime.now().millisecondsSinceEpoch)
                campaignModels.add(campaignModel);
              else
                if(currentUser!=null)
                  {
                    campaignsReference.where('endTime',isEqualTo: campaignModel.endTime).get().then((document) {
                      campaignsReference.doc(document.docs.first.id).delete();
                    });
                  }
            });
            return Column(
              children: [
                SizedBox(height: 10.0,),
                Text(
                  "Timings",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.gugi(
                    textStyle: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: campaignModels.length,
                  itemBuilder: (context,index){
                    DateTime current=DateTime.now();
                    DateTime start=DateTime.fromMillisecondsSinceEpoch(campaignModels[index].startTime.seconds*1000);
                    DateTime end=DateTime.fromMillisecondsSinceEpoch(campaignModels[index].endTime.seconds*1000);
                    String date=DateFormat.yMMMd().format(start);
                    String startTime=DateFormat.jm().format(start);
                    String endTime=DateFormat.jm().format(end);
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Color(0xff9ad0e5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54.withAlpha(60),
                                    blurRadius: 8.0,
                                    spreadRadius: -9.0,
                                    offset: Offset(
                                      0.0,
                                      15.0,
                                    ),
                                  ),
                                ]
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          campaignModels[index].title,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.gugi(
                                            textStyle: TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "By:- ${campaignModels[index].by}",
                                          style: GoogleFonts.gugi(
                                            textStyle: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Date:- $date  ",
                                          style: GoogleFonts.gugi(
                                            textStyle: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Time:- $startTime - $endTime",
                                          style: GoogleFonts.gugi(
                                            textStyle: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    CircleAvatar(
                                      radius: 45.0,
                                      backgroundImage: CachedNetworkImageProvider(campaignModels[index].profileImg),
                                    ),
                                  ],
                                ),
                                ListTileTheme(
                                  dense: true,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      tilePadding: EdgeInsets.zero,
                                      title: Container(),
                                      leading: Text(
                                        "Description :-",
                                        style: GoogleFonts.gugi(
                                          textStyle: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      children: [
                                        Text(
                                          campaignModels[index].description,
                                          style: GoogleFonts.gugi(
                                            textStyle: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5,),
                          start.difference(current).inMilliseconds<=86400000?CountdownTimer(
                              endTime: start.millisecondsSinceEpoch,
                              widgetBuilder: (context, CurrentRemainingTime time) {
                                if (time == null) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: ()=>launchMeet(campaignModels[index].meetLink),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Text(
                                        'Join Now',
                                        style: GoogleFonts.gugi(
                                          textStyle: TextStyle(
                                              color: const Color(0xff4b4a4a),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Text(
                                  '${time.hours == null ? '00' : time.hours
                                      .toString()
                                      .length <= 1 ? '0${time.hours}' : time.hours}:${time
                                      .min == null ? '00' : time.min
                                      .toString()
                                      .length <= 1 ? '0${time.min}' : time.min}:${time.sec
                                      .toString()
                                      .length <= 1 ? '0${time.sec}' : time.sec}',
                                  style: GoogleFonts.gugi(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0,
                                      color: const Color(0xff4b4a4a),
                                    ),
                                  ),
                                );
                              }
                          ):Text(
                            'Upcoming Event',
                            style: GoogleFonts.gugi(
                              textStyle: TextStyle(
                                  color: const Color(0xff4b4a4a),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

