import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddictionTracker extends StatefulWidget {
  @override
  _AddictionTrackerState createState() => _AddictionTrackerState();
}

class _AddictionTrackerState extends State<AddictionTracker> {
  Map addictionTracker={
    'English':'Addiction Tracker',
    'Hindi':'लत ट्रैकर',
    'Spanish':'Rastreador de adicciones',
    'German':'Sucht-Tracker',
    'French':'Suivi des dépendances',
    'Japanese':'アディクショントラッカー',
    'Russian':'Отслеживание зависимости',
    'Chinese':'成瘾追踪器',
    'Portuguese':'Rastreador de Vício',
  };

  Padding MyItems(String image,String heading, int color,int indicolor,var planData){
    return Padding(
      padding: const EdgeInsets.fromLTRB(8,8,8,30),
      child: Material(
        color: Color(color),
        elevation: 8.0,
        shadowColor: Color(0x802196F3),
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          height: MediaQuery.of(context).size.width/1.8,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: planDetailsReference.doc(getFileName(heading)).get(),
            builder: (context,snapshot){
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator(),);
              DateTime startTime=DateTime.fromMillisecondsSinceEpoch(planData['startTime'].seconds * 1000);
              int numerator=DateTime.now().difference(startTime).inDays;
              int denominator=List.from(snapshot.data['data']).length;
              double percentage;
              if(numerator>denominator)
                percentage=1.0;
              else
                percentage=numerator/denominator;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(heading,
                        overflow: TextOverflow.ellipsis,
                        style:GoogleFonts.gugi(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                      Image.asset(image, width: 30,height: 30,),
                    ],
                  ),
                  CircularPercentIndicator(
                    backgroundColor: Colors.grey[300],
                    radius: 110.0,
                    lineWidth: 10.0,
                    percent: percentage,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: new Text("${(percentage*100).toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),),
                    progressColor: Color(indicolor),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            actions: [
              Center(
                child: Text(
                  addictionTracker[lang]+' ',
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
          body: FutureBuilder(
            future: plansReference.doc(currentUser.id).get(),
            builder: (context,snapshot){
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator(),);
              if(!snapshot.data.exists)
                return Container();
              List<Map> plans=List.from(snapshot.data['plans']);
              List<Map> firstHalf=[],secondHalf=[];
              if(plans.isNotEmpty)
                {
                  int mid=plans.length~/2;
                  for(int i=0;i<mid;i++)
                  {
                    firstHalf.add(plans[i]);
                  }
                  for(int i=mid;i<plans.length;i++)
                  {
                    secondHalf.add(plans[i]);
                  }
                }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: List.generate(secondHalf.length, (index) => MyItems('assets/addiction/${getFileName(secondHalf[index]['planName'])}.png',secondHalf[index]['planName'],0xFFFFFFFF,0xff9ad0e5,secondHalf[index]),),
                        ),
                      ),
                      SizedBox(width:10.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top:40.0),
                          child: Column(
                            children: List.generate(firstHalf.length, (index) => MyItems('assets/addiction/${getFileName(firstHalf[index]['planName'])}.png',firstHalf[index]['planName'],0xFFFFFFFF,0xff9ad0e5,firstHalf[index]),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
    );
  }
}