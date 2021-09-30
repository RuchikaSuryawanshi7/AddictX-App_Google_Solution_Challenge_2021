import 'package:addictx/SplashScreen.dart';
import 'package:addictx/pages/checkPlan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreparingPlan extends StatefulWidget {
  final String fileName;
  final String heading;
  final String lang;
  const PreparingPlan({Key key,this.heading,this.fileName,this.lang}) : super(key: key);

  @override
  _PreparingPlanState createState() => _PreparingPlanState();
}

class _PreparingPlanState extends State<PreparingPlan> with TickerProviderStateMixin{
  bool dataSaved=false;
  AnimationController svgController;
  AnimationController tickController;
  Animation svgRotation;
  Animation svgOpacity;
  Animation tickRotation;
  Animation tickOpacity;
  Map<String, List> addictions={
    'English':['SOCIAL MEDIA','FAST FOOD','OVEREATING', 'GAMING','PROCRASTINATION','GAMBLING', 'SMOKING','ALCOHOL','DRUGS', 'WEED','WATCHING TV','LYING', 'COFFEE','QUARREL','NOT SLEEPING'],
    'Hindi':['सामाजिक मीडिया','फास्ट फूड','ज्यादा खाना', 'गेमिंग','टालमटोल करना','जुआ', 'धूम्रपान','शराब','ड्रग्स', 'जंगली घास','टीवी देखना','झूठ बोलना', 'कॉफ़ी','लड़ाई झगड़ा','नहीं सोना'],
    'Spanish':['MEDIOS DE COMUNICACIÓN SOCIAL','COMIDA RÁPIDA','COMER EN EXCESO','JUEGO DE AZAR','DILACIÓN','JUEGO', 'DE FUMAR','ALCOHOL','DROGAS', 'HIERBA','VIENDO LA TELEVISIÓN','MINTIENDO', 'CAFÉ','PELEA','NO DURMIENDO'],
    'German':['SOZIALEN MEDIEN','FASTFOOD','ÜBERESSEN', 'SPIELE','AUFSCHUB','SPIELEN', 'RAUCHEN','ALKOHOL','DROGEN', 'GRAS','FERNSEHEN','LÜGEN', 'KAFFEE','STREIT','NICHT SCHLAFEND'],
    'French':['DES MÉDIAS SOCIAUX','MAL BOUFFE','TROP MANGER', 'JEU','PROCRASTINATION',"JEUX D'ARGENT", 'FUMEUSE',"DE L'ALCOOL",'DROGUES', 'CANNABIS','REGARDER LA TÉLÉVISION','MENSONGE', 'CAFÉ','QUERELLE','NE PAS DORMIR'],
    'Japanese':['ソーシャルメディア','ファストフード','過食', 'ゲーム','怠慢','ギャンブル', '喫煙','アルコール','薬物', '雑草','テレビを見ている','嘘をつく', 'コーヒー','喧嘩','寝ていません'],
    'Russian':['СОЦИАЛЬНЫЕ МЕДИА','БЫСТРОЕ ПИТАНИЕ','ПЕРЕЕДАНИЕ', 'ИГРОВЫЕ','ПРОКРАСТИНАЦИЯ','ИГРАТЬ В АЗАРТНЫЕ ИГРЫ', 'КУРЕНИЕ','АЛКОГОЛЬ','НАРКОТИКИ', 'СОРНЯК','СМОТРЯ ТЕЛЕВИЗОР','ВРУЩИЙ', 'КОФЕ','ССОРИТЬСЯ','НЕ СПИТ'],
    'Chinese':['社交媒体','快餐','暴饮暴食', '赌博','拖延','赌博', '抽烟','酒精','药物', '杂草','看电视','凌', '咖啡','吵架','不睡觉'],
    'Portuguese':['MÍDIA SOCIAL','COMIDA RÁPIDA','COMER DEMAIS', 'JOGOS','PROCRASTINAÇÃO','JOGATINA', 'FUMAR','ÁLCOOL','DROGAS', 'ERVA','ASSISTINDO TV','DEITADA', 'CAFÉ','BRIGA','NÃO DORME'],
  };
  Map statement={
    'English':"Personalising your self-care plan",
    'Hindi':'हम आपकी स्व-देखभाल योजना को वैयक्तिकृत कर रहे हैं',
    'Spanish':'Personalizar su plan de autocuidado',
    'German':'Personalisieren Sie Ihren Self-Care-Plan',
    'French':'Personnaliser votre plan de soins personnels',
    'Japanese':'セルフケアプランをパーソナライズする',
    'Russian':'Индивидуальный план ухода за собой',
    'Chinese':'个性化您的自我保健计划',
    'Portuguese':'Personalizando seu plano de autocuidado',
  };

  @override
  void initState() {
    startPlan();
    svgController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this,);
    svgRotation=Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: svgController, curve: Curves.linear));
    svgOpacity = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: svgController, curve: Curves.linear));

    tickController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this,);
    tickRotation=Tween(begin: -0.5, end: 0.0).animate(
        CurvedAnimation(parent: tickController, curve: Curves.linear));
    tickOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: tickController, curve: Curves.linear));
    svgController.forward();
    tickController.forward().whenComplete((){
      if(dataSaved)
        {
          Future.delayed(Duration(milliseconds: 800),(){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckPlan(heading: widget.heading,fileName: widget.fileName,)));
          });
        }
    });

    super.initState();
  }

  @override
  void dispose() {
    svgController?.dispose();
    tickController?.dispose();
    super.dispose();
  }

  startPlan()async
  {
    bool planExists=false;
    DocumentSnapshot doc=await plansReference.doc(currentUser.id).get();
    if(doc.exists)
    {
      List<Map>plans=List.from(doc.data()['plans']);
      for(var plan in plans) {
        if(plan['planName']==addictions['English'][addictions[widget.lang].indexOf(widget.heading)])
        {
          planExists=true;
          break;
        }
      }
    }
    if(!planExists)
    {
      var now = DateTime.now();
      await plansReference.doc(currentUser.id).set({
        'userId':currentUser.id,
        'plans': FieldValue.arrayUnion([
          {
            'planName':addictions['English'][addictions[widget.lang].indexOf(widget.heading)],
            'startTime':DateTime(now.year, now.month, now.day),
          }
        ]),
      },SetOptions(merge: true));
    }
    dataSaved=true;
    if(tickController.isCompleted)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckPlan(heading: widget.heading,fileName: widget.fileName,)));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xfff0f0f0),
              radius: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: svgRotation,
                    child: FadeTransition(
                      opacity: svgOpacity,
                      child: Image.asset('assets/addiction/${widget.fileName}.png',width: 135,),
                    ),
                  ),
                  RotationTransition(
                    turns: tickRotation,
                    child: FadeTransition(
                      opacity: tickOpacity,
                      child: Icon(Icons.check,color: const Color(0xff97dff9),size: 145 ,)
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Text(
              statement[widget.lang],
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
