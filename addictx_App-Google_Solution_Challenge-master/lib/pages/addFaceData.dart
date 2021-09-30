import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/moodDetector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFaceData extends StatelessWidget {

  Map title={
    'English':'Get an idea of your mood.',
    'Hindi':'अपने मूड का अंदाजा लगाएं।',
    'Spanish':'Hazte una idea de tu estado de ánimo.',
    'German':'Machen Sie sich ein Bild von Ihrer Stimmung.',
    'French':"Faites-vous une idée de votre humeur.",
    'Japanese':'あなたの気分のアイデアを入手してください。',
    'Russian':'Получите представление о своем настроении.',
    'Chinese':'了解您的心情。',
    'Portuguese':'Tenha uma ideia do seu humor.',
  };
  Map smile={
    'English':'Stretch your lips\nSo we perceive\nYour emotional state.',
    'Hindi':'अपने होठों को तानें\nतो हमें पता चलता है\nआपकी भावनात्मक स्थिति।',
    'Spanish':'Estire los labios\nPara que podamos percibir\nTu estado emocional.',
    'German':'Strecken Sie Ihre Lippen\nSo nehmen wir\nIhren emotionalen Zustand wahr.',
    'French':"Étirez vos lèvres\nNous percevons donc\nVotre état émotionnel.",
    'Japanese':'唇を伸ばす\nだから私たちは\nあなたの感情的な状態を認識します。',
    'Russian':'Растяните губы\nЧтобы мы почувствовали\nВаше эмоциональное состояние.',
    'Chinese':'伸展你的嘴唇\n所以我们可以感知\n你的情绪状态。',
    'Portuguese':'Estique os lábios\nPara percebermos\nSeu estado emocional.',
  };
  Map next={
    'English':"Next",
    'Hindi':'अगला',
    'Spanish':'Próxima',
    'German':'Nächster',
    'French':"Suivante",
    'Japanese':'次',
    'Russian':'Следующий',
    'Chinese':'下一个',
    'Portuguese':'Próxima',
  };
  Map mood={
    'English':'Mood is like season\nIt is dynamic cold it is at times,\nWarm sometimes constant is what\nIs the will to rectify it.',
    'Hindi':'मूड मौसम की तरह होता है\nयह कभी-कभी गतिशील ठंड होती है,\nगर्मी कभी-कभी स्थिर होती है\nइसे ठीक करने की इच्छा है।',
    'Spanish':'El estado de ánimo es como la estación\nEs dinámico el frío a veces,\nCálido a veces constante es lo que\nEs la voluntad de rectificarlo.',
    'German':'Die Stimmung ist wie die Jahreszeit\nEs ist dynamisch kalt, es ist manchmal,\nWarm manchmal konstant ist das, was\nDer Wille ist, es zu korrigieren.',
    'French':"L'humeur est comme la saison\nIl fait parfois froid dynamique,\nChaleur parfois constante\nEst la volonté de la rectifier.",
    'Japanese':'気分は季節のようです\nそれは時々ダイナミックな寒さです、\n時々一定の暖かいことは\nそれを修正する意志です。',
    'Russian':'Настроение похоже на сезон\nИногда бывает холодно,\nТепло иногда постоянно,\nВоля к его исправлению.',
    'Chinese':'心情就像季节\n时而冷，时而动，\n时而暖，时而恒，\n就是要整顿它的意志。',
    'Portuguese':'O humor é como a estação\nÉ um frio dinâmico às vezes,\nÀs vezes, o calor constante é o que\nÉ a vontade de retificá-lo.',
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
            SizedBox(height: 20,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        title[lang],
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        mood[lang],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Image.asset('assets/dexiFace.jpeg'),
                  Text(
                    smile[lang],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MoodDetector())),
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
                  next[lang],
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
