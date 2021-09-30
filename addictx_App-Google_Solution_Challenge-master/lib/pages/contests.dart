import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/helpers/languageCode.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/badgesPopUp.dart';
import 'package:addictx/pages/challengeList.dart';
import 'package:addictx/pages/doYouKnow.dart';
import 'package:addictx/pages/guidedWellnessSessions.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:addictx/yoga/addictionplans.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:translator/translator.dart';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:url_launcher/url_launcher.dart';

class Contests extends StatefulWidget {
  @override
  _ContestsState createState() => _ContestsState();
}

class _ContestsState extends State<Contests> {
  List<String> badges=[];
  bool loadingBadges=true;
  final translator = GoogleTranslator();
  String lang='English';
  Map facts;
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  Box<int> stepsBox = Hive.box('steps');
  int todaySteps=5;
  Map title={
    'English':'AddictX Contest',
    'Hindi':'एडिक्टएक्स प्रतियोगिता',
    'Spanish':'Concurso AddictX',
    'German':'AddictX-Wettbewerb',
    'French':'Concours AddictX',
    'Japanese':'AddictXコンテスト',
    'Russian':'Конкурс AddictX',
    'Chinese':'AddictX 竞赛',
    'Portuguese':'Concurso AddictX'
  };
  Map yogaPoses={
    'English':"Yoga Poses",
    'Hindi':'योग मुद्रा',
    'Spanish':'Poses De Yoga',
    'German':'Yoga-Posen',
    'French':'Postures De Yoga',
    'Japanese':'ヨガのポーズ',
    'Russian':'Позы Йоги',
    'Chinese':'瑜伽姿势',
    'Portuguese':'Poses de ioga'
  };
  Map flexibility={
    'English':"Step up your flexibility game",
    'Hindi':'अपने लचीलेपन के खेल को आगे बढ़ाएं',
    'Spanish':'Mejora tu juego de flexibilidad',
    'German':'Steigern Sie Ihr Flexibilitätsspiel',
    'French':'Améliorez votre jeu de flexibilité',
    'Japanese':'柔軟性ゲームを強化する',
    'Russian':'Увеличьте свою гибкость в игре',
    'Chinese':'加强你的灵活性游戏',
    'Portuguese':'Aumente o seu jogo de flexibilidade'
  };
  Map challenges={
    'English':"Challenges",
    'Hindi':'चुनौतियां',
    'Spanish':'Desafíos',
    'German':'Herausforderungen',
    'French':'Défis',
    'Japanese':'課題',
    'Russian':'Вызовы',
    'Chinese':'挑战',
    'Portuguese':'Desafios'
  };
  Map fitness={
    'English':"Step up your fitness game",
    'Hindi':'अपने फिटनेस गेम को आगे बढ़ाएं',
    'Spanish':'Mejora tu juego de fitness',
    'German':'Steigern Sie Ihr Fitnessspiel',
    'French':'Améliorez votre jeu de fitness',
    'Japanese':'フィットネスゲームを強化する',
    'Russian':'Развивайте свои фитнес-игры',
    'Chinese':'加强你的健身游戏',
    'Portuguese':'Aumente o seu jogo de fitness',
  };
  Map session={
    'English':"Guided wellness sessions",
    'Hindi':'गाइडेड वेलनेस सेशन',
    'Spanish':'Sesiones de bienestar guiadas',
    'German':'Geführte Wellness-Sitzungen',
    'French':'Séances de bien-être guidées',
    'Japanese':'ガイド付きウェルネスセッション',
    'Russian':'Велнес-сеансы с гидом',
    'Chinese':'有指导的健康课程',
    'Portuguese':'Sessões de bem-estar guiadas',
  };
  Map routine={
    'English':"Choose a routine for holistic wellness",
    'Hindi':'समग्र स्वास्थ्य के लिए एक दिनचर्या चुनें',
    'Spanish':'Elija una rutina para el bienestar integral',
    'German':'Wählen Sie eine Routine für ganzheitliches Wohlbefinden',
    'French':'Choisissez une routine pour un bien-être holistique',
    'Japanese':'ホリスティックウェルネスのルーチンを選択してください',
    'Russian':'Выберите режим для целостного здоровья',
    'Chinese':'选择一个整体健康的例行程序',
    'Portuguese':'Escolha uma rotina de bem-estar holístico',
  };
  Map progress={
    'English':"Hey, ${currentUser!=null?currentUser.username:username} here's your progress for the day",
    'Hindi':'हे, ${currentUser!=null?currentUser.username:username} यहाँ आज के दिन के लिए आपकी प्रगति',
    'Spanish':'Oye, ${currentUser!=null?currentUser.username:username} aquí tu progreso del día.',
    'German':'Hey, ${currentUser!=null?currentUser.username:username} hier deine Fortschritte für den Tag',
    'French':'Hé, ${currentUser!=null?currentUser.username:username} voici tes progrès pour la journée',
    'Japanese':'ねえ、${currentUser!=null?currentUser.username:username} ここでその日の進捗状況',
    'Russian':'Привет, ${currentUser!=null?currentUser.username:username} вот ваш прогресс за день',
    'Chinese':'嘿, ${currentUser!=null?currentUser.username:username} 这是您当天的进度',
    'Portuguese':'Ei, ${currentUser!=null?currentUser.username:username} aqui está o seu progresso para o dia',
  };
  Map badgesText={
    'English':"Badges",
    'Hindi':'बैज',
    'Spanish':'Insignias',
    'German':'Abzeichen',
    'French':'Insignes',
    'Japanese':'バッジ',
    'Russian':'Значки',
    'Chinese':'徽章',
    'Portuguese':'Distintivos',
  };
  Map doYouKnow={
    'English':"Do you Know ?",
    'Hindi':'क्या आपको पता है ?',
    'Spanish':'Lo sabías ?',
    'German':'Wissen Sie ?',
    'French':'Savez-vous ?',
    'Japanese':'あなたは知っていますか',
    'Russian':'Ты знаешь ?',
    'Chinese':'你知道吗',
    'Portuguese':'Você sabe ?',
  };
  Map learnMore={
    'English':"Tap to learn more",
    'Hindi':'अधिक जानने के लिए टैप करें',
    'Spanish':'Toca para obtener más información.',
    'German':'Tippen Sie hier, um mehr zu erfahren',
    'French':'Appuyez pour en savoir plus',
    'Japanese':'タップして詳細をご覧ください',
    'Russian':'Нажмите, чтобы узнать больше',
    'Chinese':'点按以了解更多信息',
    'Portuguese':'Toque para saber mais',
  };
  Map covid={
    'English':"COVID-19",
    'Hindi':'COVID-19',
    'Spanish':'COVID-19',
    'German':'COVID-19',
    'French':'COVID-19',
    'Japanese':'COVID-19',
    'Russian':'COVID-19',
    'Chinese':'新冠肺炎',
    'Portuguese':'COVID-19',
  };
  Map covidStatement={
    'English':'"Ultimately, the greatest lesson that COVID-19 can teach humanity is that we are all in this together."',
    'Hindi':'"आखिरकार, सबसे बड़ा सबक जो COVID-19 मानवता को सिखा सकता है, वह यह है कि हम सब इसमें एक साथ हैं।"',
    'Spanish':'"En última instancia, la mayor lección que COVID-19 puede enseñar a la humanidad es que todos estamos juntos en esto".',
    'German':'„Letztendlich ist die größte Lektion, die COVID-19 der Menschheit beibringen kann, dass wir alle zusammen dabei sind.“',
    'French':'''"En fin de compte, la plus grande leçon que COVID-19 peut enseigner à l'humanité est que nous sommes tous dans le même bateau."''',
    'Japanese':"「最終的に、COVID-19が人類に教えることができる最大の教訓は、私たち全員が一緒にいるということです。」",
    'Russian':'«В конечном счете, величайший урок, который COVID-19 может преподать человечеству, заключается в том, что мы все делаем это вместе».',
    'Chinese':'“最终，COVID-19 可以教给人类的最大教训是我们都在一起。”',
    'Portuguese':'"Em última análise, a maior lição que COVID-19 pode ensinar à humanidade é que estamos todos juntos nisso."',
  };
  Map covidLearnMore={
    'English':"Learn more",
    'Hindi':'और अधिक जानें',
    'Spanish':'Aprende más',
    'German':'Mehr erfahren',
    'French':'Apprendre encore plus',
    'Japanese':'もっと詳しく知る',
    'Russian':'Учить больше',
    'Chinese':'学到更多',
    'Portuguese':'COVID-19',
  };
  Map calories={
    'English':'CALORIES',
    'Hindi':'कैलोरी',
    'Spanish':'CALORIAS',
    'German':'KALORIEN',
    'French':'CALORIES',
    'Japanese':'カロリー',
    'Russian':'КАЛОРИИ',
    'Chinese':'卡路里',
    'Portuguese':'CALORIAS',
  };
  Map steps={
    'English':'STEPS',
    'Hindi':'कदम',
    'Spanish':'PASOS',
    'German':'SCHRITTE',
    'French':'PAS',
    'Japanese':'階段',
    'Russian':'звук шагов',
    'Chinese':'墀',
    'Portuguese':'DEGRAUS',
  };
  Map distance={
    'English':'DISTANCE',
    'Hindi':'दूरी',
    'Spanish':'DISTANCIA',
    'German':'ENTFERNUNG',
    'French':'DISTANCE',
    'Japanese':'距離',
    'Russian':'РАССТОЯНИЕ',
    'Chinese':'距离',
    'Portuguese':'DISTÂNCIA',
  };
  Map unableToLaunchUrl={
    'English':"Something went wrong!! Please try again later",
    'Hindi':'कुछ गलत हो गया!! बाद में पुन: प्रयास करें',
    'Spanish':'¡¡Algo salió mal. Por favor, inténtelo de nuevo más tarde',
    'German':'Etwas ist schief gelaufen!! Bitte versuchen Sie es später noch einmal',
    'French':"Quelque chose s'est mal passé !! Veuillez réessayer plus tard",
    'Japanese':'何かがうまくいかなかった!!後でもう一度やり直してください',
    'Russian':'Что-то пошло не так!! Пожалуйста, повторите попытку позже',
    'Chinese':'出问题了！！请稍后再试',
    'Portuguese':'Algo deu errado !! Por favor, tente novamente mais tarde'
  };


  @override
  void initState()
  {
    getBadges();
    startListening();
    super.initState();
  }

  @override
  void dispose()
  {
    stopListening();
    super.dispose();
  }

  void launchLink(String link)async
  {
    if (await canLaunch(link)) {
      await launch(
        link,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String,String>{'header_key':'header_value'},
      );
    } else {
      showToast(unableToLaunchUrl[lang]);
    }
  }

  void startListening() {
    _pedometer = Pedometer();
    _subscription = _pedometer.pedometerStream.listen(
      getTodaySteps,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: true,
    );
  }

  void _onDone() => print("Finished pedometer tracking");
  void _onError(error) => print("Flutter Pedometer Error: $error");

  Future<int> getTodaySteps(int value) async {
    print(value);
    int savedStepsCountKey = 999999;
    int savedStepsCount = stepsBox.get(savedStepsCountKey, defaultValue: 0);

    int todayDayNo = Jiffy(DateTime.now()).dayOfYear;
    if (value < savedStepsCount) {
      // Upon device reboot, pedometer resets. When this happens, the saved counter must be reset as well.
      savedStepsCount = 0;
      // persist this value using a package of your choice here
      stepsBox.put(savedStepsCountKey, savedStepsCount);
    }

    // load the last day saved using a package of your choice here
    int lastDaySavedKey = 888888;
    int lastDaySaved = stepsBox.get(lastDaySavedKey, defaultValue: 0);

    // When the day changes, reset the daily steps count
    // and Update the last day saved as the day changes.
    if (lastDaySaved < todayDayNo) {
      lastDaySaved = todayDayNo;
      savedStepsCount = value;

      stepsBox
        ..put(lastDaySavedKey, lastDaySaved)
        ..put(savedStepsCountKey, savedStepsCount);
    }

    setState(() {
      todaySteps = value - savedStepsCount;
    });
    stepsBox.put(todayDayNo, todaySteps);
    return todaySteps; // this is your daily steps value.
  }

  void stopListening() {
    _subscription.cancel();
  }

  updateScoreOfContest()async{
    if(currentUser!=null){
      await leaderBoardReference.doc("Walking").collection('scores').doc(currentUser.id).set({
        'id':currentUser.id,
        'timeStamp':DateTime.now(),
        'score':FieldValue.increment((todaySteps/4).floor()),
      },SetOptions(merge: true));
      await usersReference.doc(currentUser.id).update({
        'score':FieldValue.increment((todaySteps/4).floor()),
      });
    }
  }

  Future<bool> onBackPress()
  {
    updateScoreOfContest();
    Navigator.pop(context);
    return Future.value(false);
  }

  void getBadges()async{
    if(currentUser!=null)
    {
      DocumentSnapshot doc=await badgesReference.doc(currentUser.id).get();
      if(doc.exists)
        badges=List.from(doc.data()['badges']);
    }
    setState(() {
      loadingBadges=false;
    });
  }

  Future getFacts()async{
    DocumentSnapshot doc=await doYouKnowReference.doc("homeScreen").get();
    if(doc.exists)
    {
      facts=doc.data();
      if(lang!='English')
      {
        var content = await translator.translate(doc.data()['content'], from: 'en', to: LanguageCode.getCode(lang));
        var heading = await translator.translate(doc.data()['heading'], from: 'en', to: LanguageCode.getCode(lang));
        var subtitle = await translator.translate(doc.data()['subTitle'], from: 'en', to: LanguageCode.getCode(lang));
        facts['content']=content.text;
        facts['heading']=heading.text;
        facts['subTitle']=subtitle.text;
      }
    }
    return facts;
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    /*return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 2,
          itemBuilder: (context,index){
            return ContestsPage(
              heading: index==0?"Yoga":"Walking",
              description: index==0?"Performing yoga can help you live a healthy lifestyle.":"Walking helps you to loose fat and remain active",
              fileAddress: index==0?"assets/yoga/yogabg.jpg":"assets/walking.jpg",
            );
          }
      ),
    );*/
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          actions: [
            Center(
              child: Text(
                title[lang]+' ',
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
            onTap: (){
              updateScoreOfContest();
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color(0xfff0f0f0),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Text(
                      yogaPoses[lang],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0x8c000000),
                      ),
                    ),
                    SizedBox(height: 15,),
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>YogaPage())),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            width: double.infinity,
                            alignment: Alignment.bottomLeft,
                            height: MediaQuery.of(context).size.width*0.33,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: AssetImage('assets/yoga.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                              ),
                            ),
                            child: Text(
                              flexibility[lang],
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 18,),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      challenges[lang],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0x8c000000),
                      ),
                    ),
                    SizedBox(height: 15,),
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChallengeList())),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            width: double.infinity,
                            alignment: Alignment.bottomLeft,
                            height: MediaQuery.of(context).size.width*0.33,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: AssetImage('assets/challenge.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                              ),
                            ),
                            child: Text(
                              fitness[lang],
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 18,),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      session[lang],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0x8c000000),
                      ),
                    ),
                    SizedBox(height: 15,),
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>GuidedWellnessSessions())),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            width: double.infinity,
                            alignment: Alignment.bottomLeft,
                            height: MediaQuery.of(context).size.width*0.33,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: AssetImage('assets/session.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                              ),
                            ),
                            child: Text(
                              routine[lang],
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 18,),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      progress[lang],
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0x8c000000),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 160,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularStepProgressIndicator(
                                totalSteps: 10000,
                                currentStep: todaySteps,
                                stepSize: 5,
                                selectedColor: const Color(0xff9ad0e5),
                                unselectedColor: const Color(0xffe9e9e9),
                                width: 90,
                                height: 90,
                                selectedStepSize: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.running, color: const Color(0xff9ad0e5),),
                                    SizedBox(height: 8,),
                                    Text(
                                      (todaySteps*0.0008).toStringAsFixed(2)+' KM',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(distance[lang]),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularStepProgressIndicator(
                                totalSteps: 10000,
                                currentStep: todaySteps,
                                stepSize: 6,
                                selectedColor: const Color(0xff9ad0e5),
                                unselectedColor: const Color(0xffe9e9e9),
                                width: 120,
                                height: 120,
                                selectedStepSize: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Icon(FontAwesomeIcons.shoePrints,size: 30, color: const Color(0xff9ad0e5),),
                                    ),
                                    SizedBox(height: 8,),
                                    Text(todaySteps.toString()+"/10000"),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(steps[lang]),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularStepProgressIndicator(
                                totalSteps: 10000,
                                currentStep: todaySteps,
                                stepSize: 6,
                                selectedColor: const Color(0xff9ad0e5),
                                unselectedColor: const Color(0xffe9e9e9),
                                width: 90,
                                height: 90,
                                selectedStepSize: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.heartbeat,size: 24, color: const Color(0xff9ad0e5),),
                                    SizedBox(height: 8,),
                                    Text(
                                      (todaySteps*0.04).toStringAsFixed(2)+" kcal",//if weight is ~70kg
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(calories[lang]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      badgesText[lang],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0x8c000000),
                      ),
                    ),
                    SizedBox(height: 15,),
                    currentUser!=null?Container(
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: const Color(0xfff0f0f0),
                      ),
                      child: loadingBadges?Center(child: CircularProgressIndicator(),):ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: badges.length,
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>BadgesPopUp(
                                title: badges[index]=='Addiction'?'for completing your addiction plan':badges[index]=='Habit Building'?"for completing 30 days of your habit building":"for doing ${badges[index]} for more than 30 times",
                                fileName: badges[index],
                              )));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.33,
                              margin: EdgeInsets.only(right:10.0),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                color: Colors.blue[100].withOpacity(0.3),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: AssetImage('assets/badges/${badges[index]}.png'),
                                  ),
                                  SizedBox(height: 15,),
                                  Text(
                                    badges[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.gugi(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ):Container(),
                    SizedBox(height: 30,),
                    /*Text(
                      "Recent Activities",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0x8c000000),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 150,
                      color: Colors.blue[100],
                      child: Text("Recent Activities",style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(height: 20,),*/
                  ],
                ),
              ),
              FutureBuilder(
                future: getFacts(),
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                    return Container(
                      height: MediaQuery.of(context).size.height*0.35,
                      width: double.infinity,
                      color: const Color(0x61000000),
                      child: Center(child: CircularProgressIndicator(),),
                    );
                  return facts!=null?GestureDetector(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DoYouKnow(
                      url: snapshot.data['url'],
                      heading: snapshot.data['heading'],
                      content: snapshot.data['content'],
                    ))),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xfff0f0f0),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text(
                            doYouKnow[lang],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 23.0,
                            ),
                          ),
                          SizedBox(height: 5,),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              snapshot.data['subTitle'],
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height*0.25,
                              color: const Color(0x61000000),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data['url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Center(
                            child: Text(
                              snapshot.data['heading'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Center(
                            child: Text(
                              learnMore[lang],
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                letterSpacing: 0.473,
                                color: const Color(0x61000000),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  ):Container();
                },
              ),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.27,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/covid.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                    ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      covid[lang],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      covidStatement[lang],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: ()=>launchLink('https://covid19.who.int/'),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: const Color(0xb0000000),
                        ),
                        child: Text(
                          covidLearnMore[lang],
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
