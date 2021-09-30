import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/audioTherapy.dart';
import 'package:addictx/pages/bottomSheetForSession.dart';
import 'package:addictx/pages/session.dart';
import 'package:addictx/pages/specificAudioList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuidedWellnessSessions extends StatefulWidget {
  @override
  _GuidedWellnessSessionsState createState() => _GuidedWellnessSessionsState();
}

class _GuidedWellnessSessionsState extends State<GuidedWellnessSessions> {
  List<Map> collectionNames=[];
  List<QuerySnapshot> collectionDataList=[];
  bool loading=true;
  Map<String, List> audioTherapy={
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
  Map titles={
    'English':'Sessions',
    'Hindi':'सत्र',
    'Spanish':'Sesiones',
    'German':'Sitzungen',
    'French':"Séances",
    'Japanese':'セッション',
    'Russian':'Сессии',
    'Chinese':'会话',
    'Portuguese':'Sessões',
  };
  Map audioTherapyText={
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

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData()async{
    DocumentSnapshot documentSnapshot=await sessionsReference.doc('sessionName').get();
    collectionNames=List.from(documentSnapshot.data()['sessionName']);
    for (var element in collectionNames)
      {
        QuerySnapshot snapshot=await sessionsReference.doc('sessionName').collection(element['heading']).orderBy('sno',).limit(3).get();
        collectionDataList.add(snapshot);
      }
    setState(() {
      loading=false;
    });
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
        actions: [
          Center(
            child: Text(
              titles[lang]+' ',
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        "assets/guidedWellnessSessions.jpeg",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AudioTherapy(audioTherapy: audioTherapy,))),
                    child: Row(
                      children: [
                        Icon(Icons.music_note,color: const Color(0x8c000000),),
                        Text(
                          audioTherapyText[lang],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: const Color(0x8c000000),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded,size: 20,color: const Color(0x8c000000),),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.22,
                    width: double.infinity,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: audioTherapy[lang].length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(width: 8,);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SpecificAudioList(audioConvertedHeading: audioTherapy[lang][index],audioHeading: audioTherapy['English'][index],))),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.28,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    height: MediaQuery.of(context).size.height*0.17,
                                    width: MediaQuery.of(context).size.width*0.28,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/audioTherapy/${audioTherapy['English'][index]}.jpg'),
                                  ),
                                ),
                                Text(
                                  audioTherapy[lang][index],
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
                  SizedBox(height: 25,),
                  loading?Container(
                    margin: EdgeInsets.only(top: 60),
                    child: Center(child: CircularProgressIndicator(),),
                  ):ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: collectionNames.length,
                    separatorBuilder: (context,index)=>SizedBox(height: 10,),
                    itemBuilder: (context,mainIndex){
                      return Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Session(
                              session: collectionNames[mainIndex],
                              snapshot: collectionDataList[mainIndex].docs,
                            ))),
                            child: Row(
                              children: [
                                Text(
                                  collectionNames[mainIndex]['heading'],
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0x8c000000),
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_rounded,size: 20,color: const Color(0x8c000000),),
                              ],
                            ),
                          ),
                          SizedBox(height: 15,),
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.28,
                            width: double.infinity,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context,subIndex)=>SizedBox(width: 8,),
                              itemCount: collectionDataList[mainIndex].docs.length,
                              itemBuilder: (context,index){
                                DocumentSnapshot doc=collectionDataList[mainIndex].docs[index];
                                return GestureDetector(
                                  onTap: (){
                                    bottomSheetForSession(context, doc);
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: doc.data()['imageUrl'],
                                          width: MediaQuery.of(context).size.width*0.6,
                                          height: MediaQuery.of(context).size.height*0.22,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        doc.data()['heading'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: const Color(0x8c000000),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.access_time,size: 16,color: const Color(0x8c000000),),
                                          Text(
                                            " "+doc.data()['duration'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: const Color(0x8c000000),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
            Image.asset(
              'assets/powered.jpeg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
