import 'package:addictx/languageNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelaxationActivitiesTracking extends StatefulWidget {
  @override
  _RelaxationActivitiesTrackingState createState() => _RelaxationActivitiesTrackingState();
}

class _RelaxationActivitiesTrackingState extends State<RelaxationActivitiesTracking> {
  bool loading=true;
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
  List<String> performedActivities=[];
  List<double> percent=[];
  List<double> firstHalfPercentage=[];
  List<double> secondHalfPercentage=[];
  List<String> firstHalfActivities=[];
  List<String> secondHalfActivities=[];
  String lang='English';
  Map title={
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
  Map noActivities={
    'English':"No relaxation activities done so far...",
    'Hindi':'अभी तक कोई रिलैक्सेशन एक्टिविटी नहीं की गई...',
    'Spanish':'No se han realizado actividades de relajación hasta ahora ...',
    'German':'Bisher keine Entspannungsaktivitäten...',
    'French':"Aucune activité de détente effectuée jusqu'à présent...",
    'Japanese':'これまでのところリラクゼーション活動は行われていません...',
    'Russian':'Никаких релаксационных мероприятий пока не проводилось ...',
    'Chinese':'到目前为止没有做过放松活动...',
    'Portuguese':'Nenhuma atividade de relaxamento realizada até agora ...',
  };

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    int i=0;
    activities['English'].forEach((activity) {
      i++;
      double num=sharedPreferences.getDouble(activity+'num')??0.0;
      double den=sharedPreferences.getDouble(activity+'den')??0.0;
      if(num!=0.0||den!=0.0)
        {
          percent.add(double.parse((num/den).toStringAsFixed(2)));
          performedActivities.add(activities[lang][i]);
        }
    });
    percent.removeWhere((element) => element.isNaN||element==0.0);
    if(percent.isNotEmpty)
    {
      int mid=percent.length~/2;
      for(int i=0;i<mid;i++)
      {
        firstHalfActivities.add(performedActivities[i]);
        firstHalfPercentage.add(percent[i]);
      }
      for(int i=mid;i<percent.length;i++)
      {
        secondHalfActivities.add(performedActivities[i]);
        secondHalfPercentage.add(percent[i]);
      }
    }
    setState(() {
      loading=false;
    });
  }

  Padding activityBlock({double percent,String activityName,}){
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: MediaQuery.of(context).size.width/1.8,
        width: MediaQuery.of(context).size.width/1.5,
        child: Card(
          color: Colors.white,
          elevation: 12.0,
          shadowColor: Color(0x802196F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CircleWaveProgress(
                  size: MediaQuery.of(context).size.width/1.8,
                  borderWidth: 20.0,
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.white,
                  waveColor: Color(0xff9ad0e5),
                  progress: percent*100,
                ),
              ),
              CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage('assets/relaxingActivities/${activities['English'][activities[lang].indexOf(activityName)]}.jpg'),
              ),
              Positioned(
                bottom: 15.0,
                child: Text(activityName,
                  style:GoogleFonts.gugi(
                    textStyle: TextStyle(
                      fontSize: 22.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return SafeArea(
      child: Scaffold(
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
        body: loading?Center(child: CircularProgressIndicator(),):percent.isNotEmpty?Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: List.generate(secondHalfActivities.length, (index) => activityBlock(percent: secondHalfPercentage[index],activityName: secondHalfActivities[index]),),
                  ),
                ),
                SizedBox(width:10.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:40.0),
                    child: Column(
                      children: List.generate(firstHalfActivities.length, (index) => activityBlock(percent: firstHalfPercentage[index],activityName: firstHalfActivities[index]),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ):Center(
          child: Text(
            noActivities[lang],
            textAlign: TextAlign.center,
            style:GoogleFonts.gugi(
              textStyle: TextStyle(
                fontSize: 22.0,
                color: Colors.black,
              ),),
          ),
        ),
      ),
    );
  }
}


class CircleWaveProgress extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Color waveColor;
  final Color borderColor;
  final borderWidth;
  final double progress;

  CircleWaveProgress(
      {this.size = 200.0,
        this.backgroundColor = Colors.blue,
        this.waveColor = Colors.white,
        this.borderColor = Colors.white,
        this.borderWidth = 10.0,
        this.progress = 50.0})
      :assert(progress >= 0 && progress <= 100,
  'Valid range of progress value is [0.0, 100.0]');

  @override
  _WaveWidgetState createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<CircleWaveProgress>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    /// Only run the animation if the progress > 0. Since we don't need to draw the wave when progress = 0
    if (widget.progress > 0) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: ClipPath(
        clipper: CircleClipper(),
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget child) {
              return CustomPaint(
                painter: WaveWidgetPainter(
                    animation: _animationController,
                    backgroundColor: widget.backgroundColor,
                    waveColor: widget.waveColor,
                    borderColor: widget.borderColor,
                    borderWidth: widget.borderWidth,
                    progress: widget.progress),
              );
            }),
      ),
    );
  }
}

class WaveWidgetPainter extends CustomPainter {
  Animation<double> animation;
  Color backgroundColor, waveColor, borderColor;
  double borderWidth;
  double progress;

  WaveWidgetPainter(
      {this.animation,
        this.backgroundColor,
        this.waveColor,
        this.borderColor,
        this.borderWidth,
        this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    /// Draw background
    Paint backgroundPaint = Paint()
      ..color = this.backgroundColor
      ..style = PaintingStyle.fill;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, backgroundPaint);

    /// Draw wave
    Paint wavePaint = new Paint()..color = waveColor;
    double amp = 15.0;
    double p = progress / 100.0;
    double baseHeight = (1 - p) * size.height;

    Path path = Path();
    path.moveTo(0.0, baseHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
          i,
          baseHeight +
              sin((i / size.width * 2 * pi) + (animation.value * 2 * pi)) *
                  amp);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    canvas.drawPath(path, wavePaint);

    /// Draw border
    // Paint borderPaint = Paint()
    //   ..color = this.borderColor
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = this.borderWidth;

    // canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0,size.height);
    path.lineTo(size.width,size.height);
    path.lineTo(size.width,0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}