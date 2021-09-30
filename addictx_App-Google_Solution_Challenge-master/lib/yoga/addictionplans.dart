import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/main.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:addictx/yoga/yogaplans.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class YogaPage extends StatelessWidget {
  YogaPage({Key key}) : super(key: key);

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
  List<List> poses=[
    ['Low Lungs','Lotus pose','Salamba Shrishasana','Cobra Pose','Camel Pose','Vajrasana'],
    ['Tadasana', 'Pigeon Pose', 'Cobra Pose', 'Bow Pose', 'Child Pose', 'Plow Pose', 'Viparita Karani',],
    ['Tree Pose', 'Triangle Pose', 'Chair Pose', 'Uttasana', 'Bridge', 'Viparita Karani', 'Child Pose', 'Cobra Pose', 'Seated Forward Fold', 'Plank', 'Viparita Karani',],
    ['Tadasana', 'Warrior-1', 'Low Lungs', 'Uttasana', 'Cobra Pose', 'Bow Pose', 'Cat Stretch', 'Viparita Shabasana', 'Plank', 'Gomukhasana', 'Vajrasana',],
    ['Tree Pose', 'Low Lungs', 'Camel Pose', 'Cobra Pose', 'Child Pose', 'Viparita Shabasana', 'Plank', 'Viparita Karani',],
    ['Tadasana', 'Triangle Pose', 'Revolved head of knee', 'Pigeon Pose', 'Cobra Pose', 'Bow Pose', 'Viparita Shabasana', 'Gomukhasana',],
    ['Tree Pose', 'Dolphin Pose', 'Child Pose', 'Cobra Pose','Cat Stretch', 'Bow Pose', 'Seated Forward Fold', 'Seated Spinal Twist', 'Fish Pose', 'Viparita Karani',],
    ['Tadasana', 'Gomukhasana', 'Seated Spinal Twist', 'Child Pose', 'Mandukhasana', 'Plank', 'Viparita Karani', 'Salamba Shrishasana',],
    ['Tree Pose', 'Triangle Pose', 'Chair Pose', 'Dolphin pose', 'Downward Facing Dog', 'Child Pose', 'Cobra Pose', 'Plank', 'Viparita Karani',],
    ['Warrior-1', 'Low Lungs', 'Pigeon Pose', 'Seated Forward Fold', 'Knee to Chest', 'Vajrasana', 'Lotus pose',],
    ['Bound Angle Pose', 'Gomukhasana', 'Revolved head of knee', 'Tree Pose', 'Pigeon Pose', 'Low Lungs',],
    ['Tadasana', 'Uttasana', 'Downward Facing Dog', 'Cobra Pose', 'Fish Pose', 'Knee to Chest', 'Viparita Karani', 'Gomukhasana', 'Vajrasana',],
    ['Tree Pose', 'Chakrasana', 'Viparita Karani', 'Plow Pose', 'Cobra Pose', 'Bow Pose', 'Vajrasana',],
    ['Child Pose', 'Salamba Shrishasana', 'Fish Pose', 'Bound Angle Pose',],
    ['Tadasana', 'Triangle Pose', 'Chair Pose', 'Cat Stretch', 'Cobra Pose', 'Child Pose', 'Revolved head of knee', 'Viparita Karani',],
  ];

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff0f0f0),
          elevation: 0.0,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
            onTap: ()=>Navigator.pop(context),
          ),
          actions: [
            Icon(Icons.more_horiz,color: Colors.black,),
            SizedBox(width: 8,),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              currentUser!=null?StreamBuilder(
                stream: plansReference.doc(currentUser.id).snapshots(),
                builder: (context,snapshot)
                {
                  if(!snapshot.hasData)
                    return Center(child: CircularProgressIndicator(),);
                  List<Map> plans=[];
                  if(snapshot.data.exists)
                  {
                    plans=List.from(snapshot.data['plans']);
                  }
                  return plans.isEmpty?Container():Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.calendarAlt, size: 24.0, color: Color(0xff737373),),
                            SizedBox(width: 10.0,),
                            Text(
                              'Your Plan Poses',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xff737373),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: plans.length,
                        itemBuilder: (context,index)
                        {
                          return Addictions(
                            addictionName: plans[index]['planName'],
                            convertedAddictionName: addictions[lang][addictions['English'].indexOf(plans[index]['planName'])],
                            list: List.from(poses[addictions['English'].indexOf(plans[index]['planName'])]),
                          );
                        },
                      ),
                      SizedBox(height: 12.0,),
                    ],
                  );
                },
              ):Container(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.calendarAlt, size: 24.0, color: Color(0xff737373),),
                    SizedBox(width: 10.0,),
                    Text(
                      "All Addiction Poses",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color(0xff737373),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6,),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: addictions[lang].length,
                itemBuilder: (context,index){
                  return Addictions(
                    addictionName: addictions['English'][index],
                    convertedAddictionName: addictions[lang][index],
                    list: List.from(poses[index]),
                  );
                },
              ),
            ],
          ),
        ),
    );
  }
}

class Addictions extends StatelessWidget {
  final String addictionName;
  final String convertedAddictionName;
  final List list;

  const Addictions({Key key,this.addictionName,this.convertedAddictionName,this.list}) : super(key: key);

  void navigate(BuildContext context){
    preferences.setString(addictionName+'yoga', DateFormat.MMMMd().add_jm().format(DateTime.now()).toString());
    Navigator.push(context, MaterialPageRoute(builder: (context)=>YogaPlans(
      addictionName: convertedAddictionName,
      poses: List.from(list),
    )));
  }

  @override
  Widget build(BuildContext context) {
    String accessTime=preferences.getString(addictionName+'yoga')??'';
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: ()=>navigate(context),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          color: Color(0xfff0f0f0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/blueAddiction/'+getFileName(addictionName)+'.png',),
                      backgroundColor: const Color(0xff9ad0e5),
                      radius: 25,
                    )
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        convertedAddictionName,
                        style: TextStyle (
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                      Text("Completed 80%   Level-3",
                        style: TextStyle (
                          color: Color(0xff606060),
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  VerticalDivider(
                    color: Color(0xffcecece),
                    width: 0,
                    thickness:2.0,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    accessTime!=''?accessTime:"Get Started",
                    style: TextStyle (
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
