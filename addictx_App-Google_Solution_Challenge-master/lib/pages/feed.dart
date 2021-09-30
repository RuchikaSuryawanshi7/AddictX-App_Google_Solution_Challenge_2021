import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/history.dart';
import 'package:addictx/pages/typeTextPost.dart';
import 'package:addictx/pages/uploadPage.dart';
import 'package:flutter/material.dart';
import 'package:addictx/pages/dailyMotivation.dart';
import 'package:addictx/pages/speakAloud.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin{
  TabController tabController;
  String lang='English';
  Map textPost={
    'English':'Upload Text Post',
    'Hindi':'टेक्स्ट पोस्ट अपलोड करें',
    'Spanish':'Subir publicación de texto',
    'German':'Textbeitrag hochladen',
    'French':"Télécharger le message texte",
    'Japanese':'テキスト投稿をアップロード',
    'Russian':'Загрузить текстовое сообщение',
    'Chinese':'上传文本帖子',
    'Portuguese':'Carregar Postagem de Texto',
  };
  Map uploadMedia={
    'English':'Upload Photo/Video',
    'Hindi':'फोटो/वीडियो अपलोड करें',
    'Spanish':'Subir foto / video',
    'German':'Foto/Video hochladen',
    'French':"Télécharger une photo/vidéo",
    'Japanese':'写真/ビデオをアップロードする',
    'Russian':'Загрузить фото / видео',
    'Chinese':'上传照片/视频',
    'Portuguese':'Carregar foto / vídeo',
  };
  Map askQuestion={
    'English':'Ask Question',
    'Hindi':'प्रश्न पूछो',
    'Spanish':'Pregunta',
    'German':'Frage stellen',
    'French':"Poser une question",
    'Japanese':'質問をする',
    'Russian':'Задай вопрос',
    'Chinese':'问问题',
    'Portuguese':'Faça uma pergunta',
  };
  Map history={
    'English':'History',
    'Hindi':'इतिहास',
    'Spanish':'Historia',
    'German':'Geschichte',
    'French':"Histoire",
    'Japanese':'歴史',
    'Russian':'История',
    'Chinese':'历史',
    'Portuguese':'História',
  };
  Map dailyMotivation={
    'English':'DAILY MOTIVATION',
    'Hindi':'दैनिक प्रेरणा',
    'Spanish':'MOTIVACIÓN DIARIA',
    'German':'TÄGLICHE MOTIVATION',
    'French':"MOTIVATION AU QUOTIDIEN",
    'Japanese':'毎日のモチベーション',
    'Russian':'ЕЖЕДНЕВНАЯ МОТИВАЦИЯ',
    'Chinese':'每日动力',
    'Portuguese':'MOTIVAÇÃO DIÁRIA',
  };
  Map speakAloud={
    'English':'SPEAK LOUD',
    'Hindi':'व्यक्त करें',
    'Spanish':'HABLA ALTO',
    'German':'SPRICH LAUT',
    'French':"PARLE FORT",
    'Japanese':'大声で話す',
    'Russian':'ГОВОРИТЬ ГРОМКО',
    'Chinese':'大声说出来',
    'Portuguese':'FALAR ALTO',
  };

  @override
  void initState() {
    tabController= new TabController(vsync: this, length: 2,initialIndex: 0);
    super.initState();
  }

  @override
  void dispose()
  {
    tabController.dispose();
    super.dispose();
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      marginEnd: 5,
      marginBottom: 5,
      icon: Icons.add,
      activeIcon: Icons.close,
      iconTheme: IconThemeData(
        size: 30.0,
        color: Colors.white,
      ),
      buttonSize: 76.0,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      backgroundColor: Color(0xff9ad0e5),
      elevation: 8.0,
      shape: CircleBorder(
        side: BorderSide(width: 4.0, color: Colors.white, style: BorderStyle.solid),
      ),
      children: [
        SpeedDialChild(
          child: Icon(Icons.chat_rounded,color: Colors.white,),
          backgroundColor: Color(0xff9ad0e5),
          labelBackgroundColor: Colors.white,
          label: textPost[lang],
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => currentUser!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>TypeTextPost(isPost: true,))):showToast('Login to upload'),
        ),
        SpeedDialChild(
          child: Icon(Icons.add_a_photo_rounded,color: Colors.white,),
          backgroundColor: Color(0xff9ad0e5),
          labelBackgroundColor: Colors.white,
          label: uploadMedia[lang],
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => currentUser!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>Upload())):showToast('Login to upload'),
        ),
        SpeedDialChild(
          child: Icon(Icons.insert_comment_rounded,color: Colors.white,),
          backgroundColor: Color(0xff9ad0e5),
          labelBackgroundColor: Colors.white,
          label: askQuestion[lang],
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => currentUser!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>TypeTextPost(isPost: false,))):showToast('Login to ask'),
        ),
        SpeedDialChild(
          child: Icon(Icons.history,color: Colors.white,),
          backgroundColor: Color(0xff9ad0e5),
          labelBackgroundColor: Colors.white,
          label: history[lang],
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => currentUser!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>History())):showToast('Login to see your posts/ questions..'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      floatingActionButton: buildSpeedDial(),
      backgroundColor: Colors.white,
      appBar:  AppBar(
        elevation: 0.0,
        toolbarHeight: MediaQuery.of(context).size.height/9,
        title: Text.rich(TextSpan(
            text: "ADDICT",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: 25.0,color: Colors.black),
            children: [
              TextSpan(
                text: "X",
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 25.0,color: const Color(0xff9ad0e5),),
              )
            ]
        )),
        backgroundColor: const Color(0xfff0f0f0),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Color(0xc277d5f8),
          labelColor: Color(0xc277d5f8),
          unselectedLabelColor: Colors.grey,
          physics: NeverScrollableScrollPhysics(),
          tabs: [
            Tab(text: dailyMotivation[lang],),
            Tab(text: speakAloud[lang],),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          DailyMotivation(),
          SpeakAloud(),
        ],
      ),
    );
  }
}
