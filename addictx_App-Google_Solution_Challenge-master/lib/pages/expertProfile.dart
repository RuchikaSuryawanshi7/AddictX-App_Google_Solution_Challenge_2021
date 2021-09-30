import 'dart:io';
import 'dart:ui';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/widgets/fullPhoto.dart';
import 'package:http/http.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/helpers/timeAgo.dart';
import 'package:addictx/models/clinicModel.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/chattingPage.dart';
import 'package:addictx/pages/editProfileOfExpert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpertProfile extends StatefulWidget {
  final UserModel userModel;
  final bool isFromBottomNavigation;
  ExpertProfile({this.userModel,this.isFromBottomNavigation});

  @override
  _ExpertProfileState createState() => _ExpertProfileState();
}

class _ExpertProfileState extends State<ExpertProfile> {
  bool isLiked=false;
  int likes=0;
  bool loading=true;
  bool loadingShare=false;
  ClinicModel clinic;
  String lang='English';
  Map loginToSupport={
    'English':'Login to support the expert',
    'Hindi':'विशेषज्ञ का समर्थन करने के लिए लॉगिन करें',
    'Spanish':'Inicia sesión para apoyar a la experta',
    'German':'Melden Sie sich an, um den Experten zu unterstützen',
    'French':"Connectez-vous pour soutenir l'expert",
    'Japanese':'エキスパートをサポートするためにログインします',
    'Russian':'Авторизуйтесь, чтобы поддержать эксперта',
    'Chinese':'登录支持专家',
    'Portuguese':'Faça login para apoiar o especialista'
  };
  Map detailsAreBeingLoaded={
    'English':"Please wait clinic details are being loaded...",
    'Hindi':'कृपया प्रतीक्षा करें क्लिनिक विवरण लोड किए जा रहे हैं...',
    'Spanish':'Espere a que se carguen los detalles de la clínica ...',
    'German':'Bitte warten Klinikdetails werden geladen...',
    'French':"Veuillez patienter les détails de la clinique sont en cours de chargement...",
    'Japanese':'クリニックの詳細が読み込まれるのをお待ちください...',
    'Russian':'Подождите, идет загрузка информации о клинике ...',
    'Chinese':'请等待诊所详情正在加载中...',
    'Portuguese':'Aguarde que os detalhes da clínica estão sendo carregados ...'
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
  Map experience={
    'English':"years experience",
    'Hindi':'सालों का अनुभव',
    'Spanish':'Años de experiencia',
    'German':'Jahre Erfahrung',
    'French':"années d'expérience",
    'Japanese':'長年の経験',
    'Russian':'лет опыта',
    'Chinese':'多年经验',
    'Portuguese':'anos de experiência'
  };
  Map appointment={
    'English':"In-Clinic Appointment",
    'Hindi':'इन-क्लिनिक अपॉइंटमेंट',
    'Spanish':'Cita en la clínica',
    'German':'Termin in der Klinik',
    'French':"Rendez-vous en clinique",
    'Japanese':'診療所での予約',
    'Russian':'Запись в клинику',
    'Chinese':'门诊预约',
    'Portuguese':'Consulta na clínica',
  };
  Map fees={
    'English':"Fees",
    'Hindi':'फीस',
    'Spanish':'Tarifa',
    'German':'Gebühren',
    'French':"Frais",
    'Japanese':'料金',
    'Russian':'Сборы',
    'Chinese':'费用',
    'Portuguese':'Honorários',
  };
  Map rating={
    'English':"Rating -",
    'Hindi':'रेटिंग -',
    'Spanish':'Calificación -',
    'German':'Bewertung -',
    'French':"Notation -",
    'Japanese':'評価-',
    'Russian':'Рейтинг -',
    'Chinese':'评分 -',
    'Portuguese':'Avaliação -',
  };
  Map timings={
    'English':"Timings -",
    'Hindi':'समय -',
    'Spanish':'Tiempos -',
    'German':'Zeiten -',
    'French':"Horaires -",
    'Japanese':'タイミング-',
    'Russian':'Сроки -',
    'Chinese':'时间——',
    'Portuguese':'Timings -',
  };
  Map contact={
    'English':"Contact Clinic",
    'Hindi':'संपर्क क्लिनिक',
    'Spanish':'Comuníquese con la Clínica',
    'German':'Kontakt Klinik',
    'French':"Contacter la clinique",
    'Japanese':'クリニックにお問い合わせください',
    'Russian':'Связаться с клиникой',
    'Chinese':'联系诊所',
    'Portuguese':'Contactar a Clínica',
  };
  Map review={
    'English':"Patient Reviews",
    'Hindi':'रोगी समीक्षा',
    'Spanish':'Reseñas de pacientes',
    'German':'Patientenbewertungen',
    'French':"Avis des patients",
    'Japanese':'患者のレビュー',
    'Russian':'Отзывы пациентов',
    'Chinese':'患者评价',
    'Portuguese':'Avaliações de pacientes',
  };
  Map declaration={
    'English':"These stories represents patient opinions and experience .They do not reflect the doctor's medical capabilities.",
    'Hindi':'ये कहानियाँ रोगी की राय और अनुभव का प्रतिनिधित्व करती हैं। वे डॉक्टर की चिकित्सा क्षमताओं को नहीं दर्शाती हैं।',
    'Spanish':'Estas historias representan las opiniones y la experiencia de los pacientes. No reflejan las capacidades médicas del médico.',
    'German':'Diese Geschichten stellen die Meinungen und Erfahrungen von Patienten dar. Sie spiegeln nicht die medizinischen Fähigkeiten des Arztes wider.',
    'French':"Ces histoires représentent les opinions et l'expérience des patients. Elles ne reflètent pas les capacités médicales du médecin.",
    'Japanese':'これらの話は、患者の意見や経験を表しています。医師の医療能力を反映していません。',
    'Russian':'Эти истории представляют мнения и опыт пациентов. Они не отражают медицинские возможности врача.',
    'Chinese':'这些故事代表了患者的意见和经验，并不反映医生的医疗能力。',
    'Portuguese':'Essas histórias representam as opiniões e experiências dos pacientes. Elas não refletem as capacidades médicas do médico.',
  };
  Map location={
    'English':"Location",
    'Hindi':'स्थान',
    'Spanish':'Localización',
    'German':'Ort',
    'French':"Emplacement",
    'Japanese':'ロケーション',
    'Russian':'Место расположения',
    'Chinese':'地点',
    'Portuguese':'Localização',
  };
  Map openAddress={
    'English':"Tap on the map for complete address",
    'Hindi':'पूरे पते के लिए मानचित्र पर टैप करें',
    'Spanish':'Toque el mapa para obtener la dirección completa',
    'German':'Tippen Sie auf die Karte für die vollständige Adresse',
    'French':"Appuyez sur la carte pour l'adresse complète",
    'Japanese':'完全な住所については、地図をタップしてください',
    'Russian':'Нажмите на карту, чтобы увидеть полный адрес',
    'Chinese':'点击地图获取完整地址',
    'Portuguese':'Toque no mapa para o endereço completo',
  };
  Map clinicPhotos={
    'English':"Clinic Photos",
    'Hindi':'क्लिनिक तस्वीरें',
    'Spanish':'Fotos De Clínica',
    'German':'Klinik Fotos',
    'French':"Photos de la clinique",
    'Japanese':'クリニックの写真',
    'Russian':'Фото клиники',
    'Chinese':'诊所照片',
    'Portuguese':'Fotos da clínica',
  };
  Map addictxverified={
    'English':"Addictx has verified all the above details. Addictx assures high quality service,on time appointment and a great experience.",
    'Hindi':'एडिक्टएक्स ने उपरोक्त सभी विवरणों को सत्यापित किया है। एडिक्टएक्स उच्च गुणवत्ता सेवा, समय पर नियुक्ति और एक शानदार अनुभव का आश्वासन देता है।',
    'Spanish':'Addictx ha verificado todos los detalles anteriores. Addictx asegura un servicio de alta calidad, citas puntuales y una gran experiencia.',
    'German':'Addictx hat alle oben genannten Details überprüft. Addictx garantiert einen qualitativ hochwertigen Service, pünktliche Termine und eine großartige Erfahrung.',
    'French':"Addictx a vérifié tous les détails ci-dessus. Addictx assure un service de haute qualité, un rendez-vous à l'heure et une grande expérience.",
    'Japanese':'Addictxは上記のすべての詳細を検証しました。 Addictxは、高品質のサービス、時間通りの予約、素晴らしい体験を保証します。',
    'Russian':'Addictx проверил все вышеперечисленные детали. Addictx гарантирует высокое качество обслуживания, своевременную встречу и отличный опыт.',
    'Chinese':'Addictx 已经验证了上述所有细节。 Addictx 保证高质量的服务、准时的预约和丰富的体验。',
    'Portuguese':'Addictx verificou todos os detalhes acima. A Addictx garante um serviço de alta qualidade, pontualidade e uma ótima experiência.',
  };
  Map loginToTalk={
    'English':"Login to talk with our experts..",
    'Hindi':'हमारे विशेषज्ञों से बात करने के लिए लॉग इन करें..',
    'Spanish':'Inicia sesión para hablar con nuestras expertas ..',
    'German':'Melden Sie sich an, um mit unseren Experten zu sprechen..',
    'French':"Photos de la clinique",
    'Japanese':'ログインして専門家と話してください。',
    'Russian':'Войдите, чтобы поговорить с нашими экспертами ..',
    'Chinese':'登录与我们的专家交谈..',
    'Portuguese':'Faça login para falar com nossos especialistas ..',
  };
  Map message={
    'English':"Message",
    'Hindi':'संदेश',
    'Spanish':'Mensaje',
    'German':'Botschaft',
    'French':"Un message",
    'Japanese':'メッセージ',
    'Russian':'Сообщение',
    'Chinese':'信息',
    'Portuguese':'Mensagem',
  };

  @override
  void initState() {
    likes=widget.userModel.likes;
    getIsLiked();
    super.initState();
  }

  getIsLiked()async
  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      isLiked=sharedPreferences.getBool(widget.userModel.id)??false;
      loading=false;
    });
  }

  incrementExpertLikes()async
  {
    if(currentUser!=null)
      {
        if(isLiked)
          {
            await usersReference.doc(widget.userModel.id).update({
              "likes":FieldValue.increment(-1),
            });
            SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
            sharedPreferences.setBool(widget.userModel.id, false);
            isLiked=false;
            likes--;
          }
        else
          {
            await usersReference.doc(widget.userModel.id).update({
              "likes":FieldValue.increment(1),
            });
            SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
            sharedPreferences.setBool(widget.userModel.id, true);
            isLiked=true;
            likes++;
          }
        setState(() {

        });
      }
    else
      showToast(loginToSupport[lang]);
  }

  void shareExpert()async{
    if(clinic!=null)
      {
        setState(() {
          loadingShare=true;
        });
        final response = await get(Uri.parse(widget.userModel.url));
        final Directory temp = await getTemporaryDirectory();
        final File imageFile = File('${temp.path}/tempImage.png');
        imageFile.writeAsBytesSync(response.bodyBytes);
        Share.shareFiles(
          ['${temp.path}/tempImage.png'],
          text: "*${widget.userModel.username}*\n${widget.userModel.description}\n${widget.userModel.yearsOfExperience} years of experience"
              + "\n\n*Clinic Details:-*\n${clinic.clinicName}\n${clinic.rating} ratings\n${clinic.timings}\n${clinic.address}"
              +"\n${clinic.contactNumber}\n\n*Location*\n${clinic.locationUrl}"
              +"\n\nGo and meet the expert at AddictX App\nhttps://play.google.com/store/apps/details?id=com.exordium.addictx",
        );
        setState(() {
          loadingShare=false;
        });
      }
    else
      showToast(detailsAreBeingLoaded[lang]);
  }

  launchUrl(String link) async
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

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      body: SafeArea(
        child: loading?Center(child: CircularProgressIndicator(),):Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.all(17.0),
                        height: MediaQuery.of(context).size.height*0.33,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.userModel.backgroundImg),
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcATop),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: MediaQuery.of(context).size.width*0.38,
                              width: MediaQuery.of(context).size.width*0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(widget.userModel.url),
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
                              height: MediaQuery.of(context).size.width*0.35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      widget.userModel.username,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    widget.userModel.description,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${widget.userModel.yearsOfExperience} ${experience[lang]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          currentUser!=null&&currentUser.id!=widget.userModel.id?incrementExpertLikes():null;
                                        },
                                        child: Icon(FontAwesomeIcons.solidThumbsUp,color: currentUser!=null&&currentUser.id==widget.userModel.id||isLiked?const Color(0xff04bf36):Colors.grey,size: 20.0,),
                                      ),
                                      Text(
                                        " "+likes.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 17.0,
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
                      widget.isFromBottomNavigation?Container():Positioned(
                          left: 5,
                          top: 10,
                          child: GestureDetector(
                            onTap: ()=>Navigator.pop(context),
                            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,size: 27,),
                          )
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            currentUser!=null&&currentUser.id==widget.userModel.id?Padding(
                              padding: const EdgeInsets.only(right:8.0),
                              child: GestureDetector(
                                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileOfExpert())),
                                child: Icon(Icons.edit,color: Colors.white,size: 30,),
                              ),
                            ):Container(),
                            GestureDetector(
                              onTap: ()=>shareExpert(),
                              child: Icon(Icons.share_outlined,color: Colors.white,size: 30,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    color: const Color(0xff9ad0e5),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.firstAid),
                        SizedBox(width: 10,),
                        Text(
                          appointment[lang],
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        Text(
                          widget.userModel.clinicFee+" "+fees[lang],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: Future.wait([clinicDetailsReference.doc(widget.userModel.id).get(),clinicDetailsReference.doc(widget.userModel.id).collection('reviews').orderBy("timeStamp",descending: true).limit(2).get()]),
                    builder: (context,snapshot){
                      if(!snapshot.hasData)
                        return Center(child: CircularProgressIndicator(),);
                      else if(!snapshot.data[0].exists)
                        return Container(
                          margin: EdgeInsets.only(top: 70),
                          child: Text(
                            "Clinic Details does not exist",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.0,
                            ),
                          ),
                        );
                      clinic=ClinicModel.fromDocument(snapshot.data[0]);
                      return Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: const Color(0xfff0f0f0),
                              padding: EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      clinic.clinicName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    rating[lang]+" "+clinic.rating.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    timings[lang]+" "+clinic.timings,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    clinic.address,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: ()=>launchUrl("tel://${clinic.contactNumber}"),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: const Color(0x4a9ad0e5),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.call),
                                    Text(
                                      contact[lang],
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              width: double.infinity,
                              color: const Color(0xfff0f0f0),
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review[lang],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                  Text(
                                    declaration[lang],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color: const Color(0x5e000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: const Color(0xffdcdcdc),
                              thickness: 2.0,
                              height: 0,
                            ),
                            Container(
                              width: double.infinity,
                              color: const Color(0xfff0f0f0),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Icon(FontAwesomeIcons.solidThumbsUp,color: const Color(0xff04bf36),size: 35,),
                                          SizedBox(width: 10,),
                                          Text(
                                            clinic.reviewPercent.toString()+"%",
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                      width: 0,
                                      thickness: 2.0,
                                      color: const Color(0xffdcdcdc),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          clinic.reviewStatement,
                                          style: TextStyle(
                                            color: const Color(0x7d000000),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data[1].docs.length,
                              separatorBuilder: (context,index)
                              {
                                if(index==0)
                                  return Divider(
                                    color: const Color(0xffdcdcdc),
                                    thickness: 2.0,
                                    height: 0,
                                  );
                                else
                                  return Container();
                              },
                              itemBuilder: (context,index){
                                return Container(
                                  padding: EdgeInsets.fromLTRB(8,0,8,8),
                                  color: const Color(0xfff0f0f0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        leading: CircleAvatar(
                                          backgroundImage: CachedNetworkImageProvider(snapshot.data[1].docs[index].data()["url"],),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              snapshot.data[1].docs[index].data()["username"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(FontAwesomeIcons.solidThumbsUp,color: const Color(0xff04bf36),size: 15,),
                                          ],
                                        ),
                                        subtitle: Text(
                                          TimeAgo.timeAgoSinceDate(snapshot.data[1].docs[index].data()["timeStamp"].toDate(),lang),
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: const Color(0x7a000000),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom:10),
                                        child: Text(
                                          snapshot.data[1].docs[index].data()["review"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 5,),
                            Container(
                              width: double.infinity,
                              color: const Color(0xfff0f0f0),
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    location[lang],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: ()=>launchUrl(clinic.locationUrl),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CachedNetworkImage(
                                        imageUrl: clinic.mapImg,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height*0.25,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2,),
                                  Text(
                                    openAddress[lang],
                                    style: TextStyle(
                                      color: const Color(0x57000000),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  SizedBox(height:5),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              width: double.infinity,
                              color: const Color(0xfff0f0f0),
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    clinicPhotos[lang],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height*0.15,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: clinic.imageUrls.length,
                                      separatorBuilder: (context,index){
                                        return SizedBox(width: 8,);
                                      },
                                      itemBuilder: (context,index){
                                        return GestureDetector(
                                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>FullPhoto(url: clinic.imageUrls[index],))),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child: CachedNetworkImage(
                                              imageUrl: clinic.imageUrls[index],
                                              width: MediaQuery.of(context).size.width*0.25,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          addictxverified[lang],
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Icon(Icons.verified_user_rounded,size: 20,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30,),
                  currentUser.id==widget.userModel.id?Container():GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      currentUser!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat(
                        recieverAvatar: widget.userModel.url,
                        recieverId: widget.userModel.id,
                        recieverName: widget.userModel.username,
                      ))):showToast(loginToTalk[lang]);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      color: const Color(0xff9ad0e5),
                      child: Text(
                        message[lang],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loadingShare?Center(child: CircularProgressIndicator(),):Container(),
          ],
        ),
      ),
    );
  }
}