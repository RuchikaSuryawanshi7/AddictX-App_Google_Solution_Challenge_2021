import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/details.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/signIn.dart';
import 'package:addictx/widgets/preparingPlanAnimation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';


class Decision extends StatefulWidget {
  final double percentage;
  final String name;
  final String heading;
  Decision({this.percentage,this.name,this.heading});
  @override
  _DecisionState createState() => _DecisionState();
}

class _DecisionState extends State<Decision> with TickerProviderStateMixin {
  String lang='English';
  Map levelOfAddiction={
    'English':'LEVEL OF ADDICTION',
    'Hindi':'लत का स्तर',
    'Spanish':'NIVEL DE ADICCIÓN',
    'German':'SÜCHTIGKEITSGRAD',
    'French':'NIVEAU DE DÉPENDANCE',
    'Japanese':'中毒のレベル',
    'Russian':'УРОВЕНЬ ЗАВИСИМОСТИ',
    'Chinese':'成瘾程度',
    'Portuguese':'NÍVEL DE VÍCIO'
  };
  Map toastMessage={
    'English':'Login to start the plan..',
    'Hindi':'योजना शुरू करने के लिए लॉगिन करें ..',
    'Spanish':'Inicie sesión para iniciar el plan.',
    'German':'Melden Sie sich an, um den Plan zu starten..',
    'French':'Connectez-vous pour démarrer le plan..',
    'Japanese':'ログインしてプランを開始します。',
    'Russian':'Войдите, чтобы начать план ..',
    'Chinese':'登录开始计划..',
    'Portuguese':'Faça login para iniciar o plano ..'
  };
  Map plan={
    'English':"PREPARE MY PLAN",
    'Hindi':'मेरी योजना तैयार करें',
    'Spanish':'PREPARAR MI PLAN',
    'German':'VORBEREITEN MEINEN PLAN',
    'French':'PRÉPARER MON PLAN',
    'Japanese':'計画を立てる',
    'Russian':'ПОДГОТОВИТЬ МОЙ ПЛАН',
    'Chinese':'准备我的计划',
    'Portuguese':'PREPARE MEU PLANO',
  };
  Map addiction={
    'English':"ADDICTION",
    'Hindi':'की लत',
    'Spanish':'ADICCION',
    'German':'SUCHT',
    'French':'DÉPENDANCE',
    'Japanese':'中毒',
    'Russian':'ЗАВИСИМОСТЬ',
    'Chinese':'瘾',
    'Portuguese':'VÍCIO'
  };
  Map<String, List> level={
    'English':['LOW','MODERATE','HIGH'],
    'Hindi':['कम','उदारवादी','उच्च'],
    'Spanish':['BAJA','MODERAR','ALTA'],
    'German':['NIEDRIG','MÄSSIG','HOCH'],
    'French':['FAIBLE','MODÉRER','HAUTE'],
    'Japanese':['低','中程度','高い'],
    'Russian':['НИЗКИЙ','УМЕРЕННЫЙ','ВЫСОКАЯ'],
    'Chinese':['低的','缓和','高的'],
    'Portuguese':['BAIXA','MODERADA','ALTA'],
  };

  getText()
  {
    if(widget.percentage<0.33)
      return '${level[lang][0]} ${widget.heading} ${addiction[lang]}';
    else if(widget.percentage>=0.33&&widget.percentage<=0.70)
      return '${level[lang][1]} ${widget.heading} ${addiction[lang]}';
    else if(widget.percentage>0.7)
      return '${level[lang][2]} ${widget.heading} ${addiction[lang]}';
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Center(
            child: Text(
              widget.heading+' ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:15.0),
              child: Text(
                levelOfAddiction[lang],
                style: TextStyle(
                  fontSize: 23.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.0,),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 210.0,
                    lineWidth: 30.0,
                    percent: 1.0,
                    progressColor: const Color(0xffeff6f9),
                  ),
                  CircularPercentIndicator(
                    animation: true,
                    radius: 200.0,
                    lineWidth: 20.0,
                    percent: widget.percentage,
                    center: new Text(
                      "${(widget.percentage*100).toStringAsFixed(2)}%",
                      style: GoogleFonts.gugi(
                        textStyle: TextStyle(
                          fontSize: 30.0,
                          color: const Color(0xff919191),
                        ),
                      ),
                    ),
                    progressColor: const Color(0xff9ad0e5),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ),
            Divider(color: const Color(0xfff0f0f0),thickness: 3,height: 60,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          getText(),
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height:20.0 ,),
                      Text(
                        widget.percentage>0.7?decisionDetails[lang]['intermediate']:widget.percentage>0.33&&widget.percentage<=0.7?decisionDetails[lang]['advanced']:decisionDetails[lang]['beginner'],
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60.0,
              child: FlatButton(
                onPressed: () async{
                  if(currentUser!=null)
                    {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PreparingPlan(heading: widget.heading,fileName: widget.name,lang: lang,)));
                    }
                  else
                    {
                      showToast(toastMessage[lang]);
                      bottomSheetForSignIn(context);
                    }
                },
                color: const Color(0xff9ad0e5),
                child: Text(
                  plan[lang],
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}