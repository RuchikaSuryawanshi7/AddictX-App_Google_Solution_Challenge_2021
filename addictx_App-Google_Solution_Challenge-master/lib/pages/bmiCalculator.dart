import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/bmiResult.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({Key key}) : super(key: key);

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  List<bool> selected=[true,false];
  TextEditingController ageEditingController;
  TextEditingController heightEditingController;
  TextEditingController weightEditingController;
  Map title={
    'English':"BMI Calculator",
    'Hindi':'बीएमआई कैलकुलेटर',
    'Spanish':'Calculadora de IMC',
    'German':'BMI-Rechner',
    'French':"Calculateur d'IMC",
    'Japanese':'BMI計算機',
    'Russian':'Калькулятор ИМТ',
    'Chinese':'体重指数计算器',
    'Portuguese':'Calculadora de IMC',
  };
  Map data={
    'English':"ENTER YOUR DATA",
    'Hindi':'अपनी जानकारी यहाँ दर्ज कीजिये',
    'Spanish':'INTRODUZCA SUS DATOS',
    'German':'GIB DEINE DATEN EIN',
    'French':"ENTRER VOS DONNÉES",
    'Japanese':'あなたのデータを入れてください',
    'Russian':'ВВЕДИТЕ СВОИ ДАННЫЕ',
    'Chinese':'输入你的数据',
    'Portuguese':'INSIRA OS SEUS DADOS',
  };
  Map gender={
    'English':"WHAT'S YOUR GENDER?",
    'Hindi':'आपका लिंग क्या है?',
    'Spanish':'¿CUÁL ES TU GÉNERO',
    'German':'WAS IST DEIN GESCHLECHT?',
    'French':"QUEL EST TON GENRE?",
    'Japanese':'あなたの性別は何ですか',
    'Russian':'КАКОГО ВЫ ПОЛА?',
    'Chinese':'什么是你的性别',
    'Portuguese':'QUAL É O SEU GÊNERO?',
  };
  Map male={
    'English':"MALE",
    'Hindi':'पुरुष',
    'Spanish':'MASCULINO',
    'German':'MÄNNLICH',
    'French':"MÂLE",
    'Japanese':'男性',
    'Russian':'МУЖЧИНА',
    'Chinese':'男性',
    'Portuguese':'MACHO',
  };
  Map female={
    'English':"FEMALE",
    'Hindi':'महिला',
    'Spanish':'MUJER',
    'German':'WEIBLICH',
    'French':"FEMELLE",
    'Japanese':'女性',
    'Russian':'ЖЕНСКИЙ',
    'Chinese':'女性',
    'Portuguese':'FÊMEA',
  };
  Map age={
    'English':"WHAT'S YOUR AGE?",
    'Hindi':'तुम्हारी उम्र क्या है?',
    'Spanish':'¿CUAL ES TU EDAD',
    'German':'WIE ALT BIST DU?',
    'French':"QUEL ÂGE AS TU?",
    'Japanese':'何歳ですか',
    'Russian':'СКОЛЬКО ВАМ ЛЕТ?',
    'Chinese':'你几岁',
    'Portuguese':'QUAL É A SUA IDADE?',
  };
  Map height={
    'English':"WHAT'S YOUR HEIGHT?",
    'Hindi':'आपकी लम्बाई क्या है?',
    'Spanish':'¿CUANTO MIDES',
    'German':'WIE GROSS BIST DU?',
    'French':"QUELLE EST TA TAILLE?",
    'Japanese':'身長はか',
    'Russian':'КАКОГО ТЫ РОСТА?',
    'Chinese':'你的身高是多少',
    'Portuguese':'QUAL SUA ALTURA?',
  };
  Map weight={
    'English':"WHAT'S YOUR WEIGHT?",
    'Hindi':'आपका वजन कितना है?',
    'Spanish':'¿CUAL ES TU PESO',
    'German':'WIE VIEL WIEGEN SIE?',
    'French':"QUEL EST TON POIDS",
    'Japanese':'あなたの体重は何ですか',
    'Russian':'КАКОЙ У ТЕБЯ ВЕС?',
    'Chinese':'你的体重是多少',
    'Portuguese':'QUAL É O SEU PESO?',
  };
  Map get={
    'English':"GET MY BMI",
    'Hindi':'मेरा बीएमआई प्राप्त करें',
    'Spanish':'OBTENER MI IMC',
    'German':'ERHALTE MEINEN BMI',
    'French':"OBTENIR MON IMC",
    'Japanese':'私のBMIを取得',
    'Russian':'ПОЛУЧИТЬ МОЙ ИМТ',
    'Chinese':'获取我的 BMI',
    'Portuguese':'OBTER MEU IMC',
  };

  @override
  void initState() {
    ageEditingController=TextEditingController();
    heightEditingController=TextEditingController();
    weightEditingController=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    ageEditingController?.dispose();
    heightEditingController?.dispose();
    weightEditingController?.dispose();
    super.dispose();
  }

  void calculateBMI(){
    if(heightEditingController!=null&&heightEditingController.text.length>0&&weightEditingController!=null&&weightEditingController.text.length>0)
      {
        double height=double.parse(heightEditingController.text)/100;
        double bmi=double.parse(weightEditingController.text)/(height*height);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BMIResult(bmi: bmi,)));
      }
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: const Color(0xfff0f0f0),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title[lang],
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      data[lang],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0x91000000),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text(
                      gender[lang],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              selected[0]=true;
                              selected[1]=false;
                            });
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: selected[0]?const Color(0xff9ad0e5):const Color(0xfff1f1f1),
                            child: Icon(
                              FontAwesomeIcons.mars,
                              size: 30,
                              color: selected[0]?const Color(0xfff1f1f1):const Color(0xff9ad0e5),
                            ),
                          ),
                        ),
                        Text(
                          "  "+male[lang],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              selected[1]=true;
                              selected[0]=false;
                            });
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: selected[1]?const Color(0xff9ad0e5):const Color(0xfff1f1f1),
                            child: Icon(
                              FontAwesomeIcons.venus,
                              size: 30,
                              color: selected[1]?const Color(0xfff1f1f1):const Color(0xff9ad0e5),
                            ),
                          ),
                        ),
                        Text(
                          "  "+female[lang],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 50,
                      thickness: 3,
                      color: const Color(0xfff1f1f1),
                    ),
                    Text(
                      age[lang],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Transform.translate(
                      offset: Offset(-10,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.translate(
                            offset: Offset(10,0),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                if(ageEditingController.text.isNotEmpty)
                                {
                                  double val=double.parse(ageEditingController.text);
                                  if(val!=0.0)
                                    {
                                      val--;
                                      setState(() {
                                        ageEditingController.text=val.floor().toString();
                                      });
                                    }
                                }
                              },
                              child: Icon(Icons.arrow_back_ios_rounded,color: const Color(0xff9ad0e5),size: 28,),
                            ),
                          ),
                          Container(
                            width: 90,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: ageEditingController,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,fontSize: 40.0),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "00",
                                hintStyle: TextStyle(
                                  color: const Color(0x33000000),
                                  fontSize: 40.0,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                                ),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(-10,0),
                            child: GestureDetector(
                              onTap: (){
                                if(ageEditingController.text.isNotEmpty)
                                {
                                  double val=double.parse(ageEditingController.text);
                                  val++;
                                  setState(() {
                                    ageEditingController.text=val.ceil().toString();
                                  });
                                }
                              },
                              child: Icon(Icons.arrow_forward_ios_rounded,color: const Color(0xff9ad0e5),size: 28,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 3,
                      color: const Color(0xfff1f1f1),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      height[lang],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 90,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: heightEditingController,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black,fontSize: 40.0),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: "00",
                              hintStyle: TextStyle(
                                color: const Color(0x33000000),
                                fontSize: 40.0,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: const Color(0xfff1f1f1),width: 2),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: const Color(0xfff1f1f1),width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: const Color(0xfff1f1f1),width: 2),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "CM",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: const Color(0xff9ad0e5),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 40,
                      thickness: 3,
                      color: const Color(0xfff1f1f1),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      weight[lang],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 90,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: weightEditingController,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black,fontSize: 40.0),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: "00",
                              hintStyle: TextStyle(
                                color: const Color(0x33000000),
                                fontSize: 40.0,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: const Color(0xfff1f1f1),width: 2),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: const Color(0xfff1f1f1),width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: const Color(0xfff1f1f1),width: 2),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "KG",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: const Color(0xff9ad0e5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: ()=>calculateBMI(),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 13),
                  color: const Color(0xff9ad0e5),
                  child: Text(
                    get[lang],
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
