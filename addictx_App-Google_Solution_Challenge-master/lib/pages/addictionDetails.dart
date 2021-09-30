import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/details.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/popUpForAddiction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:addictx/pages/questionnaire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddictionDetails extends StatefulWidget {
  final String fileName;
  final String addictionName;
  AddictionDetails({this.fileName,this.addictionName});
  @override
  _AddictionDetailsState createState() => _AddictionDetailsState();
}

class _AddictionDetailsState extends State<AddictionDetails> {
  String lang='English';
  Map getStarted={
    'English':'GET STARTED',
    'Hindi':'चलो शुरू करते हैं',
    'Spanish':'Empecemos',
    'German':'Lasst uns beginnen',
    'French':'Commençons',
    'Japanese':'はじめましょう',
    'Russian':'Давайте начнем',
    'Chinese':'开始吧',
    'Portuguese':'Vamos começar',
  };
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

  checkIsPlanActive()async
  {
    if(currentUser!=null)
      {
        DocumentSnapshot doc=await plansReference.doc(currentUser.id).get();
        if(doc.exists)
        {
          List plans=List.from(doc.data()['plans']);
          var planData;
          plans.forEach((element) {
            if(element['planName']==addictions['English'][addictions[lang].indexOf(widget.addictionName)])
              {
                planData=element;
              }
          });
          if(planData!=null)
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PopUpForAddiction(heading: widget.addictionName,fileName: widget.fileName,)));
          else
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Questionnaire(name: widget.fileName,heading: widget.addictionName,lang: lang,)));
        }
        else
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Questionnaire(name: widget.fileName,heading: widget.addictionName,lang: lang,)));
      }
    else
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Questionnaire(name: widget.fileName,heading: widget.addictionName,lang: lang,)));
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
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
              widget.addictionName+' ',
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Image.asset('assets/addiction/${widget.fileName}.png',width: width*0.7,height: width*0.6,fit: BoxFit.cover,),
          SizedBox(height: 30,),
          Divider(color: const Color(0xfff0f0f0),thickness: 3,height: 0,),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(10,0,10,10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Text(
                  addictionIntro[lang][widget.fileName],
                  style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: ()=>checkIsPlanActive(),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.all(15),
              color: const Color(0xff9ad0e5),
              child: Text(
                getStarted[lang],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
