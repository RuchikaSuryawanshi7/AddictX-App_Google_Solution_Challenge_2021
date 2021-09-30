import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/chattingPage.dart';
import 'package:addictx/pages/expertProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpertTile extends StatelessWidget {
  final UserModel userModel;
  ExpertTile({this.userModel});

  Map verified={
    'English':"Verified",
    'Hindi':'सत्यापित',
    'Spanish':'Verificada',
    'German':'Verifiziert',
    'French':"Vérifié",
    'Japanese':'確認済み',
    'Russian':'Проверено',
    'Chinese':'已验证',
    'Portuguese':'Verificada'
  };
  Map exp={
    'English':"years experience",
    'Hindi':'सालों का अनुभव',
    'Spanish':'Años de experiencia',
    'German':'Jahre Erfahrung',
    'French':"années d'expérience",
    'Japanese':'長年の経験',
    'Russian':'лет опыта',
    'Chinese':'年经验',
    'Portuguese':'anos de experiência',
  };
  Map msg={
    'English':"MESSAGE",
    'Hindi':'मेसइज',
    'Spanish':'MENSAJE',
    'German':'BOTSCHAFT',
    'French':"UN MESSAGE",
    'Japanese':'メッセージ',
    'Russian':'СООБЩЕНИЕ',
    'Chinese':'信息',
    'Portuguese':'MENSAGEM',
  };
  Map talk={
    'English':"Login to talk with our experts..",
    'Hindi':'हमारे विशेषज्ञों से बात करने के लिए लॉग इन करें..',
    'Spanish':'Inicia sesión para hablar con nuestras expertas ..',
    'German':'Melden Sie sich an, um mit unseren Experten zu sprechen..',
    'French':"Connectez-vous pour discuter avec nos experts.",
    'Japanese':'ログインして専門家と話してください。',
    'Russian':'Войдите, чтобы поговорить с нашими экспертами ..',
    'Chinese':'登录与我们的专家交谈..',
    'Portuguese':'Faça login para falar com nossos especialistas ..',
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Stack(
      children: [
        GestureDetector(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpertProfile(userModel: userModel,isFromBottomNavigation: false,))),
          child: Container(
            padding:EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(userModel.backgroundImg),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54.withOpacity(0.4), BlendMode.srcATop),
              ),
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(userModel.url),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 17,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(bottomRight:Radius.circular(15),bottomLeft:Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          verified[lang],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.verified_user_rounded,color: Colors.white,size: 15,)
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userModel.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        userModel.description,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${userModel.yearsOfExperience} "+exp[lang],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(Icons.thumb_up_sharp,color: const Color(0xff04bf36),size: 14.0,),
                          Text(
                            userModel.likes.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 6,
          right: 6,
          child: GestureDetector(
            onTap: () {
              currentUser!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat(
                recieverAvatar: userModel.url,
                recieverId: userModel.id,
                recieverName: userModel.username,
              ))):showToast(talk[lang]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xff9ad0e5),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                msg[lang],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
