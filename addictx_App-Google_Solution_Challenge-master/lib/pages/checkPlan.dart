import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/combine.dart';
import 'package:addictx/pages/plans.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckPlan extends StatelessWidget {
  final String heading;
  final String fileName;
  CheckPlan({Key key,this.heading,this.fileName}) : super(key: key);

  Map content={
    'English':"Your personalised plan is ready!\nIt's time to feel good",
    'Hindi':'आपकी व्यक्तिगत योजना तैयार है!\nयह अच्छा महसूस करने का समय है।',
    'Spanish':'¡Tu plan personalizado está listo\nEs hora de sentirse bien',
    'German':'Ihr persönlicher Plan ist fertig!\nEs ist Zeit sich gut zu fühlen',
    'French':"Votre plan personnalisé est prêt!\nIl est temps de se sentir bien",
    'Japanese':'あなたのパーソナライズされた計画は準備ができています\n気分が良くなる時間です',
    'Russian':'Ваш индивидуальный план готов!\nПора чувствовать себя хорошо',
    'Chinese':'您的个性化计划已准备就绪\n是时候感觉良好了',
    'Portuguese':'Seu plano personalizado está pronto!\nÉ hora de se sentir bem',
  };
  Map check={
    'English':"CHECK IT OUT",
    'Hindi':'चलो देखते हैं',
    'Spanish':'ÉCHALE UN VISTAZO',
    'German':'HÖR ZU',
    'French':"VÉRIFIEZ-LE",
    'Japanese':'見てみな',
    'Russian':'ПРОВЕРИТЬ',
    'Chinese':'一探究竟',
    'Portuguese':'CONFIRA',
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/5,),
            Image.asset('assets/checkPlan.png'),
            SizedBox(height: MediaQuery.of(context).size.height/10,),
            Text(
              content[lang],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/8,),
            GestureDetector(
              onTap: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Combine(heading: heading,fileName: fileName,))),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  color: const Color(0xffd8eff7),
                ),
                child: Text(
                  check[lang],
                  style: TextStyle(
                    fontSize: 25.0,
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
