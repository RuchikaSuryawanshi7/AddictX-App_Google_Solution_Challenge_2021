import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/details.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/helpers/languageCode.dart';
import 'package:addictx/helpers/quickSurveyController.dart';
import 'package:addictx/home.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/challengeList.dart';
import 'package:addictx/pages/immunity.dart';
import 'package:addictx/widgets/addictionTile.dart';
import 'package:addictx/pages/audioTherapy.dart';
import 'package:addictx/pages/language.dart';
import 'package:addictx/models/quickSurveyModel.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/Activity.dart';
import 'package:addictx/pages/addictXResources.dart';
import 'package:addictx/pages/bmiCalculator.dart';
import 'package:addictx/pages/contestHome.dart';
import 'package:addictx/pages/dietList.dart';
import 'package:addictx/pages/doYouKnow.dart';
import 'package:addictx/pages/editProfileOfExpert.dart';
import 'package:addictx/pages/expertProfile.dart';
import 'package:addictx/pages/expertsAndChats.dart';
import 'package:addictx/pages/guidedWellnessSessions.dart';
import 'package:addictx/pages/habitBuilding.dart';
import 'package:addictx/pages/signIn.dart';
import 'package:addictx/pages/toDoToday.dart';
import 'package:addictx/widgets/expertTile.dart';
import 'package:addictx/yoga/addictionplans.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:addictx/pages/notifications.dart';
import 'package:addictx/pages/rewards.dart';
import 'package:addictx/pages/settings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

String username='';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences preferences;
  SwiperController swiperController;
  ValueNotifier<int> _currentIndex = ValueNotifier(0);
  final translator = GoogleTranslator();
  Map facts;
  bool showSurvey=true;
  bool showMood=true;
  String lang='English';
  int selectedValue;
  Map<String, List> activities={
    'English':['Walking','Breathing','Jogging','Yoga','Dancing','Stair Climbing','Cycling','Swimming',],
    'Hindi':['????????????','???????????? ????????????','??????????????????','?????????','???????????????','???????????????????????? ???????????????','???????????????????????????','??????????????????',],
    'Spanish':['Para caminar','Respiraci??n','Trotar','Yoga','Baile','Subir escaleras','Ciclismo','Nataci??n',],
    'German':['Gehen','Atmung','Joggen','Yoga','Tanzen','Treppen steigen','Radfahren','Schwimmen',],
    'French':['Marche','Respiration','Le jogging','Yoga','Dansante','Monter les escaliers','Cyclisme','La natation',],
    'Japanese':['??????????????????','??????','???????????????','??????','???????????????','????????????','??????????????????','??????',],
    'Russian':['???????????? ????????????','??????????????','?????? ??????????????','????????','??????????','???????????? ???? ????????????????','???????? ???? ????????????????????','????????????????',],
    'Chinese':['??????','??????','??????','??????','??????','?????????','????????????','??????',],
    'Portuguese':['Andando', 'Respirando', 'Cooper', 'Ioga', 'Dan??ando', 'Subida de escada', 'Ciclismo', 'Nata????o',],
  };
  Map<String, List> audioTherapy={
    'English':['SOCIAL MEDIA','FAST FOOD','OVEREATING', 'GAMING','PROCRASTINATION','GAMBLING', 'SMOKING','ALCOHOL','DRUGS', 'WEED','WATCHING TV','LYING', 'COFFEE','QUARREL','NOT SLEEPING'],
    'Hindi':['????????????????????? ??????????????????','??????????????? ?????????','?????????????????? ????????????', '??????????????????','????????????????????? ????????????','?????????', '????????????????????????','????????????','??????????????????', '??????????????? ?????????','???????????? ???????????????','????????? ???????????????', '???????????????','??????????????? ???????????????','???????????? ????????????'],
    'Spanish':['MEDIOS DE COMUNICACI??N SOCIAL','COMIDA R??PIDA','COMER EN EXCESO','JUEGO DE AZAR','DILACI??N','JUEGO', 'DE FUMAR','ALCOHOL','DROGAS', 'HIERBA','VIENDO LA TELEVISI??N','MINTIENDO', 'CAF??','PELEA','NO DURMIENDO'],
    'German':['SOZIALEN MEDIEN','FASTFOOD','??BERESSEN', 'SPIELE','AUFSCHUB','SPIELEN', 'RAUCHEN','ALKOHOL','DROGEN', 'GRAS','FERNSEHEN','L??GEN', 'KAFFEE','STREIT','NICHT SCHLAFEND'],
    'French':['DES M??DIAS SOCIAUX','MAL BOUFFE','TROP MANGER', 'JEU','PROCRASTINATION',"JEUX D'ARGENT", 'FUMEUSE',"DE L'ALCOOL",'DROGUES', 'CANNABIS','REGARDER LA T??L??VISION','MENSONGE', 'CAF??','QUERELLE','NE PAS DORMIR'],
    'Japanese':['???????????????????????????','?????????????????????','??????', '?????????','??????','???????????????', '??????','???????????????','??????', '??????','????????????????????????','????????????', '????????????','??????','??????????????????'],
    'Russian':['???????????????????? ??????????','?????????????? ??????????????','????????????????????', '??????????????','????????????????????????????','???????????? ?? ???????????????? ????????', '??????????????','????????????????','??????????????????', '????????????','???????????? ??????????????????','????????????', '????????','??????????????????','???? ????????'],
    'Chinese':['????????????','??????','????????????', '??????','??????','??????', '??????','??????','??????', '??????','?????????','???', '??????','??????','?????????'],
    'Portuguese':['M??DIA SOCIAL','COMIDA R??PIDA','COMER DEMAIS', 'JOGOS','PROCRASTINA????O','JOGATINA', 'FUMAR','??LCOOL','DROGAS', 'ERVA','ASSISTINDO TV','DEITADA', 'CAF??','BRIGA','N??O DORME'],
  };
  Map<String, List> addictions={
    'English':['SOCIAL MEDIA','FAST FOOD','OVEREATING', 'GAMING','PROCRASTINATION','GAMBLING', 'SMOKING','ALCOHOL','DRUGS', 'WEED','WATCHING TV','LYING', 'COFFEE','QUARREL','NOT SLEEPING'],
    'Hindi':['????????????????????? ??????????????????','??????????????? ?????????','?????????????????? ????????????', '??????????????????','????????????????????? ????????????','?????????', '????????????????????????','????????????','??????????????????', '??????????????? ?????????','???????????? ???????????????','????????? ???????????????', '???????????????','??????????????? ???????????????','???????????? ????????????'],
    'Spanish':['MEDIOS DE COMUNICACI??N SOCIAL','COMIDA R??PIDA','COMER EN EXCESO','JUEGO DE AZAR','DILACI??N','JUEGO', 'DE FUMAR','ALCOHOL','DROGAS', 'HIERBA','VIENDO LA TELEVISI??N','MINTIENDO', 'CAF??','PELEA','NO DURMIENDO'],
    'German':['SOZIALEN MEDIEN','FASTFOOD','??BERESSEN', 'SPIELE','AUFSCHUB','SPIELEN', 'RAUCHEN','ALKOHOL','DROGEN', 'GRAS','FERNSEHEN','L??GEN', 'KAFFEE','STREIT','NICHT SCHLAFEND'],
    'French':['DES M??DIAS SOCIAUX','MAL BOUFFE','TROP MANGER', 'JEU','PROCRASTINATION',"JEUX D'ARGENT", 'FUMEUSE',"DE L'ALCOOL",'DROGUES', 'CANNABIS','REGARDER LA T??L??VISION','MENSONGE', 'CAF??','QUERELLE','NE PAS DORMIR'],
    'Japanese':['???????????????????????????','?????????????????????','??????', '?????????','??????','???????????????', '??????','???????????????','??????', '??????','????????????????????????','????????????', '????????????','??????','??????????????????'],
    'Russian':['???????????????????? ??????????','?????????????? ??????????????','????????????????????', '??????????????','????????????????????????????','???????????? ?? ???????????????? ????????', '??????????????','????????????????','??????????????????', '????????????','???????????? ??????????????????','????????????', '????????','??????????????????','???? ????????'],
    'Chinese':['????????????','??????','????????????', '??????','??????','??????', '??????','??????','??????', '??????','?????????','???', '??????','??????','?????????'],
    'Portuguese':['M??DIA SOCIAL','COMIDA R??PIDA','COMER DEMAIS', 'JOGOS','PROCRASTINA????O','JOGATINA', 'FUMAR','??LCOOL','DROGAS', 'ERVA','ASSISTINDO TV','DEITADA', 'CAF??','BRIGA','N??O DORME'],
  };
  Map<String, List> emotions={
    'English':['Anxiety', 'Lonely', 'Sad', 'Depressed', 'Happy', 'Stress', 'Angry', 'Tired',],
    'Hindi':['???????????????', '???????????????', '????????????', '??????', '????????????????????????', '????????????', '??????????????????', '????????????',],
    'Spanish':['Ansiedad', 'Solitaria', 'Triste', 'Deprimida', 'Contenta', 'Estr??s', 'Enfadada', 'Cansada',],
    'German':['Angst', 'Einsam', 'Traurig', 'Deprimiert', 'gl??cklich', 'Stress', 'W??tend', 'M??de',],
    'French':['Anxi??t??', 'Seule', 'Triste', 'D??prim??e', 'Heureuse', 'Stress', 'En col??re', 'Fatigu??e',],
    'Japanese':['??????', '?????????', '?????????', '?????????', '????????????', '????????????', '???????????????', '?????????',],
    'Russian':['????????????????????????', '????????????????', '????????????????', '??????????????????????', '????????????????????', '????????????', '????????????????', '????????????',],
    'Chinese':['??????', '??????', '??????', '??????', '?????????', '??????', '?????????', '?????????',],
    'Portuguese':['Ansiedade', 'Sozinha', 'Triste', 'Deprimida', 'Feliz', 'Estresse', 'Nervosa', 'Cansada',],
  };
  List<Duration> durationOfExercises=[
    Duration(minutes: 15),Duration(minutes: 7),
    Duration(minutes: 10),Duration(minutes: 10),
    Duration(minutes: 10),Duration(minutes: 5),
    Duration(minutes: 10),Duration(minutes: 10),
  ];
  List<Color> optionColor=[];
  Map dialogTitle={
    'English':"Would you like to continue?",
    'Hindi':'???????????? ?????? ???????????? ???????????? ??????????????????????',
    'Spanish':'??Te gustaria continuar',
    'German':'W??rdest du gerne weitermachen?',
    'French':"Voulez-vous continuer?",
    'Japanese':'??????????????????',
    'Russian':'?????????????? ???? ???? ?????????????????????',
    'Chinese':'???????????????',
    'Portuguese':'Voc?? gostaria de continuar?',
  };
  Map yes={
    'English':'Yes',
    'Hindi':'?????????',
    'Spanish':'S??',
    'German':'Ja',
    'French':'Oui',
    'Japanese':'??????',
    'Russian':'????',
    'Chinese':'??????',
    'Portuguese':'Sim',
  };
  Map no={
    'English':'No',
    'Hindi':'????????????',
    'Spanish':'No',
    'German':'Nein',
    'French':'Non',
    'Japanese':'??????',
    'Russian':'??????',
    'Chinese':'???',
    'Portuguese':'N??o',
  };
  Map noPlan={
    'English':'No active plans',
    'Hindi':'????????? ?????????????????? ??????????????? ????????????',
    'Spanish':'Sin planes activos',
    'German':'Keine aktiven Pl??ne',
    'French':'Aucun plan actif',
    'Japanese':'??????????????????????????????????????????',
    'Russian':'?????? ???????????????? ????????????',
    'Chinese':'??????????????????',
    'Portuguese':'Sem planos ativos',
  };
  Map unableToLaunchUrl={
    'English':"Something went wrong!! Please try again later",
    'Hindi':'????????? ????????? ?????? ?????????!! ????????? ????????? ?????????: ?????????????????? ????????????',
    'Spanish':'????Algo sali?? mal. Por favor, int??ntelo de nuevo m??s tarde',
    'German':'Etwas ist schief gelaufen!! Bitte versuchen Sie es sp??ter noch einmal',
    'French':"Quelque chose s'est mal pass?? !! Veuillez r??essayer plus tard",
    'Japanese':'????????????????????????????????????!!?????????????????????????????????????????????',
    'Russian':'??????-???? ?????????? ???? ??????!! ????????????????????, ?????????????????? ?????????????? ??????????',
    'Chinese':'?????????????????????????????????',
    'Portuguese':'Algo deu errado !! Por favor, tente novamente mais tarde'
  };
  Map openProfile={
    'English':"Opening profile...",
    'Hindi':'??????????????????????????? ???????????? ?????? ????????? ??????...',
    'Spanish':'Abriendo perfil ...',
    'German':'Profil ??ffnen...',
    'French':"Profil d'ouverture...",
    'Japanese':'???????????????????????????...',
    'Russian':'???????????????? ?????????????? ...',
    'Chinese':'????????????????????????...',
    'Portuguese':'Abrindo perfil ...',
  };
  Map hello={
    'English':"Hello ,",
    'Hindi':'?????????????????? ,',
    'Spanish':'Hola ,',
    'German':'Hallo ,',
    'French':"Bonjour ,",
    'Japanese':'??????????????? ???',
    'Russian':'???????????? ,',
    'Chinese':'?????? ???',
    'Portuguese':'Ol?? ,',
  };
  Map editProfile={
    'English':"Edit Profile",
    'Hindi':'??????????????????????????? ????????????????????? ????????????',
    'Spanish':'Editar perfil',
    'German':'Profil bearbeiten',
    'French':"Editer le profil",
    'Japanese':'????????????????????????',
    'Russian':'?????????????????????????? ??????????????',
    'Chinese':'??????????????????',
    'Portuguese':'Editar Perfil',
  };
  Map notification={
    'English':"Notification",
    'Hindi':'????????????????????????',
    'Spanish':'Notificaci??n',
    'German':'Benachrichtigung',
    'French':"Notification",
    'Japanese':'????????????',
    'Russian':'??????????????????????',
    'Chinese':'??????',
    'Portuguese':'Notifica????o',
  };
  Map challenges={
    'English':"Challenges",
    'Hindi':'???????????????????????????',
    'Spanish':'Desaf??os',
    'German':'Herausforderungen',
    'French':"D??fis",
    'Japanese':'??????',
    'Russian':'????????????',
    'Chinese':'??????',
    'Portuguese':'Desafios',
  };
  Map sessions={
    'English':'Sessions',
    'Hindi':'????????????',
    'Spanish':'Sesiones',
    'German':'Sitzungen',
    'French':"S??ances",
    'Japanese':'???????????????',
    'Russian':'????????????',
    'Chinese':'??????',
    'Portuguese':'Sess??es',
  };
  Map rewardsCoupon={
    'English':"Rewards/Coupon",
    'Hindi':'????????????????????????/????????????',
    'Spanish':'Recompensas / Cup??n',
    'German':'Belohnungen/Gutschein',
    'French':"R??compenses/Coupon",
    'Japanese':'??????/????????????',
    'Russian':'?????????????? / ??????????',
    'Chinese':'??????/?????????',
    'Portuguese':'Recompensas / cupom',
  };
  Map immunityTracker={
    'English':"Immunity Tracker",
    'Hindi':'?????????????????????????????? ??????????????????',
    'Spanish':'Rastreador de inmunidad',
    'German':'Immunit??ts-Tracker',
    'French':"Traqueur d'immunit??",
    'Japanese':'?????????????????????????????????',
    'Russian':'???????????? ????????????????????',
    'Chinese':'???????????????',
    'Portuguese':'Rastreador de imunidade',
  };
  Map bmi={
    'English':"BMI Calculator",
    'Hindi':'?????????????????? ???????????????????????????',
    'Spanish':'Calculadora de IMC',
    'German':'BMI-Rechner',
    'French':"Calculateur d'IMC",
    'Japanese':'BMI?????????',
    'Russian':'?????????????????????? ??????',
    'Chinese':'?????????????????????',
    'Portuguese':'Calculadora de IMC',
  };
  Map doctors={
    'English':"Doctors",
    'Hindi':'????????????????????????',
    'Spanish':'Doctoras',
    'German':'??rztinnen',
    'French':"M??decins",
    'Japanese':'??????',
    'Russian':'??????????',
    'Chinese':'??????',
    'Portuguese':'Doutoras',
  };
  Map settings={
    'English':"Settings",
    'Hindi':'????????????????????????',
    'Spanish':'Ajustes',
    'German':'die Einstellungen',
    'French':'Param??tres',
    'Japanese':'??????',
    'Russian':'??????????????????',
    'Chinese':'??????',
    'Portuguese':'Defini????es'
  };
  Map logIn={
    'English':"Log In",
    'Hindi':'????????? ??????',
    'Spanish':'acceso',
    'German':'Anmeldung',
    'French':'connexion',
    'Japanese':'??????????????????',
    'Russian':'????????????????????????????',
    'Chinese':'??????',
    'Portuguese':'Conecte-se'
  };
  Map logOut={
    'English':"Log Out",
    'Hindi':'????????? ?????????',
    'Spanish':'Cerrar sesi??n',
    'German':'Ausloggen',
    'French':'Se d??connecter',
    'Japanese':'???????????????',
    'Russian':'??????????',
    'Chinese':'??????',
    'Portuguese':'Sair'
  };
  Map relaxingActivity={
    'English':"Relaxing Activity",
    'Hindi':'???????????? ?????? ?????????????????????',
    'Spanish':'Actividad relajante',
    'German':'Entspannende Aktivit??t',
    'French':'Activit?? de d??tente',
    'Japanese':'????????????????????????????????????',
    'Russian':'?????????????????????????? ????????????????????????',
    'Chinese':'????????????',
    'Portuguese':'Atividade Relaxante',
  };
  Map addictxresources={
    'English':'AddictX Resources',
    'Hindi':'?????????????????????????????? ??????????????????',
    'Spanish':'AddictX Recursos',
    'German':'AddictX-Ressourcen',
    'French':'AddictX Ressources',
    'Japanese':'AddictX????????????',
    'Russian':'AddictX ??????????????',
    'Chinese':'AddictX ??????',
    'Portuguese':'AddictX Recursos',
  };
  Map resourceDescription={
    'English':'Deny access to your every excuse',
    'Hindi':'???????????? ?????? ??????????????? ?????? ??????????????? ????????????',
    'Spanish':'Niega el acceso a todas tus excusas',
    'German':'Verweigere den Zugriff auf jede deiner Ausreden',
    'French':"Refuser l'acc??s ?? toutes vos excuses",
    'Japanese':'??????????????????????????????????????????????????????',
    'Russian':'?????????????????? ???????????? ???? ???????? ?????????? ??????????????????????',
    'Chinese':'??????????????????????????????',
    'Portuguese':'Negar acesso a todas as suas desculpas',
  };
  Map doYouKnow={
    'English':"Do you Know ?",
    'Hindi':'???????????? ???????????? ????????? ?????? ?',
    'Spanish':'Lo sab??as ?',
    'German':'Wissen Sie ?',
    'French':'Savez-vous ?',
    'Japanese':'?????????????????????????????????',
    'Russian':'???? ???????????? ?',
    'Chinese':'????????????',
    'Portuguese':'Voc?? sabe ?',
  };
  Map learnMore={
    'English':"Tap to learn more",
    'Hindi':'???????????? ??????????????? ?????? ????????? ????????? ????????????',
    'Spanish':'Toca para obtener m??s informaci??n.',
    'German':'Tippen Sie hier, um mehr zu erfahren',
    'French':'Appuyez pour en savoir plus',
    'Japanese':'??????????????????????????????????????????',
    'Russian':'??????????????, ?????????? ???????????? ????????????',
    'Chinese':'???????????????????????????',
    'Portuguese':'Toque para saber mais',
  };
  Map habit={
    'English':'HABIT BUILDING',
    'Hindi':'????????? ?????????????????????',
    'Spanish':'CONSTRUCCI??N DE H??BITOS',
    'German':'GEWOHNHEITSBAU',
    'French':"B??TIMENT D'HABITATION",
    'Japanese':'???????????????',
    'Russian':'????????????????',
    'Chinese':'????????????',
    'Portuguese':'CONSTRU????O DE H??BITOS',
  };
  Map habitDescription={
    'English':"It's ok to be slow until you are consistent",
    'Hindi':'?????? ?????? ?????? ?????????????????? ??? ????????? ?????? ?????? ???????????? ???????????? ????????? ??????',
    'Spanish':'Est?? bien ser lenta hasta que seas consistente',
    'German':'Es ist in Ordnung, langsam zu sein, bis Sie konsistent sind',
    'French':"C'est bien d'??tre lent jusqu'?? ce que vous soyez coh??rent",
    'Japanese':'?????????????????????????????????????????????????????????',
    'Russian':'?????? ???????????? ?????????????? ?? ??????, ?????????? ?????????????????????? ????????????????, ???????? ???? ???? ???????????? ??????????????????????????????',
    'Chinese':'?????????????????????????????????????????????',
    'Portuguese':"N??o h?? problema em ser lento at?? que voc?? seja consistente",
  };
  Map spotlight={
    'English':"In the Spotlight",
    'Hindi':'??????????????????????????? ?????????',
    'Spanish':'En el punto de mira',
    'German':'Im Rampenlicht',
    'French':"?? l'honneur",
    'Japanese':'????????????????????????',
    'Russian':'?? ???????????? ????????????????',
    'Chinese':'???????????????',
    'Portuguese':'Nos holofotes',
  };
  Map spotLightDescription={
    'English':"Spot bargains, offers, fitness updates and so forth.",
    'Hindi':'??????????????? ?????????????????????, ????????????, ?????????????????? ??????????????? ????????????',
    'Spanish':'Encuentra gangas, ofertas, actualizaciones de fitness, etc.',
    'German':'Entdecken Sie Schn??ppchen, Angebote, Fitness-Updates und so weiter.',
    'French':"Rep??rez les bonnes affaires, les offres, les mises ?? jour de remise en forme, etc.",
    'Japanese':'???????????????????????????????????????????????????????????????????????????????????????????????????',
    'Russian':'?????????????? ????????????, ??????????????????????, ?????????????? ?? ?????????????? ?? ??. ??.',
    'Chinese':'??????????????????????????????????????????',
    'Portuguese':'Encontre pechinchas, ofertas, atualiza????es de fitness e assim por diante.',
  };
  Map addictxcontest={
    'English':'AddictX Contest',
    'Hindi':'?????????????????????????????? ?????????????????????????????????',
    'Spanish':'Concurso AddictX',
    'German':'AddictX-Wettbewerb',
    'French':'Concours AddictX',
    'Japanese':'AddictX???????????????',
    'Russian':'?????????????? AddictX',
    'Chinese':'AddictX ??????',
    'Portuguese':'Concurso AddictX'
  };
  Map contestDescription={
    'English':"Success is worth the challenges",
    'Hindi':'??????????????? ??????????????????????????? ?????? ???????????? ??????',
      'Spanish':'El ??xito vale los desaf??os',
    'German':'Der Erfolg ist die Herausforderungen wert',
    'French':'Le succ??s vaut les d??fis',
    'Japanese':'??????????????????????????????????????????',
    'Russian':'?????????? ?????????? ??????????????',
    'Chinese':'??????????????????',
    'Portuguese':'O sucesso vale os desafios'
  };
  Map quickSurvey={
    'English':"Quick Survey",
    'Hindi':'??????????????? ???????????????????????????',
    'Spanish':'Encuesta r??pida',
    'German':'Schnelle Umfrage',
    'French':'Sondage rapide',
    'Japanese':'???????????????',
    'Russian':'?????????????? ??????????',
    'Chinese':'?????????',
    'Portuguese':'Pesquisa r??pida'
  };
  Map feedback={
    'English':'Thanks for your Feedback !',
    'Hindi':'???????????? ????????????????????????????????? ?????? ????????? ????????????????????? !',
    'Spanish':'??Gracias por tus comentarios',
    'German':'Vielen Dank f??r Ihr Feedback !',
    'French':'Merci pour vos commentaires !',
    'Japanese':'??????????????????????????????????????? ???',
    'Russian':'?????????????? ???? ?????? ?????????? !',
    'Chinese':'???????????????????????? ???',
    'Portuguese':'Obrigado pelo seu feedback !'
  };
  Map toDoToday={
    'English':"To Do Today",
    'Hindi':'?????? ???????????? ?????? ?????????',
    'Spanish':'Hacer hoy',
    'German':'Heute zu tun',
    'French':"A faire aujourd'hui",
    'Japanese':'??????????????????',
    'Russian':'?????????????? ??????????????',
    'Chinese':'????????????',
    'Portuguese':'Para fazer hoje'
  };
  Map toDoDescription={
    'English':"Accomplish the task  before tomorrow",
    'Hindi':'?????? ?????? ???????????? ????????? ???????????? ????????????',
    'Spanish':'Cumplir la tarea antes de ma??ana.',
    'German':'Erledige die Aufgabe vor morgen',
    'French':"Accomplir la t??che avant demain",
    'Japanese':'???????????????????????????????????????',
    'Russian':'?????????????? ?????????????? ???? ????????????',
    'Chinese':'????????????????????????',
    'Portuguese':'Cumpra a tarefa antes de amanh??'
  };
  Map dietPlans={
    'English':'Diet Plans',
    'Hindi':'???????????? ???????????????',
    'Spanish':'Planes de dieta',
    'German':'Ern??hrungspl??ne',
    'French':'R??gimes alimentaires',
    'Japanese':'?????????????????????',
    'Russian':'?????????? ??????????',
    'Chinese':'????????????',
    'Portuguese':'Planos de dieta'
  };
  Map dietDescription={
    'English':"Food will decide your future",
    'Hindi':'???????????? ?????? ??????????????? ???????????? ??????????????????',
    'Spanish':'La comida decidir?? tu futuro',
    'German':'Essen entscheidet ??ber deine Zukunft',
    'French':'La nourriture d??cidera de votre avenir',
    'Japanese':'??????????????????????????????????????????',
    'Russian':'?????? ?????????? ???????? ??????????????',
    'Chinese':'????????????????????????',
    'Portuguese':'A comida vai decidir o seu futuro'
  };
  Map suggestions={
    'English':"Suggestions",
    'Hindi':'???????????????',
    'Spanish':'Sugerencias',
    'German':'Vorschl??ge',
    'French':'Suggestions',
    'Japanese':'??????',
    'Russian':'??????????????????????',
    'Chinese':'??????',
    'Portuguese':'Sugest??es'
  };
  Map wellness={
    'English':"Doctors for your Wellness",
    'Hindi':'???????????? ??????????????????????????? ?????? ????????? ??????????????????',
    'Spanish':'Sugerencias',
    'German':'Doctores para tu Bienestar',
    'French':'Des m??decins pour votre bien-??tre',
    'Japanese':'????????????????????????????????????',
    'Russian':'?????????? ?????? ???????????? ????????????????????????',
    'Chinese':'??????????????????????????????',
    'Portuguese':'M??dicos para o seu bem-estar'
  };
  Map currentPlans={
    'English':"My Current Plans",
    'Hindi':'???????????? ????????????????????? ?????????????????????',
    'Spanish':'Mis planes actuales',
    'German':'Meine aktuellen Pl??ne',
    'French':'Mes projets actuels',
    'Japanese':'?????????????????????',
    'Russian':'?????? ?????????????? ??????????',
    'Chinese':'??????????????????',
    'Portuguese':'Meus Planos Atuais',
  };
  Map tagLine={
    'English':"We not only bestow your\nempirical knowledge....\n\nwe spread ample knowledge on social issues...",
    'Hindi':'?????? ??? ???????????? ????????????\n??????????????????????????? ??????????????? ?????????????????? ???????????? ?????????....\n\n?????? ????????????????????? ????????????????????? ?????? ???????????????????????? ??????????????? ?????????????????? ?????????...',
    'Spanish':'No solo otorgamos su \nconocimiento emp??rico .... \n\npartimos un amplio conocimiento sobre temas sociales ...',
    'German':'Wir vermitteln nicht nur Ihr\nempirisches Wissen....\n\nwir verbreiten umfangreiches Wissen zu gesellschaftlichen Themen...',
    'French':'Nous ne vous transmettons pas seulement vos\nconnaissances empiriques....\n\nnous diffusons de nombreuses connaissances sur les probl??mes sociaux...',
    'Japanese':'????????????????????????\n??????????????????????????????????????????????????????.... \n\n??????????????????????????????????????????????????????????????????...',
    'Russian':'???? ???? ???????????? ?????????? ??????\n?????????????????????????? ???????????? ....\n\n???? ???????????????????????????? ???????????????? ???????????? ???? ???????????????????? ???????????????? ...',
    'Chinese':'????????????????????????\n????????????......\n\n????????????????????????????????????????????????......',
    'Portuguese':'N??s n??o apenas concedemos seu conhecimento\nemp??rico ...\n\ndivulgamos amplo conhecimento sobre quest??es sociais ...',
  };
  Map how={
    'English':"How's your mood..",
    'Hindi':'???????????? ??????????????? ???????????? ??????..',
    'Spanish':'??C??mo est?? tu estado de ??nimo?',
    'German':'Wie ist deine Laune..',
    'French':'Comment est ton humeur..',
    'Japanese':'???????????????????????????',
    'Russian':'?????? ???????????????????? ..',
    'Chinese':'?????????????????????..',
    'Portuguese':'Como est?? seu humor..',
  };
  Map feel={
    'English':"Feel free to express your emotions",
    'Hindi':'???????????? ????????????????????? ?????? ?????????????????? ???????????? ?????? ????????? ???????????????????????? ??????????????? ????????????',
    'Spanish':'Si??ntete libre de expresar tus emociones',
    'German':'F??hlen Sie sich frei, Ihre Gef??hle auszudr??cken',
    'French':"N'h??sitez pas ?? exprimer vos ??motions",
    'Japanese':'??????????????????????????????????????????',
    'Russian':'???? ?????????????????????? ???????????????? ???????? ????????????',
    'Chinese':'????????????????????????',
    'Portuguese':'Sinta-se ?? vontade para expressar suas emo????es',
  };

  @override
  void initState() {
    swiperController=SwiperController();
    getValue();
    super.initState();
  }

  @override
  void dispose()
  {
    swiperController?.dispose();
    _currentIndex?.dispose();
    super.dispose();
  }

  Future getDoctors()async{
    String key = usersReference.doc().id;
    QuerySnapshot querySnapshot= await usersReference.where("isExpert",isEqualTo: true).where("id",isGreaterThanOrEqualTo: key).limit(3).get();
    if(querySnapshot==null||querySnapshot.docs.length<1)
    {
      querySnapshot= await usersReference.where("isExpert",isEqualTo: true).where("id",isLessThanOrEqualTo: key).limit(3).get();
    }
    return querySnapshot;
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

  getValue()async
  {
    preferences=await SharedPreferences.getInstance();
    setState(() {
      username=preferences.getString('name')??"";
    });
  }

  void logOutDialog(BuildContext context,){
    var alertDialog=AlertDialog(
      title: Text(dialogTitle[lang]),
      actions: <Widget>[
        RaisedButton(
          color: Color(0xff9ad0e5),
          child: Text(yes[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          onPressed: (){
            Navigator.pop(context);
            logoutUser(context);
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
        ),
        RaisedButton(
          color: Color(0xff9ad0e5),
          child: Text(no[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          onPressed: (){
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialog;
        });
  }
  logoutUser(BuildContext context) async
  {
    final GoogleSignIn googleSignIn=GoogleSignIn();
    bool isLoggedInWithGmail=await googleSignIn.isSignedIn();
    if(isLoggedInWithGmail)
    {
      googleSignIn.signOut();
      _auth.signOut();
    }
    else
      signOut();
    currentUser=null;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }
  Future signOut() async {
    try {
      SharedPreferences preferences=await SharedPreferences.getInstance();
      preferences.setBool('loggedIn', false);
      preferences.setString('email', null);
      preferences.setString('password', null);
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Center noPlanWidget()
  {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/noPlans.jpeg', height: MediaQuery.of(context).size.width*2/3,),
          Text(noPlan[lang],style: GoogleFonts.gugi(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xa1000000),
              fontSize: 18.0,
            ),
          ),),
        ],
      ),
    );
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

  void navigateSpotlight(Map data)async{
    if(data['type']=="expertProfile")
      {
        showToast(openProfile[lang]);
        DocumentSnapshot doc=await usersReference.doc(data['expertId']).get();
        UserModel userModel=UserModel.fromDocument(doc);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpertProfile(userModel: userModel,isFromBottomNavigation: false,)));
      }
    else if(data['type']=="externalLink")
      {
        launchLink(data['externalLink']);
      }
  }

  void navigatePromotion(int index)async
  {
    if(promotion[index]['type']=="sessions")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>GuidedWellnessSessions()));
    }
    else if(promotion[index]['type']=="contests")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ContestHome()));
    }
    else if(promotion[index]['type']=="dietPlan")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DietList()));
    }
    else if(promotion[index]['type']=="audioTherapy")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AudioTherapy(audioTherapy: audioTherapy,)));
    }
    else if(promotion[index]['type']=="yoga")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>YogaPage()));
    }
    else if(promotion[index]['type']=="doctors")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpertsAndChats()));
    }
    else if(promotion[index]['type']=="externalLink")
    {
      launchLink(promotion[index]['externalLink']);
    }
  }

  void _submitSurveyResponse(String question, String option, StateSetter updateState, int index) {
    preferences.setString('quickSurveyQuestion', question);
    updateState((){
      optionColor[index]=const Color(0xff9ad0e5);
    });
    Future.delayed(Duration(milliseconds: 300),(){
      updateState((){
        optionColor[index]=Colors.white;
        showSurvey=false;
      });
    });

    QuickSurveyForm surveyForm = QuickSurveyForm(
      question,
      option,
    );

    QuickSurveyController quickSurveyController = QuickSurveyController((String response){
      print("Response: $response");
      if(response == QuickSurveyController.STATUS_SUCCESS){
        print("response saved!!");
      } else {
        print("error");
      }
    });

    // Submit 'feedbackForm' and save it in Google Sheet

    quickSurveyController.submitForm(surveyForm);
  }


  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpertsAndChats())),
        shape: CircleBorder(
          side: BorderSide(width: 4.0, color: Colors.white, style: BorderStyle.solid),
        ),
        backgroundColor: Color(0xff9ad0e5),
        child: Icon(Icons.comment_rounded,size: 30.0,),
      ),
      appBar:AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xfff0f0f0),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text.rich(TextSpan(
          text: "ADDICT",
          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 25.0,color: Colors.black),
          children: [
            TextSpan(
              text: "X",
              style: TextStyle(color: const Color(0xff9ad0e5),),
            ),
          ],
        )),
        actions: [
          IconButton(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Language())),
            icon: Icon(FontAwesomeIcons.globe,size: 26,),
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(FontAwesomeIcons.stethoscope,size: 26,),
          ),
        ],
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width*2/3,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    color: Colors.white,
                    child: DrawerHeader(
                      padding: EdgeInsets.zero,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50,
                            color: const Color(0xfff0f0f0),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 25,),
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                child: currentUser!=null&&currentUser.url!=''?Container(
                                  height: MediaQuery.of(context).size.height/4.5,
                                  width: MediaQuery.of(context).size.height/5,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xff9ad0e5),width: 3),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(currentUser.url),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ):Container(
                                    height: MediaQuery.of(context).size.height/4.5,
                                    width: MediaQuery.of(context).size.height/5,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue,width: 2),
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: Colors.white,
                                    ),
                                    child: Icon(Icons.person,color: Colors.black26,size: 150,),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal:45.0,vertical: 10),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text.rich(
                                    TextSpan(
                                        text: hello[lang]+" ",
                                        style: TextStyle(
                                          color: const Color(0xff919191),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: currentUser!=null?currentUser.username:username,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              )
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(color: Colors.white,),
                    ),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                  currentUser!=null&&currentUser.isExpert?ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileOfExpert()));
                    },
                    title: Text(
                      editProfile[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ):Container(),
                  currentUser!=null&&currentUser.isExpert?Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),):Container(),
                  ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications()));
                    },
                    title: Text(
                      notification[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                  ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChallengeList()));
                    },
                    title: Text(
                      challenges[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                  ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>GuidedWellnessSessions()));
                    },
                    title: Text(
                      sessions[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                  ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Rewards()));
                    },
                    title: Text(
                      rewardsCoupon[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                  ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WakeUpp()));
                    },
                    title: Text(
                      immunityTracker[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                  ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BMICalculator()));
                    },
                    title: Text(
                      bmi[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                  ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpertsAndChats()));
                    },
                    title: Text(
                      doctors[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                  ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage()));
                    },
                    title: Text(
                      settings[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                  currentUser==null?ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      bottomSheetForSignIn(context);
                    },
                    title: Text(
                      logIn[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ):
                  ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      Navigator.pop(context);
                      logOutDialog(context,);
                    },
                    title: Text(
                      logOut[lang],
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              promotion.isNotEmpty?Container(
                height: MediaQuery.of(context).size.height/4.7,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Swiper(
                  autoplay: true,
                  autoplayDelay: 4000,
                  controller: SwiperController(),
                  itemCount: promotion.length,
                  itemBuilder: (context,index)
                  {
                    return GestureDetector(
                      onTap: ()=>navigatePromotion(index),
                      child: CachedNetworkImage(
                        imageUrl: promotion[index]['url'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                      ),
                    );
                  },
                ),
              ):Container(),
              SizedBox(height: 15.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Text(
                  relaxingActivity[lang],
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0,
                    color: const Color(0x8c000000),
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              Container(
                width: double.infinity,
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: activities[lang].length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Activity(
                        activityHeading: activities['English'][index],
                        duration: durationOfExercises[index],
                      ))),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 38,
                              backgroundImage: AssetImage('assets/relaxingActivities/${activities['English'][index]}.jpg'),
                              child: Icon(Icons.play_arrow_rounded,color: Colors.white,size: 35,),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              activities[lang][index],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  addictxresources[lang],
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0,
                    color: const Color(0x8c000000),
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddictXResources())),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width*0.33,
                          width: double.infinity,
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.bottomLeft,
                          decoration: BoxDecoration(
                            color: const Color(0x1a9ad0e5),
                            image: DecorationImage(
                              image: AssetImage('assets/addictXResources.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(
                            resourceDescription[lang],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 18.0,
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
                ),
              ),
              SizedBox(height: 20,),
              FutureBuilder(
                future: getFacts(),
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                    return Container(
                      height: MediaQuery.of(context).size.height*0.35,
                      width: double.infinity,
                      color: const Color(0xfff0f0f0),
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
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Text(
                  habit[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0x8c000000),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: GestureDetector(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>HabitBuilding())),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width*0.33,
                          width: double.infinity,
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color(0x1a9ad0e5),
                            image: DecorationImage(
                              image: AssetImage('assets/habitBuilding.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(
                            habitDescription[lang],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 18.0,
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
                ),
              ),
              SizedBox(height: 35.0,),
              Container(
                width: double.infinity,
                color: const Color(0xff9ad0e5),
                padding: EdgeInsets.only(left: 8,top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spotlight[lang],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                          fontSize: 17.0,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        spotLightDescription[lang],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    FutureBuilder(
                      future: spotlightReference.doc("spotlight").get(),
                      builder: (context,snapshot){
                        if(!snapshot.hasData)
                          return Container(
                            height: MediaQuery.of(context).size.height*0.22,
                            width: double.infinity,
                            child: Center(child: CircularProgressIndicator(),),
                          );
                        List<Map> data=List.from(snapshot.data['data']);
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height*0.24,
                              child: Swiper(
                                controller: swiperController,
                                itemCount: data.length,
                                autoplay: true,
                                autoplayDelay: 4000,
                                loop: true,
                                viewportFraction: 0.8,
                                onIndexChanged: (index)=>_currentIndex.value=index,
                                itemBuilder: (context,index){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: GestureDetector(
                                      onTap: ()=>navigateSpotlight(data[index]),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        child: Container(
                                          color: const Color(0xffe4e6e7),
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                                            imageUrl: data[index]['url'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 15,),
                            Center(
                              child: ValueListenableBuilder(
                                valueListenable: _currentIndex,
                                child: Container(),
                                builder: (BuildContext context, int value, Widget child){
                                  return AnimatedSmoothIndicator(
                                    activeIndex: value,
                                    count: data.length,
                                    effect: ScrollingDotsEffect(
                                      activeDotColor: Colors.white,
                                      dotColor: const Color(0xffe4e6e7),
                                      dotHeight: 8.0,
                                      dotWidth: 8.0,
                                    ),
                                    onDotClicked: (index){
                                      _currentIndex.value=index;
                                      swiperController.move(index);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 25,),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Text(
                  addictxcontest[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0x8c000000),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: GestureDetector(
                  onTap:  ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ContestHome())),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width*0.33,
                          width: double.infinity,
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color(0x1a9ad0e5),
                            image: DecorationImage(
                              image: AssetImage('assets/contest.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(
                            contestDescription[lang],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 18.0,
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
                ),
              ),
              SizedBox(height: 30.0,),
              FutureBuilder(
                future: quickSurveyReference.doc('survey').get(),
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                    return Container();
                  else if(!snapshot.data.exists)
                    return Container();
                  List<String> options=List.from(snapshot.data['options']);
                  for(int i=0;i<options.length;i++)
                    {
                      optionColor.add(Colors.white);
                    }
                  String question=preferences.getString('quickSurveyQuestion')??"";
                  return question==snapshot.data['question']?Container():StatefulBuilder(
                    builder: (context, updateState)
                    {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              color: const Color(0xfff0f0f0),
                            ),
                            child: showSurvey?Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15,),
                                Text(
                                  quickSurvey[lang],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 23.0,
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  snapshot.data['question'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0x99000000),
                                  ),
                                ),
                                SizedBox(height: 15,),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  separatorBuilder: (context,index)=>SizedBox(height: 15,),
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: ()=>_submitSurveyResponse(snapshot.data['question'], options[index], updateState, index),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(width: 1.0, color: const Color(0xff9ad0e5)),
                                          color: optionColor[index],
                                        ),
                                        child: Text(
                                          options[index],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20,),
                              ],
                            ):Column(
                              children: [
                                SizedBox(height: 25,),
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: const Color(0xff9ad0e5),
                                  child: Icon(Icons.check,color: Colors.white,size: 70,),
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  feedback[lang],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                                SizedBox(height: 25,),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.0,),
                        ],
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Text(
                  toDoToday[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0x8c000000),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ToDoToday())),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width*0.33,
                          width: double.infinity,
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color(0x1a9ad0e5),
                            image: DecorationImage(
                              image: AssetImage('assets/toDoToday.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(
                            toDoDescription[lang],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 18.0,
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
                ),
              ),
              SizedBox(height: 30.0,),
              StatefulBuilder(
                builder: (context,updateState){
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    width: double.infinity,
                    color: const Color(0xfff0f0f0),
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: showMood?Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text(
                          how[lang],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(height: 3,),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            feel[lang],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 10,
                          crossAxisCount: 4,
                          children: List.generate(8, (index){
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    updateState((){
                                      showMood=false;
                                      selectedValue=index;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage('assets/mood/${emotions['English'][index]}.png'),
                                  ),
                                ),
                                Text(
                                  emotions[lang][index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        SizedBox(height: 15,),
                      ],
                    ):Container(
                      padding: EdgeInsets.symmetric(horizontal:15.0,vertical: 60),
                      child: Text.rich(
                        TextSpan(
                            text: '"',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff9ad0e5),
                            ),
                            children: [
                              TextSpan(
                                text: moodDetails[lang][emotions['English'][selectedValue]],
                                style: TextStyle(color: Colors.black,fontSize: 18,),
                              ),
                              TextSpan(
                                text: '"',
                              ),
                            ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Text(
                  dietPlans[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0x8c000000),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DietList())),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width*0.33,
                          width: double.infinity,
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color(0x1a9ad0e5),
                            image: DecorationImage(
                              image: AssetImage('assets/dietPlan.png'),
                              fit: BoxFit.cover,
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
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 18,),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                color: const Color(0xfff0f0f0),
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestions[lang],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.0,
                              color: const Color(0x5e000000),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            wellness[lang],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    FutureBuilder(
                      future: getDoctors(),
                      builder: (context,snapshot){
                        if(!snapshot.hasData)
                          return Container(
                            height: MediaQuery.of(context).size.height*0.4,
                            width: double.infinity,
                            color: const Color(0xfff0f0f0),
                            child: Center(child: CircularProgressIndicator(),),
                          );
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context,index){
                            return SizedBox(height: 15,);
                          },
                          itemBuilder: (context,index){
                            UserModel userModel=UserModel.fromDocument(snapshot.data.docs[index]);
                            return currentUser==null||userModel.id!=currentUser.id?ExpertTile(userModel: userModel,):Container();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Text(
                  currentPlans[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
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
                  return plans.isEmpty?noPlanWidget():ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: plans.length,
                    itemBuilder: (context,index)
                    {
                      return AddictionTile(
                        heading: plans[index]['planName'],
                        fileName: getFileName(plans[index]['planName']),
                        addictionName: addictions[lang][addictions['English'].indexOf(plans[index]['planName'])],
                        timestamp: plans[index]['startTime'],
                      );
                    },
                  );
                },
              ):noPlanWidget(),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                color: const Color(0xfff0f0f0),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/addictx.png',width: MediaQuery.of(context).size.width*0.45,),
                    SizedBox(height: 10,),
                    Text(
                      tagLine[lang],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25.0,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "\u00a9 Tech Exordium",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 100,),
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

String getFileName(String planName)
{
  switch(planName)
  {
    case "SOCIAL MEDIA":
      return 'socialMedia';
      break;
    case "FAST FOOD":
      return 'fastFood';
      break;
    case "OVEREATING":
      return 'overeating';
      break;
    case "GAMING":
      return 'gaming';
      break;
    case "PROCRASTINATION":
      return 'procrastination';
      break;
    case "GAMBLING":
      return 'gambling';
      break;
    case "SMOKING":
      return 'smoking';
      break;
    case "ALCOHOL":
      return 'alcohol';
      break;
    case "DRUGS":
      return 'drugs';
      break;
    case "WEED":
      return 'weed';
      break;
    case "WATCHING TV":
      return 'watchingTv';
      break;
    case "LYING":
      return 'lying';
      break;
    case "COFFEE":
      return 'coffee';
      break;
    case "QUARREL":
      return 'quarrel';
      break;
    case "NOT SLEEPING":
      return 'notSleeping';
      break;
    default:
      return 'socialMedia';
  }
}