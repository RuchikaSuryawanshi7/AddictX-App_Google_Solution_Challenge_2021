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
    'Hindi':['चलना','साँस लेना','जॉगिंग','योग','नृत्य','सीढ़ियाँ चढ़ना','सायक्लिंग','तैराकी',],
    'Spanish':['Para caminar','Respiración','Trotar','Yoga','Baile','Subir escaleras','Ciclismo','Natación',],
    'German':['Gehen','Atmung','Joggen','Yoga','Tanzen','Treppen steigen','Radfahren','Schwimmen',],
    'French':['Marche','Respiration','Le jogging','Yoga','Dansante','Monter les escaliers','Cyclisme','La natation',],
    'Japanese':['ウォーキング','呼吸','ジョギング','ヨガ','ダンシング','階段登り','サイクリング','水泳',],
    'Russian':['Гулять пешком','Дыхание','Бег трусцой','Йога','Танцы','Подъем по лестнице','Езда на велосипеде','Плавание',],
    'Chinese':['步行','呼吸','跑步','瑜伽','跳舞','爬楼梯','骑自行车','游泳',],
    'Portuguese':['Andando', 'Respirando', 'Cooper', 'Ioga', 'Dançando', 'Subida de escada', 'Ciclismo', 'Natação',],
  };
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
  Map<String, List> emotions={
    'English':['Anxiety', 'Lonely', 'Sad', 'Depressed', 'Happy', 'Stress', 'Angry', 'Tired',],
    'Hindi':['चिंता', 'अकेला', 'उदास', 'डर', 'डिप्रेशन', 'तनाव', 'गुस्सा', 'थकान',],
    'Spanish':['Ansiedad', 'Solitaria', 'Triste', 'Deprimida', 'Contenta', 'Estrés', 'Enfadada', 'Cansada',],
    'German':['Angst', 'Einsam', 'Traurig', 'Deprimiert', 'glücklich', 'Stress', 'Wütend', 'Müde',],
    'French':['Anxiété', 'Seule', 'Triste', 'Déprimée', 'Heureuse', 'Stress', 'En colère', 'Fatiguée',],
    'Japanese':['不安', '寂しい', '悲しい', 'うつ病', 'ハッピー', 'ストレス', '怒っている', '疲れた',],
    'Russian':['Беспокойство', 'Грустный', 'Грустный', 'Подавленный', 'Счастливый', 'Стресс', 'Сердитый', 'Устала',],
    'Chinese':['焦虑', '孤独', '伤心', '郁闷', '快乐的', '压力', '生气的', '疲劳的',],
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
    'Hindi':'क्या आप जारी रखना चाहेंगे?',
    'Spanish':'¿Te gustaria continuar',
    'German':'Würdest du gerne weitermachen?',
    'French':"Voulez-vous continuer?",
    'Japanese':'続行しますか',
    'Russian':'Желаете ли вы продолжить?',
    'Chinese':'你想继续吗',
    'Portuguese':'Você gostaria de continuar?',
  };
  Map yes={
    'English':'Yes',
    'Hindi':'हाँ',
    'Spanish':'Sí',
    'German':'Ja',
    'French':'Oui',
    'Japanese':'はい',
    'Russian':'да',
    'Chinese':'是的',
    'Portuguese':'Sim',
  };
  Map no={
    'English':'No',
    'Hindi':'नहीं',
    'Spanish':'No',
    'German':'Nein',
    'French':'Non',
    'Japanese':'番号',
    'Russian':'Нет',
    'Chinese':'不',
    'Portuguese':'Não',
  };
  Map noPlan={
    'English':'No active plans',
    'Hindi':'कोई सक्रिय योजना नहीं',
    'Spanish':'Sin planes activos',
    'German':'Keine aktiven Pläne',
    'French':'Aucun plan actif',
    'Japanese':'アクティブな計画はありません',
    'Russian':'Нет активных планов',
    'Chinese':'没有活动计划',
    'Portuguese':'Sem planos ativos',
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
  Map openProfile={
    'English':"Opening profile...",
    'Hindi':'प्रोफ़ाइल खोली जा रही है...',
    'Spanish':'Abriendo perfil ...',
    'German':'Profil öffnen...',
    'French':"Profil d'ouverture...",
    'Japanese':'プロファイルを開く...',
    'Russian':'Открытие профиля ...',
    'Chinese':'正在打开个人资料...',
    'Portuguese':'Abrindo perfil ...',
  };
  Map hello={
    'English':"Hello ,",
    'Hindi':'नमस्ते ,',
    'Spanish':'Hola ,',
    'German':'Hallo ,',
    'French':"Bonjour ,",
    'Japanese':'こんにちは 、',
    'Russian':'Привет ,',
    'Chinese':'你好 ，',
    'Portuguese':'Olá ,',
  };
  Map editProfile={
    'English':"Edit Profile",
    'Hindi':'प्रोफ़ाइल संपादित करें',
    'Spanish':'Editar perfil',
    'German':'Profil bearbeiten',
    'French':"Editer le profil",
    'Japanese':'プロファイル編集',
    'Russian':'Редактировать профиль',
    'Chinese':'编辑个人资料',
    'Portuguese':'Editar Perfil',
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
  Map challenges={
    'English':"Challenges",
    'Hindi':'चुनौतियां',
    'Spanish':'Desafíos',
    'German':'Herausforderungen',
    'French':"Défis",
    'Japanese':'課題',
    'Russian':'Вызовы',
    'Chinese':'挑战',
    'Portuguese':'Desafios',
  };
  Map sessions={
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
  Map rewardsCoupon={
    'English':"Rewards/Coupon",
    'Hindi':'पुरस्कार/कूपन',
    'Spanish':'Recompensas / Cupón',
    'German':'Belohnungen/Gutschein',
    'French':"Récompenses/Coupon",
    'Japanese':'特典/クーポン',
    'Russian':'Награды / купон',
    'Chinese':'奖励/优惠券',
    'Portuguese':'Recompensas / cupom',
  };
  Map immunityTracker={
    'English':"Immunity Tracker",
    'Hindi':'प्रतिरक्षा ट्रैकर',
    'Spanish':'Rastreador de inmunidad',
    'German':'Immunitäts-Tracker',
    'French':"Traqueur d'immunité",
    'Japanese':'イミュニティトラッカー',
    'Russian':'Трекер иммунитета',
    'Chinese':'免疫追踪器',
    'Portuguese':'Rastreador de imunidade',
  };
  Map bmi={
    'English':"BMI Calculator",
    'Hindi':'बीएमआई कैलकुलेटर',
    'Spanish':'Calculadora de IMC',
    'German':'BMI-Rechner',
    'French':"Calculateur d'IMC",
    'Japanese':'BMI計算機',
    'Russian':'Калькулятор ИМТ',
    'Chinese':'体重指数计算器',
    'Portuguese':'Calculadora de IMC',
  };
  Map doctors={
    'English':"Doctors",
    'Hindi':'डॉक्टरों',
    'Spanish':'Doctoras',
    'German':'Ärztinnen',
    'French':"Médecins",
    'Japanese':'医者',
    'Russian':'Врачи',
    'Chinese':'医生',
    'Portuguese':'Doutoras',
  };
  Map settings={
    'English':"Settings",
    'Hindi':'सैटिंग्स',
    'Spanish':'Ajustes',
    'German':'die Einstellungen',
    'French':'Paramètres',
    'Japanese':'設定',
    'Russian':'Настройки',
    'Chinese':'设置',
    'Portuguese':'Definições'
  };
  Map logIn={
    'English':"Log In",
    'Hindi':'लॉग इन',
    'Spanish':'acceso',
    'German':'Anmeldung',
    'French':'connexion',
    'Japanese':'ログインする',
    'Russian':'авторизоваться',
    'Chinese':'登录',
    'Portuguese':'Conecte-se'
  };
  Map logOut={
    'English':"Log Out",
    'Hindi':'लॉग आउट',
    'Spanish':'Cerrar sesión',
    'German':'Ausloggen',
    'French':'Se déconnecter',
    'Japanese':'ログアウト',
    'Russian':'Выйти',
    'Chinese':'登出',
    'Portuguese':'Sair'
  };
  Map relaxingActivity={
    'English':"Relaxing Activity",
    'Hindi':'आराम की गतिविधि',
    'Spanish':'Actividad relajante',
    'German':'Entspannende Aktivität',
    'French':'Activité de détente',
    'Japanese':'リラックスアクティビティ',
    'Russian':'Расслабляющая деятельность',
    'Chinese':'放松活动',
    'Portuguese':'Atividade Relaxante',
  };
  Map addictxresources={
    'English':'AddictX Resources',
    'Hindi':'एडिक्टएक्स संसाधन',
    'Spanish':'AddictX Recursos',
    'German':'AddictX-Ressourcen',
    'French':'AddictX Ressources',
    'Japanese':'AddictXリソース',
    'Russian':'AddictX Ресурсы',
    'Chinese':'AddictX 资源',
    'Portuguese':'AddictX Recursos',
  };
  Map resourceDescription={
    'English':'Deny access to your every excuse',
    'Hindi':'अपने हर बहाने को इनकार करें',
    'Spanish':'Niega el acceso a todas tus excusas',
    'German':'Verweigere den Zugriff auf jede deiner Ausreden',
    'French':"Refuser l'accès à toutes vos excuses",
    'Japanese':'すべての言い訳へのアクセスを拒否する',
    'Russian':'Запретить доступ ко всем вашим оправданиям',
    'Chinese':'拒绝访问您的所有借口',
    'Portuguese':'Negar acesso a todas as suas desculpas',
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
  Map habit={
    'English':'HABIT BUILDING',
    'Hindi':'आदत निर्माण',
    'Spanish':'CONSTRUCCIÓN DE HÁBITOS',
    'German':'GEWOHNHEITSBAU',
    'French':"BÂTIMENT D'HABITATION",
    'Japanese':'習慣の構築',
    'Russian':'Привычка',
    'Chinese':'习惯养成',
    'Portuguese':'CONSTRUÇÃO DE HÁBITOS',
  };
  Map habitDescription={
    'English':"It's ok to be slow until you are consistent",
    'Hindi':'जब तक आप सुसंगत न हों तब तक धीमा रहना ठीक है',
    'Spanish':'Está bien ser lenta hasta que seas consistente',
    'German':'Es ist in Ordnung, langsam zu sein, bis Sie konsistent sind',
    'French':"C'est bien d'être lent jusqu'à ce que vous soyez cohérent",
    'Japanese':'あなたが一貫するまで遅くても大丈夫です',
    'Russian':'Нет ничего плохого в том, чтобы действовать медленно, пока вы не будете последовательны',
    'Chinese':'在你保持一致之前，慢点是可以的',
    'Portuguese':"Não há problema em ser lento até que você seja consistente",
  };
  Map spotlight={
    'English':"In the Spotlight",
    'Hindi':'सुर्खियों में',
    'Spanish':'En el punto de mira',
    'German':'Im Rampenlicht',
    'French':"À l'honneur",
    'Japanese':'スポットライトで',
    'Russian':'В центре внимания',
    'Chinese':'在聚光灯下',
    'Portuguese':'Nos holofotes',
  };
  Map spotLightDescription={
    'English':"Spot bargains, offers, fitness updates and so forth.",
    'Hindi':'स्पॉट बार्गेन, ऑफ़र, फिटनेस अपडेट आदि।',
    'Spanish':'Encuentra gangas, ofertas, actualizaciones de fitness, etc.',
    'German':'Entdecken Sie Schnäppchen, Angebote, Fitness-Updates und so weiter.',
    'French':"Repérez les bonnes affaires, les offres, les mises à jour de remise en forme, etc.",
    'Japanese':'掘り出し物、オファー、フィットネスの最新情報などを見つけましょう。',
    'Russian':'Найдите сделки, предложения, новости о фитнесе и т. Д.',
    'Chinese':'现货交易、优惠、健身更新等。',
    'Portuguese':'Encontre pechinchas, ofertas, atualizações de fitness e assim por diante.',
  };
  Map addictxcontest={
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
  Map contestDescription={
    'English':"Success is worth the challenges",
    'Hindi':'सफलता चुनौतियों के लायक है',
      'Spanish':'El éxito vale los desafíos',
    'German':'Der Erfolg ist die Herausforderungen wert',
    'French':'Le succès vaut les défis',
    'Japanese':'成功は挑戦する価値があります',
    'Russian':'Успех стоит проблем',
    'Chinese':'成功值得挑战',
    'Portuguese':'O sucesso vale os desafios'
  };
  Map quickSurvey={
    'English':"Quick Survey",
    'Hindi':'तुरंत सर्वेक्षण',
    'Spanish':'Encuesta rápida',
    'German':'Schnelle Umfrage',
    'French':'Sondage rapide',
    'Japanese':'迅速な調査',
    'Russian':'Быстрый опрос',
    'Chinese':'小调查',
    'Portuguese':'Pesquisa rápida'
  };
  Map feedback={
    'English':'Thanks for your Feedback !',
    'Hindi':'आपकी प्रतिक्रिया के लिए धन्यवाद !',
    'Spanish':'¡Gracias por tus comentarios',
    'German':'Vielen Dank für Ihr Feedback !',
    'French':'Merci pour vos commentaires !',
    'Japanese':'ご意見ありがとうございます ！',
    'Russian':'Спасибо за ваш отзыв !',
    'Chinese':'感谢您的反馈意见 ！',
    'Portuguese':'Obrigado pelo seu feedback !'
  };
  Map toDoToday={
    'English':"To Do Today",
    'Hindi':'आज करने के लिए',
    'Spanish':'Hacer hoy',
    'German':'Heute zu tun',
    'French':"A faire aujourd'hui",
    'Japanese':'今日すること',
    'Russian':'Сделать сегодня',
    'Chinese':'今天要做',
    'Portuguese':'Para fazer hoje'
  };
  Map toDoDescription={
    'English':"Accomplish the task  before tomorrow",
    'Hindi':'कल से पहले काम पूरा करें',
    'Spanish':'Cumplir la tarea antes de mañana.',
    'German':'Erledige die Aufgabe vor morgen',
    'French':"Accomplir la tâche avant demain",
    'Japanese':'明日までにタスクを完了する',
    'Russian':'Выполни задание до завтра',
    'Chinese':'明天之前完成任务',
    'Portuguese':'Cumpra a tarefa antes de amanhã'
  };
  Map dietPlans={
    'English':'Diet Plans',
    'Hindi':'आहार योजना',
    'Spanish':'Planes de dieta',
    'German':'Ernährungspläne',
    'French':'Régimes alimentaires',
    'Japanese':'ダイエット計画',
    'Russian':'Планы диеты',
    'Chinese':'饮食计划',
    'Portuguese':'Planos de dieta'
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
  Map suggestions={
    'English':"Suggestions",
    'Hindi':'सुझाव',
    'Spanish':'Sugerencias',
    'German':'Vorschläge',
    'French':'Suggestions',
    'Japanese':'提案',
    'Russian':'Предложения',
    'Chinese':'建议',
    'Portuguese':'Sugestões'
  };
  Map wellness={
    'English':"Doctors for your Wellness",
    'Hindi':'आपके स्वास्थ्य के लिए डॉक्टर',
    'Spanish':'Sugerencias',
    'German':'Doctores para tu Bienestar',
    'French':'Des médecins pour votre bien-être',
    'Japanese':'あなたの健康のための医者',
    'Russian':'Врачи для вашего благополучия',
    'Chinese':'为您的健康服务的医生',
    'Portuguese':'Médicos para o seu bem-estar'
  };
  Map currentPlans={
    'English':"My Current Plans",
    'Hindi':'मेरी वर्तमान योजनाएं',
    'Spanish':'Mis planes actuales',
    'German':'Meine aktuellen Pläne',
    'French':'Mes projets actuels',
    'Japanese':'私の現在の計画',
    'Russian':'Мои текущие планы',
    'Chinese':'我目前的计划',
    'Portuguese':'Meus Planos Atuais',
  };
  Map tagLine={
    'English':"We not only bestow your\nempirical knowledge....\n\nwe spread ample knowledge on social issues...",
    'Hindi':'हम न केवल आपका\nअनुभवजन्य ज्ञान प्रदान करते हैं....\n\nहम सामाजिक मुद्दों पर पर्याप्त ज्ञान फैलाते हैं...',
    'Spanish':'No solo otorgamos su \nconocimiento empírico .... \n\npartimos un amplio conocimiento sobre temas sociales ...',
    'German':'Wir vermitteln nicht nur Ihr\nempirisches Wissen....\n\nwir verbreiten umfangreiches Wissen zu gesellschaftlichen Themen...',
    'French':'Nous ne vous transmettons pas seulement vos\nconnaissances empiriques....\n\nnous diffusons de nombreuses connaissances sur les problèmes sociaux...',
    'Japanese':'私たちはあなたの\n経験的知識を授けるだけではありません.... \n\n私たちは社会問題に関する十分な知識を広めます...',
    'Russian':'Мы не только дарим вам\nнэмпирические знания ....\n\nмы распространяем обширные знания по социальным вопросам ...',
    'Chinese':'我们不仅提供您的\n经验知识......\n\n我们还传播关于社会问题的丰富知识......',
    'Portuguese':'Nós não apenas concedemos seu conhecimento\nempírico ...\n\ndivulgamos amplo conhecimento sobre questões sociais ...',
  };
  Map how={
    'English':"How's your mood..",
    'Hindi':'आपका मिजाज कैसा है..',
    'Spanish':'¿Cómo está tu estado de ánimo?',
    'German':'Wie ist deine Laune..',
    'French':'Comment est ton humeur..',
    'Japanese':'気分はどうですか。',
    'Russian':'Как настроение ..',
    'Chinese':'你的心情怎么样..',
    'Portuguese':'Como está seu humor..',
  };
  Map feel={
    'English':"Feel free to express your emotions",
    'Hindi':'अपनी भावनाओं को व्यक्त करने के लिए स्वतंत्र महसूस करें',
    'Spanish':'Siéntete libre de expresar tus emociones',
    'German':'Fühlen Sie sich frei, Ihre Gefühle auszudrücken',
    'French':"N'hésitez pas à exprimer vos émotions",
    'Japanese':'気軽に感情を表現してください',
    'Russian':'Не стесняйтесь выражать свои эмоции',
    'Chinese':'随意表达你的情绪',
    'Portuguese':'Sinta-se à vontade para expressar suas emoções',
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