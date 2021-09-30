import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/languageCode.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/dietList.dart';
import 'package:addictx/pages/music.dart';
import 'package:addictx/pages/plans.dart';
import 'package:addictx/pages/specificAudioList.dart';
import 'package:addictx/yoga/ai.dart';
import 'package:addictx/yoga/yogaplans.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class Combine extends StatelessWidget {
  final String heading;
  final String fileName;
  Combine({this.heading,this.fileName});

  final translator = GoogleTranslator();
  String lang='English';

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
  Map dailyPlan={
    'English':"Daily Plan",
    'Hindi':'दैनिक योजना',
    'Spanish':'Plan diario',
    'German':'Tagesplan',
    'French':"Plan quotidien",
    'Japanese':'デイリープラン',
    'Russian':'Ежедневный план',
    'Chinese':'每日计划',
    'Portuguese':'Plano Diário',
  };
  Map dailyPlanDescription={
    'English':"Plan will guide you",
    'Hindi':'योजना आपका मार्गदर्शन करेगी',
    'Spanish':'El plan te guiará',
    'German':'Plan wird dich leiten',
    'French':"Le plan vous guidera",
    'Japanese':'計画はあなたを導きます',
    'Russian':'План поможет вам',
    'Chinese':'计划将引导您',
    'Portuguese':'O plano irá guiá-lo',
  };
  Map audioTherapy={
    'English':'Audio Therapy',
    'Hindi':'ऑडियो थेरेपी',
    'Spanish':'Terapia de audio',
    'German':'Audiotherapie',
    'French':'Audiothérapie',
    'Japanese':'オーディオセラピー',
    'Russian':'Аудиотерапия',
    'Chinese':'音频治疗',
    'Portuguese':'Terapia de Áudio',
  };
  Map noAudioTherapy={
    'English':'Audio Therapies are being updated...',
    'Hindi':'ऑडियो थेरेपी अपडेट की जा रही हैं...',
    'Spanish':'Las terapias de audio se están actualizando ...',
    'German':'Audiotherapien werden aktualisiert...',
    'French':'Les audiothérapies sont en cours de mise à jour...',
    'Japanese':'オーディオセラピーは更新されています...',
    'Russian':'Аудиотерапия обновляется ...',
    'Chinese':'音频疗法正在更新中...',
    'Portuguese':'As terapias de áudio estão sendo atualizadas ...',
  };
  Map yogaPoses={
    'English':'Yoga Poses',
    'Hindi':'योग मुद्रा',
    'Spanish':'Poses De Yoga',
    'German':'Yoga-Posen',
    'French':'Postures De Yoga',
    'Japanese':'ヨガのポーズ',
    'Russian':'Позы Йоги',
    'Chinese':'瑜伽姿势',
    'Portuguese':'Poses de ioga',
  };
  Map dietPlan={
    'English':'Diet Plan',
    'Hindi':'आहार योजना',
    'Spanish':'Plan de dieta',
    'German':'Diät Plan',
    'French':'Régime alimentaire',
    'Japanese':'ダイエット計画',
    'Russian':'План диеты',
    'Chinese':'饮食计划',
    'Portuguese':'Plano de dieta',
  };
  Map dietDescription={
    'English':"Food will decide your future",
    'Hindi':'खाना तय करेगा आपका भविष्य',
    'Spanish':'La comida decidirá tu futuro',
    'German':'Essen entscheidet über deine Zukunft',
    'French':'La nourriture décidera de votre avenir',
    'Japanese':'食べ物があなたの未来を決める',
    'Russian':'Еда решит ваше будущее',
    'Chinese':'食物决定你的未来',
    'Portuguese':'A comida vai decidir o seu futuro'
  };
  
  Future<List> getAudios()async{
    DocumentSnapshot doc=await audioTherapiesReference.doc(heading).get();
    List<Map> audioList=[];
    if(doc.exists){
      audioList.addAll(List.from(doc.data()['audios']));
      //translate
      if(lang!='English')
      {
        for(int i=0;i<audioList.length;i++){
          var audioName = await translator.translate(audioList[i]['audioName'], from: 'en', to: LanguageCode.getCode(lang));
          var audioLine = await translator.translate(audioList[i]['audioLine'], from: 'en', to: LanguageCode.getCode(lang));
          var audioDescription = await translator.translate(audioList[i]['audioDescription'], from: 'en', to: LanguageCode.getCode(lang));
          audioList[i]['audioName']=audioName.text;
          audioList[i]['audioLine']=audioLine.text;
          audioList[i]['audioDescription']=audioDescription.text;
        }
      }
    }
    return audioList;
  }

  String returnPoseName(String poseName){
    switch (poseName) {
      case 'Cat Stretch':
        return 'Cat Stretch';
        break;
      case 'Chair Pose':
        return 'Chair Pose';
        break;
      case 'Chakrasana':
        return 'Chakrasana';
        break;
      case 'Child Pose':
        return 'Child Pose';
        break;
      case 'Cobra Pose':
        return 'Cobra pose';
        break;
      case 'Dolphin Pose':
        return 'Dolphin pose';
      case 'Downward Facing Dog':
        return 'Downward-Facing Dog';
        break;
      case 'Fish Pose':
        return 'fish pose';
        break;
      case 'Gomukhasana':
        return 'Gomukhasana';
        break;
      case 'Knee to Chest':
        return 'knee to chest';
        break;
      case 'Lotus pose':
        return 'lotus pose';
        break;
      case 'Low Lungs':
        return 'low lungs';
        break;
      case 'Mandukhasana':
        return 'Mandukasana';
        break;
      case 'Pigeon Pose':
        return 'Pigeon Pose';
        break;
      case 'Plank':
        return 'plank';
        break;
      case 'Revolved head of knee':
        return 'Revolved Head-of-the-Knee Pose';
        break;
      case 'Salamba Shrishasana':
        return 'Salamba Shirshasana';
        break;
      case 'Seated Forward Fold':
        return 'seated forward fold';
        break;
      case 'Seated Spinal Twist':
        return 'Seated Spinal Twist';
        break;
      case 'Tadasana':
        return 'tadasan';
        break;
      case 'Plow Pose':
        return 'The Plow Pose';
        break;
      case 'Tree Pose':
        return 'tree pose';
        break;
      case 'Triangle Pose':
        return 'Triangle Pose';
        break;
      case 'Uttasana':
        return 'Uttanasana';
        break;
      case 'Vajrasana':
        return 'Vajrasana';
        break;
      case 'Viparita Karani':
        return 'Viparita Karani';
        break;
      case 'Viparita Shabasana':
        return 'viparita shalabhasana';
        break;
      case 'Warrior-1':
        return 'warrior 1';
        break;
      case 'Bound Angle Pose':
        return 'Bound Angle Pose';
        break;
      case 'Bow Pose':
        return 'Bow pose';
        break;
      case 'Bridge':
        return 'Bridge Pose';
        break;
      case 'Camel Pose':
        return 'Camel pose';
        break;
      default:
        return 'no pose exists';
    }
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
              heading+' ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                letterSpacing: 1.0,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Plans(heading: heading,fileName: fileName,))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:15.0),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.book, size: 24.0, color: const Color(0xff737373),),
                    SizedBox(width: 10.0,),
                    Text(
                      dailyPlan[lang],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: const Color(0xff737373),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Plans(heading: heading,fileName: fileName,))),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.19,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: AssetImage('assets/dailyPlan.jpeg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                      )
                    ),
                    child: Text(
                      dailyPlanDescription[lang],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 20,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SpecificAudioList(audioConvertedHeading: addictions[lang][addictions['English'].indexOf(heading)],audioHeading: heading,))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:15.0),
                child: Row(
                  children: [
                    Icon(Icons.music_note, size: 24.0, color: const Color(0xff737373),),
                    SizedBox(width: 10.0,),
                    Text(
                      audioTherapy[lang],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: const Color(0xff737373),
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: getAudios(),
              builder: (context,AsyncSnapshot<List> snapshot){
                if(!snapshot.hasData)
                  return Center(child: CircularProgressIndicator(),);
                else if(snapshot.data.isEmpty)
                  return Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.18,
                    child: Text(noAudioTherapy[lang],textAlign: TextAlign.center,),
                  );
                List<Map> audioList=List.from(snapshot.data);
                return Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.2,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: audioList.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index)=>SizedBox(width: 8,),
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> Music(audios: List.from(audioList),index: index,),),),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.28,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xff9ad0e5),
                                ),
                                child: Image(
                                  height: MediaQuery.of(context).size.height*0.17,
                                  width: MediaQuery.of(context).size.width*0.28,
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(audioList[index]['audioImage']),
                                ),
                              ),
                              Text(
                                audioList[index]['audioName'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>YogaPlans(
                  addictionName: addictions[lang][addictions['English'].indexOf(heading)],
                  poses: List.from(poses[addictions['English'].indexOf(heading)]),
                )));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:15.0),
                child: Row(
                  children: [
                    Icon(Icons.accessibility_new_rounded, size: 24.0, color: const Color(0xff737373),),
                    SizedBox(width: 10.0,),
                    Text(
                      yogaPoses[lang],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: const Color(0xff737373),
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.22,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: poses[addictions[lang].indexOf(heading)].length,
                separatorBuilder: (context, index)=>SizedBox(width: 8,),
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewExample(poseName: returnPoseName(poses[addictions[lang].indexOf(heading)][index]),))),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.58,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                              height: MediaQuery.of(context).size.height*0.19,
                              width: MediaQuery.of(context).size.width*0.58,
                              fit: BoxFit.cover,
                              image: AssetImage('assets/yogaPoses/${poses[addictions[lang].indexOf(heading)][index]}.jpg'),
                            ),
                          ),
                          Text(
                            poses[addictions[lang].indexOf(heading)][index],
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DietList())),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:15.0),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.utensils, size: 24.0, color: const Color(0xff737373),),
                    SizedBox(width: 10.0,),
                    Text(
                      dietPlan[lang],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: const Color(0xff737373),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DietList())),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.19,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: AssetImage('assets/dietList/$fileName.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                        ),
                    ),
                    child: Text(
                      dietDescription[lang],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 20,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
