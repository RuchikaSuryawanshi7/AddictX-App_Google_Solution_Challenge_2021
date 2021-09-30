import 'package:addictx/languageNotifier.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BMIResult extends StatelessWidget {
  final double bmi;
  BMIResult({Key key,this.bmi}) : super(key: key);

  String lang='English';
  Map yourBMI={
    'English':"Your BMI",
    'Hindi':'आपका बीएमआई',
    'Spanish':'Tu BMI',
    'German':'Dein BMI',
    'French':"Votre BMI",
    'Japanese':'あなたのBMI',
    'Russian':'Ваш ИМТ',
    'Chinese':'你的体重指数',
    'Portuguese':'Seu IMC',
  };
  Map under={
    'English':"You are under weight !",
    'Hindi':'आपका वजन कम है!',
    'Spanish':'¡Estás bajo de peso',
    'German':'Sie sind untergewichtig!',
    'French':"Vous êtes en sous-poids !",
    'Japanese':'あなたは体重が不足しています!',
    'Russian':'У вас нет веса!',
    'Chinese':'你体重不足！',
    'Portuguese':'Você está abaixo do peso!',
  };
  Map normal={
    'English':"You have normal body weight !",
    'Hindi':'आपका शरीर का वजन सामान्य है!',
    'Spanish':'¡Tienes un peso corporal normal',
    'German':'Sie haben ein normales Körpergewicht!',
    'French':"Vous avez un poids corporel normal !",
    'Japanese':'あなたは正常な体重を持っています！',
    'Russian':'У вас нормальная масса тела!',
    'Chinese':'你的体重正常！',
    'Portuguese':'Você tem peso corporal normal!',
  };
  Map overweight={
    'English':"You are over weight !",
    'Hindi':'आप वजन अधिक हैं!',
    'Spanish':'Tienes sobrepeso !',
    'German':'Du bist übergewichtig !',
    'French':"Vous êtes en surpoids !",
    'Japanese':'あなたは太りすぎです！',
    'Russian':'У вас лишний вес!',
    'Chinese':'你超重了！',
    'Portuguese':'Você está acima do peso !',
  };

  getText(double bmi)
  {
    if(bmi<18.5)
      return under[lang];
    else if(bmi>=18.5&&bmi<25)
      return normal[lang];
    else if(bmi>=25&&bmi<30)
      return overweight[lang];
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              yourBMI[lang],
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10,),
            Icon(FontAwesomeIcons.servicestack,color: const Color(0xff9ad0e5),size: 50.0,),
            SizedBox(height: 10,),
            Text(
              bmi.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              getText(bmi),
              style: TextStyle(
                color: const Color(0xff9ad0e5),
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
