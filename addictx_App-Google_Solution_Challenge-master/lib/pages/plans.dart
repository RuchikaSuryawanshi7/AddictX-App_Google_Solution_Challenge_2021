import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/dataModel.dart';
import 'package:addictx/pages/planHeading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Plans extends StatefulWidget {
  final String heading;
  final String fileName;
  Plans({this.heading,this.fileName});
  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  DateTime startTime=DateTime.now();
  List<Map> plans=[];
  bool loading=true;
  String lang='English';
  Map title={
    'English':"PLANS",
    'Hindi':'योजना',
    'Spanish':'PLANES',
    'German':'PLÄNE',
    'French':'DES PLANS',
    'Japanese':'予定',
    'Russian':'ПЛАНЫ',
    'Chinese':'计划',
    'Portuguese':'PLANAS'
  };
  Map toast={
    'English':'plan is locked',
    'Hindi':'योजना बंद है',
    'Spanish':'el plan está bloqueado',
    'German':'Plan ist gesperrt',
    'French':'le plan est verrouillé',
    'Japanese':'計画はロックされています',
    'Russian':'план заблокирован',
    'Chinese':'计划被锁定',
    'Portuguese':'plano está bloqueado'
  };
  Map day={
    'English':'D A Y -',
    'Hindi':'दिन -',
    'Spanish':'D í a-',
    'German':'T A G -',
    'French':"J O U R -",
    'Japanese':'日 -',
    'Russian':'День -',
    'Chinese':'日 -',
    'Portuguese':'D I A -',
  };
  Map day2={
    'English':'DAY -',
    'Hindi':'दिन -',
    'Spanish':'Día -',
    'German':'TAG -',
    'French':"JOUR -",
    'Japanese':'日 -',
    'Russian':'День -',
    'Chinese':'日 -',
    'Portuguese':'DIA -',
  };
  Map locked={
    'English':'LOCKED',
    'Hindi':'बंद',
    'Spanish':'BLOQUEADA',
    'German':'GESPERRT',
    'French':"FERMÉ À CLÉ",
    'Japanese':'ロック済み',
    'Russian':'ЗАБЛОКИРОВАНО',
    'Chinese':'锁定',
    'Portuguese':'BLOQUEADO',
  };
  Map getStarted={
    'English':"GET STARTED",
    'Hindi':'शुरू करे',
    'Spanish':'EMPEZAR',
    'German':'LOSLEGEN',
    'French':"COMMENCER",
    'Japanese':'はじめに',
    'Russian':'Начать',
    'Chinese':'开始',
    'Portuguese':'INICIAR',
  };
  Map completed={
    'English':"COMPLETED",
    'Hindi':'पूरा हो हुआ',
    'Spanish':'TERMINADA',
    'German':'ABGESCHLOSSEN',
    'French':"COMPLÉTÉ",
    'Japanese':'完了',
    'Russian':'ЗАВЕРШЕННЫЙ',
    'Chinese':'完全的',
    'Portuguese':'CONCLUÍDA',
  };

  @override
  void initState() {
    getPlanStartTimeAndData();
    super.initState();
  }

  getPlanStartTimeAndData()async
  {
    DocumentSnapshot doc=await plansReference.doc(currentUser.id).get();
    if(doc.exists)
      {
        List<Map> plans=List.from(doc.data()['plans']);
        var planData=plans.firstWhere((element) => element['planName']==widget.heading);
        startTime=DateTime.fromMillisecondsSinceEpoch(planData['startTime'].seconds * 1000);
      }
    DocumentSnapshot document=await planDetailsReference.doc(widget.fileName).get();
    plans=List.from(document.data()['data']);
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Center(
            child: Text(
              title[lang],
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
              ),
            ),
          ),
          SizedBox(width: 7,),
          Image.asset('assets/addiction/${widget.fileName}.png',width: 50,height: 50,),
        ],
        title: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: const Color(0xfff0f0f0),
      ),
      body: loading?Center(child: CircularProgressIndicator(),)
          :SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: plans.length,
              itemBuilder: (context,index){
                DataModel planModel=DataModel.fromMap(plans[index]);
                return GestureDetector(
                  onTap: ()=>DateTime.now().difference(startTime).inDays+1>index?Navigator.push(context, MaterialPageRoute(builder: (context)=>PlanHeading(url: planModel.url,planModel: planModel,screenHeight: MediaQuery.of(context).size.height,))):showToast(toast[lang]),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(DateTime.now().difference(startTime).inDays+1>index?(DateTime.now().difference(startTime).inDays==index?Colors.transparent:Colors.black38.withOpacity(0.25)):Colors.black38.withOpacity(0.25), BlendMode.srcOver),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CachedNetworkImage(
                                placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                                fit: BoxFit.cover,
                                imageUrl: planModel.url,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width*1.6/3,
                              ),
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5,bottom: 5),
                                        alignment: Alignment.center,
                                        color: Color(0xff9ad0e5),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            day[lang]+' ${index+1}',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0x91000000),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.all(7),
                                  color: DateTime.now().difference(startTime).inDays+1>index?Colors.transparent:Colors.black38,
                                  child: Text(
                                    DateTime.now().difference(startTime).inDays+1>index?(DateTime.now().difference(startTime).inDays==index?getStarted[lang]:''):locked[lang],
                                    style: TextStyle(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DateTime.now().difference(startTime).inDays+1>index
                          ? (DateTime.now().difference(startTime).inDays==index
                          ?Container():Center(child: Column(
                        children: [
                          Icon(Icons.lock_open_rounded,size: 50.0,color: Colors.white,),
                          Text(day2[lang]+' ${index+1} '+completed[lang],
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ))):
                      Center(child: Icon(Icons.lock,size: 50.0,color: Colors.white,)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
