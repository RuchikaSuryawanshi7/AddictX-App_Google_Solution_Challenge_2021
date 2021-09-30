import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/combine.dart';
import 'package:addictx/pages/questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopUpForAddiction extends StatelessWidget {
  final String heading;
  final String fileName;
  PopUpForAddiction({this.heading,this.fileName});
  Map statement={
    'English':"You have already checked your addiction level",
    'Hindi':'आप पहले ही अपने व्यसन स्तर की जाँच कर चुके हैं',
    'Spanish':'Ya has comprobado tu nivel de adicción',
    'German':'Sie haben Ihr Suchtniveau bereits überprüft',
    'French':"Vous avez déjà vérifié votre niveau d'addiction",
    'Japanese':'あなたはすでにあなたの中毒レベルをチェックしました',
    'Russian':'Вы уже проверили свой уровень зависимости',
    'Chinese':'您已经检查了您的成瘾程度',
    'Portuguese':'Você já verificou seu nível de vício',
  };
  Map again={
    'English':"Again check Addiction level",
    'Hindi':'फिर से एडिक्शन लेवल चेक करें',
    'Spanish':'Verifique nuevamente el nivel de adicción',
    'German':'Überprüfen Sie erneut den Suchtgrad',
    'French':"Vérifiez à nouveau le niveau de dépendance",
    'Japanese':'中毒レベルをもう一度確認してください',
    'Russian':'Снова проверьте уровень зависимости',
    'Chinese':'再次检查成瘾程度',
    'Portuguese':'Verifique novamente o nível de dependência',
  };
  Map proceed={
    'English':"Proceed with Addiction plans",
    'Hindi':'व्यसन योजनाओं के साथ आगे बढ़ें',
    'Spanish':'Continuar con los planes de adicción',
    'German':'Fahren Sie mit Suchtplänen fort',
    'French':"Continuer avec les plans de toxicomanie",
    'Japanese':'中毒計画を続行します',
    'Russian':'Следуйте планам наркомании',
    'Chinese':'继续执行成瘾计划',
    'Portuguese':'Prossiga com os planos de Dependência',
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Center(
            child: Text(
              heading+' ',
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
      body: Column(
        children: [
          Spacer(),
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: const Color(0xfff0f0f0),
            ),
            child: Image.asset('assets/addiction/$fileName.png',width: MediaQuery.of(context).size.width*4/7,height: MediaQuery.of(context).size.width*4/7,),
          ),
          SizedBox(height: 40,),
          Text(statement[lang],style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
          Spacer(),
          GestureDetector(
            onTap: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Questionnaire(name: fileName,heading: heading,lang: lang,))),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 7),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff9ad0e5),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding: EdgeInsets.all(15),
              child: Text(again[lang],style: TextStyle(fontSize: 18.0),),
            ),
          ),
          GestureDetector(
            onTap: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Combine(heading: heading,fileName: fileName,))),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 7),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff9ad0e5),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding: EdgeInsets.all(15),
              child: Text(proceed[lang],style: TextStyle(fontSize: 18.0),),
            ),
          ),
        ],
      ),
    );
  }
}
