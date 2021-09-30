import 'package:addictx/home.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodResult extends StatelessWidget {
  final bool isSmiling;
  MoodResult({this.isSmiling});

  Map getStarted={
    'English':"Get Started",
    'Hindi':'शुरू करे',
    'Spanish':'Empezar',
    'German':'Loslegen',
    'French':"Commencer",
    'Japanese':'はじめに',
    'Russian':'Начать',
    'Chinese':'开始',
    'Portuguese':'Iniciar',
  };
  Map recognized={
    'English':'Mood Recognized',
    'Hindi':'मूड मान्यता प्राप्त',
    'Spanish':'Estado de ánimo reconocido',
    'German':'Stimmung erkannt',
    'French':"Humeur reconnue",
    'Japanese':'認識された気分',
    'Russian':'Распознавание настроения',
    'Chinese':'情绪识别',
    'Portuguese':'Humor reconhecido',
  };
  Map you={
    'English':"You are",
    'Hindi':'खुश हैं',
    'Spanish':'Usted es',
    'German':'Du bist',
    'French':"Tu es",
    'Japanese':'あなたは',
    'Russian':'Ты',
    'Chinese':'你很',
    'Portuguese':'Vocês estão',
  };
  Map happy={
    'English':"HAPPY",
    'Hindi':'खुश हैं',
    'Spanish':'FELIZ',
    'German':'GLÜCKLICH',
    'French':" HEUREUX",
    'Japanese':'幸せです',
    'Russian':'СЧАСТЛИВЫЙ',
    'Chinese':'快乐',
    'Portuguese':'FELIZES',
  };
  Map joyless={
    'English':"JOYLESS",
    'Hindi':'उदास हैं',
    'Spanish':'TRISTE',
    'German':'FREUDLOS',
    'French':" TRISTE",
    'Japanese':'ジョイレス',
    'Russian':'Беззаботный',
    'Chinese':'悁',
    'Portuguese':'JOYLESS',
  };
  Map sunflower={
    'English':'You are as cheerful as a sunflower\nshowing in the sun.',
    'Hindi':'आप सूरजमुखी के समान प्रफुल्लित हैं\nधूप में दिखाई दे रहे हैं।',
    'Spanish':'Estás tan alegre como un girasol\nmostrándote al sol.',
    'German':'Sie sind so fröhlich wie eine Sonnenblume,\ndie sich in der Sonne zeigt.',
    'French':"Tu es aussi gai qu'un tournesol\nse montrant au soleil.",
    'Japanese':'あなたはひまわりのように陽気です\n太陽の下で見ています。',
    'Russian':'Вы жизнерадостны, как\nподсолнухи на солнышке.',
    'Chinese':'你就像阳光下的向日葵\n一样开朗。',
    'Portuguese':'Você está tão alegre quanto um girassol\nbrindo ao sol.',
  };
  Map seems={
    'English':'Your mood seems little joyless.',
    'Hindi':'आपका मूड थोड़ा हर्षित लगता है।',
    'Spanish':'Tu estado de ánimo parece un poco triste.',
    'German':'Ihre Stimmung scheint wenig freudlos.',
    'French':"Votre humeur semble peu joyeuse.",
    'Japanese':'あなたの気分は少し喜びがないようです。',
    'Russian':'Ваше настроение кажется немного безрадостным.',
    'Chinese':'你的心情似乎有点不快乐。',
    'Portuguese':'Seu humor parece um pouco triste.',
  };


  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xfff9fdff),
        child: Column(
          children: [
            Spacer(),
            Image.asset('assets/tick.png'),
            SizedBox(height: 30,),
            Text(
              recognized[lang],
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Column(
              children: [
                Text.rich(
                  TextSpan(
                    text: you[lang]+' ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: const Color(0x80000000),
                      fontSize: 35.0,
                    ),
                    children: [
                      TextSpan(
                        text: isSmiling?happy[lang]:joyless[lang],
                        style: TextStyle(color: Colors.black,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  isSmiling?sunflower[lang]:seems[lang],
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            GestureDetector(
              onTap: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home())),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(30,25,30,10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff9ad0e5),
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                height: 50.0,
                child: Text(
                  getStarted[lang],
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
