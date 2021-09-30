import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/becomeAnExpert.dart';
import 'package:addictx/pages/controlNotifications.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key}) : super(key: key);
  String lang='English';

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
  Map title={
    'English':"Settings",
    'Hindi':'सैटिंग्स',
    'Spanish':'Ajustes',
    'German':'die Einstellungen',
    'French':"Paramètres",
    'Japanese':'設定',
    'Russian':'Настройки',
    'Chinese':'设置',
    'Portuguese':'Definições'
  };
  Map notification={
    'English':"Notification",
    'Hindi':'अधिसूचना',
    'Spanish':'Notificación',
    'German':'Benachrichtigung',
    'French':"Notification",
    'Japanese':'お知らせ',
    'Russian':'Уведомление',
    'Chinese':'通知',
    'Portuguese':'Notificação',
  };
  Map subtitle={
    'English':"Customize in app notification",
    'Hindi':'ऐप अधिसूचना में अनुकूलित करें',
    'Spanish':'Personalizar en la notificación de la aplicación',
    'German':'In App-Benachrichtigungen anpassen',
    'French':"Personnaliser dans la notification de l'application",
    'Japanese':'アプリ通知でカスタマイズ',
    'Russian':'Настроить в уведомлении приложения',
    'Chinese':'自定义应用内通知',
    'Portuguese':'Personalize na notificação do aplicativo',
  };
  Map invite={
    'English':"Invite Friends",
    'Hindi':'मित्रों को आमंत्रित करें',
    'Spanish':'Invitar a amigas',
    'German':'Freunde einladen',
    'French':"Inviter des amis",
    'Japanese':'友達を招待',
    'Russian':'Пригласить друзей',
    'Chinese':'邀请朋友',
    'Portuguese':'Convide amigos',
  };
  Map inviteSubTitle={
    'English':"Spread out your experience with your friends",
    'Hindi':'अपने अनुभव को अपने दोस्तों के साथ फैलाएं',
    'Spanish':'Comparte tu experiencia con tus amigos',
    'German':'Verteile deine Erfahrung mit deinen Freunden',
    'French':"Diffusez votre expérience avec vos amis",
    'Japanese':'友達との経験を広める',
    'Russian':'Поделитесь своим опытом с друзьями',
    'Chinese':'与您的朋友分享您的经验',
    'Portuguese':'Divulgue sua experiência com seus amigos',
  };
  Map help={
    'English':"Get Help",
    'Hindi':'मदद लें',
    'Spanish':'Consigue ayuda',
    'German':'Hilfe erhalten',
    'French':"Obtenir de l'aide",
    'Japanese':'助けを得ます',
    'Russian':'Получить помощь',
    'Chinese':'得到帮助',
    'Portuguese':'Obter ajuda',
  };
  Map helpSubTitle={
    'English':"Need clarification? Feel free to contact us...",
    'Hindi':'स्पष्टीकरण चाहिए? हमें संपर्क करने के लिए स्वतंत्र महसूस करें...',
    'Spanish':'¿Necesitas aclaraciones. Siéntete libre de contactarnos...',
    'German':'Klärungsbedarf? Fühlen Sie sich frei uns zu kontaktieren...',
    'French':"Besoin d'éclaircissements ? N'hésitez pas à nous contacter...",
    'Japanese':'説明が必要ですか？お気軽にお問い合わせください...',
    'Russian':'Нужны разъяснения? Не стесняйтесь связаться с нами...',
    'Chinese':'需要澄清吗？欢迎与我们联系...',
    'Portuguese':'Precisa de esclarecimento? Sinta-se livre para nos contatar...',
  };
  Map feedBack={
    'English':"Give us Feedback",
    'Hindi':'हमें प्रतिक्रिया दे',
    'Spanish':'Danos su opinión',
    'German':'Geben Sie uns eine Rückmeldung',
    'French':"Donnez-nous vos commentaires",
    'Japanese':'フィードバックをお寄せください',
    'Russian':'Оставьте отзыв',
    'Chinese':'给我们反馈',
    'Portuguese':'Dê-nos o seu feedback',
  };
  Map feedBackSubTitle={
    'English':"Spare some time to provide your views",
    'Hindi':'अपने विचार प्रदान करने के लिए कुछ समय निकालें',
    'Spanish':'Dedique algo de tiempo a proporcionar sus puntos de vista',
    'German':'Nehmen Sie sich etwas Zeit, um Ihre Ansichten mitzuteilen',
    'French':"Prenez du temps pour donner votre avis",
    'Japanese':'あなたの意見を提供するために少し時間を割いてください',
    'Russian':'Найдите время, чтобы поделиться своим мнением',
    'Chinese':'抽出一些时间发表您的看法',
    'Portuguese':'Reserve algum tempo para fornecer suas opiniões',
  };
  Map expert={
    'English':"Become an expert",
    'Hindi':'एक विशेषज्ञ बनें',
    'Spanish':'Conviértete en un experto',
    'German':'Werde Experte',
    'French':"Devenez un expert",
    'Japanese':'エキスパートになる',
    'Russian':'Стать экспертом',
    'Chinese':'成为专家',
    'Portuguese':'Torne-se um especialista',
  };
  Map expertSubTitle={
    'English':"Wanna help others in their journey?",
    'Hindi':'अपनी यात्रा में दूसरों की मदद करना चाहते हैं?',
    'Spanish':'¿Quieres ayudar a otras en su viaje?',
    'German':'Möchten Sie anderen auf ihrem Weg helfen?',
    'French':"Vous voulez aider les autres dans leur cheminement ?",
    'Japanese':'彼らの旅で他の人を助けたいですか？',
    'Russian':'Хотите помочь другим в их путешествии?',
    'Chinese':'想在旅途中帮助他人吗？',
    'Portuguese':'Quer ajudar outras pessoas em sua jornada?',
  };

  launchMail() async {
    const url = 'mailto:contact.exordium@gmail.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast(unableToLaunchUrl[lang]);
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
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: const Color(0xfff0f0f0),
      ),
      body: Column(
        children: [
          ListTile(
            tileColor: Colors.white,
            minVerticalPadding: 20,
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ControlNotification())),
            title: Text(
              notification[lang],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(subtitle[lang]),
            leading: Padding(
              padding: EdgeInsets.only(top: 5),
              child: Transform.rotate(
                angle: 70,
                child: Icon(Icons.notifications_none_rounded,size: 30.0,color: const Color(0xff9ad0e5),),
              ),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Icon(Icons.arrow_forward_ios_rounded,),
            ),
          ),
          Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
          ListTile(
            tileColor: Colors.white,
            minVerticalPadding: 20,
            onTap: (){
              Share.share("Hey,\nAddictx is a free app that you can use to build online profiles on AddictX and connect, encourage, and engage with other people in recovery. You can also use the app to make anonymous check-ins on whether or not you're sober, your mood, and what's going on in your life. These regular interactions with other people in recovery will help you stay safe and sober. The app has a variety of features that assist a person in staying sober. \n\nGo and download it from playstore.. \nhttps://play.google.com/store/apps/details?id=com.exordium.addictx",subject: 'Attendance Assistant');
            },
            title: Text(
              invite[lang],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(inviteSubTitle[lang]),
            leading: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.share,size: 30.0,color: const Color(0xff9ad0e5),),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Icon(Icons.arrow_forward_ios_rounded,),
            ),
          ),
          Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
          ListTile(
            tileColor: Colors.white,
            minVerticalPadding: 20,
            onTap: (){
              launchMail();
            },
            title: Text(
              help[lang],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(helpSubTitle[lang]),
            leading: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.help_outline_rounded,size: 30.0,color: const Color(0xff9ad0e5),),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Icon(Icons.arrow_forward_ios_rounded,),
            ),
          ),
          Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
          ListTile(
            tileColor: Colors.white,
            minVerticalPadding: 20,
            onTap: (){
              StoreRedirect.redirect(androidAppId: "com.exordium.addictx",);
            },
            title: Text(
              feedBack[lang],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(feedBackSubTitle[lang]),
            leading: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.feedback_rounded,size: 30.0,color: const Color(0xff9ad0e5),),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Icon(Icons.arrow_forward_ios_rounded,),
            ),
          ),
          Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
          ListTile(
            tileColor: Colors.white,
            minVerticalPadding: 20,
            onTap: (){
              currentUser!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>BecomeAnExpert())):showToast('Login to apply for Expert');
            },
            title: Text(
              expert[lang],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(expertSubTitle[lang]),
            leading: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(FontAwesomeIcons.xing,size: 30.0,color: const Color(0xff9ad0e5),),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Icon(Icons.arrow_forward_ios_rounded,),
            ),
          ),
          Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
        ],
      ),
    );
  }
}