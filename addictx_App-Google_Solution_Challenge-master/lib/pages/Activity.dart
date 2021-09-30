import 'package:addictx/helpers/details.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/widgets/curvePainter.dart';
import 'package:addictx/widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';



class Activity extends StatefulWidget {
  final Duration duration;
  final String activityHeading;
  final double size=80.0;
  final Color color=const Color(0x5c9ad0e5);
  Activity({this.duration,this.activityHeading});

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> with TickerProviderStateMixin {
  AnimationController _controller;
  Widget timer;
  Stopwatch watch;
  String lang='English';
  Map<String, List> activityName={
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

  Map left={
    'English':'LEFT',
    'Hindi':'बाकी',
    'Spanish':'IZQUIERDA',
    'German':'LINKS',
    'French':'GAUCHE',
    'Japanese':'左',
    'Russian':'ВЛЕВО',
    'Chinese':'还剩',
    'Portuguese':'ESQUERDO',
  };

  Map dialogHeading={
    'English':'Are you sure you\nwanna exit?',
    'Hindi':'क्या आप वाकई व्यायाम को\nछोड़ना चाहते हैं?',
    'Spanish':'¿Estás seguro de\nque quieressalir',
    'German':'Bist du sicher, dass du\naussteigen willst?',
    'French':'es-tu sûr de\nvouloir sortir',
    'Japanese':'終 了して も\nよろしいです か',
    'Russian':'Вы уверены, что\nхотите выйти?',
    'Chinese':'你 确 定\n要 退 出吗？',
    'Portuguese':'Tem certeza que\nquer sair?',
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

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    assignTimer();
    watch = Stopwatch()..start();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  assignTimer()
  {
    timer=CountdownTimer(
      onEnd: onCompleteActivity,
      endTime: DateTime.now().add(widget.duration).millisecondsSinceEpoch,
      widgetBuilder: (context, CurrentRemainingTime time) {
        if (time == null) {
          return Text(
            '00:00',
            style: GoogleFonts.gugi(
              textStyle: TextStyle(
                  color:  const Color(0xff4b4a4a),
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0
              ),
            ),
          );
        }
        return Text.rich(
            TextSpan(
                text: '',
                children: [
                  TextSpan(
                    text: '${time.min==null?00:time.min}:${time.sec.toString().length<=1?'0${time.sec}':time.sec}',
                    style: GoogleFonts.gugi(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 45.0,
                        color:  const Color(0xff4b4a4a),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: ' '+left[lang],
                    style: GoogleFonts.gugi(
                      textStyle: TextStyle(
                        fontSize: 17.0,
                        color:  const Color(0xff4b4a4a),
                      ),
                    ),
                  ),
                ]
            )
        );
      },
    );
  }

  Widget _button() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: <Color>[
                    widget.color,
                    Color.lerp(widget.color, Colors.black, .05)
                  ],
                ),
              ),
              child: ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: const CurveWave(),
                    ),
                  ),
              ),
            ),
          ),
        ),
        Material(
          shape: CircleBorder(),
          elevation: 4.0,
          color: const Color(0xff9ad0e5),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xff9ad0e5),
            child: Icon(icon(), size: 37,color: Colors.white,),
          ),
        ),
      ],
    );
  }

  void onCompleteActivity()async
  {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [500, 1000, 500, 2000], intensities: [1, 255]);
    }
    SharedPreferences prefs=await SharedPreferences.getInstance();
    double num=prefs.getDouble(widget.activityHeading+'num')??0.0;
    double den=prefs.getDouble(widget.activityHeading+'den')??0.0;
    num++;
    den++;
    prefs.setDouble(widget.activityHeading+'num', num);
    prefs.setDouble(widget.activityHeading+'den', den);
    _controller.stop();
  }

  save()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    double num=prefs.getDouble(widget.activityHeading+'num')??0.0;
    double den=prefs.getDouble(widget.activityHeading+'den')??0.0;
    double div=double.parse((watch.elapsed.inSeconds/widget.duration.inSeconds).toStringAsFixed(2));
    num+=div;
    den++;
    prefs.setDouble(widget.activityHeading+'num', num);
    prefs.setDouble(widget.activityHeading+'den', den);
  }

  void dialog(BuildContext context){
    var alertDialog=Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0.0,
      child: Container(
        height: MediaQuery.of(context).size.height*0.21,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                dialogHeading[lang],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: ()async{
                        await save();
                        _controller.stop();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(top:10),
                        decoration: BoxDecoration(
                          color: Color(0xff9ad0e5),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0)),
                        ),
                        child: Text(
                          yes[lang],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top:10.0),
                        decoration: BoxDecoration(
                          color: Color(0xff9ad0e5),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0)),
                        ),
                        child: Text(
                          no[lang],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
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
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return alertDialog;
        });
  }

  Future<bool> onBackPress()
  {
    if(_controller.isAnimating)
      dialog(context);
    else
      Navigator.pop(context);
    return Future.value(false);
  }

  IconData icon()
  {
    switch (widget.activityHeading) {
      case "Walking":
        return FontAwesomeIcons.walking;
        break;
      case "Breathing":
        return FontAwesomeIcons.wind;
        break;
      case "Jogging":
        return FontAwesomeIcons.running;
        break;
      case "Yoga":
        return Icons.accessibility_new_rounded;
        break;
      case "Dancing":
        return Dance.dance;
        break;
      case "Stair Climbing":
        return Stair.stair;
        break;
      case "Cycling":
        return FontAwesomeIcons.biking;
        break;
      case "Swimming":
        return FontAwesomeIcons.swimmer;
        break;
      default:
        return Icons.accessibility_new_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: GestureDetector(
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
            onTap: ()=>dialog(context),
          ),
          backgroundColor: const Color(0xfff0f0f0),
        ),
        body: Column(
          children: [
            SizedBox(height: 50,),
            Text(
              activityName[lang][activityName['English'].indexOf(widget.activityHeading)],
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15,),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width/15,),
                    Center(
                      child: CustomPaint(
                        painter: CirclePainter(
                          _controller,
                          color: widget.color,
                        ),
                        child: SizedBox(
                          width: widget.size * 3.6,
                          height: widget.size * 3.6,
                          child: _button(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      activityDetails[lang][widget.activityHeading],
                      style: TextStyle(
                        color:  const Color(0x80000000),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    timer,
                    Spacer(),
                    LinearPercentIndicator(
                      lineHeight: 8,
                      animationDuration: widget.duration.inMilliseconds,
                      animateFromLastPercent: true,
                      backgroundColor: const Color(0xfff0f0f0),
                      progressColor: const Color(0xff9ad0e5),
                      percent: 1.0,
                      animation: true,
                    ),
                    SizedBox(height: 20,),
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}