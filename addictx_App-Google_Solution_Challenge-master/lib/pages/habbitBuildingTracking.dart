import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:addictx/SplashScreen.dart';

class HabitBuildingTracking extends StatefulWidget {

  @override
  _HabitBuildingTrackingState createState() => _HabitBuildingTrackingState();
}

class _HabitBuildingTrackingState extends State<HabitBuildingTracking> {
  double missed=0;
  double performed=0;
  bool loading=true;
  Map titles={
    'English':'Habit Building',
    'Hindi':'आदत निर्माण',
    'Spanish':'Construcción de hábitos',
    'German':'Gewohnheitsgebäude',
    'French':"Construction d'habitudes",
    'Japanese':'習慣の構築',
    'Russian':'Привычка',
    'Chinese':'习惯养成',
    'Portuguese':'Construção de Hábitos',
  };
  Map hi={
    'English':'Hi,',
    'Hindi':'नमस्ते,',
    'Spanish':'Hola,',
    'German':'Hallo,',
    'French':"Salut,",
    'Japanese':'こんにちは、',
    'Russian':'Привет,',
    'Chinese':'你好，',
    'Portuguese':'Oi,',
  };
  Map notPerformed={
    'English':"Habit building activities not performed so far...",
    'Hindi':'अब तक नहीं की गई आदत निर्माण गतिविधियां...',
    'Spanish':'Actividades de construcción de hábitos no realizadas hasta ahora ...',
    'German':'Bisher nicht durchgeführte Gewohnheitsbildungsaktivitäten...',
    'French':"Activités de construction d'habitudes non réalisées jusqu'à présent...",
    'Japanese':'これまでに行われていない習慣構築活動...',
    'Russian':'Действия по формированию привычки пока не выполняются ...',
    'Chinese':'到目前为止还没有进行习惯养成活动...',
    'Portuguese':'Atividades de construção de hábitos não realizadas até agora ...',
  };

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData()async{
    List<String> dates=[];
    List<String> allPossibleDates=[];
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    dates=sharedPreferences.getStringList('habitBuildingTaskCompleteDates')??[];
    DateTime now=DateTime.now();
    if(dates.isNotEmpty)
      {
        int daysCount=DateTime(now.year, now.month, now.day).difference(DateFormat.yMMMd().parse(dates[0])).inDays;
        for(int i=0;i<daysCount;i++)
        {
          DateTime date=DateFormat.yMMMd().parse(dates[0]).add(Duration(days: i));
          allPossibleDates.add(DateFormat.yMMMd().format(date));
        }
      }
    double percent=dates.length/allPossibleDates.length;
    if(percent.isNaN||percent.isInfinite)
      {
        percent=100;
      }
    performed=percent;
    missed=100-percent;
    setState(() {
      loading=false;
    });
    print(performed);
    print(missed);
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return SafeArea(
      child: Scaffold(
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
        body: loading?Center(child: CircularProgressIndicator(),):performed+missed!=0.0&&!(performed+missed).isNaN?Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0,),
            Text(
              "  "+hi[lang],
              style:GoogleFonts.gugi(
                textStyle: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                ),),
            ),
            Text(
              currentUser!=null?('  '+currentUser.username):("  "+username),
              overflow: TextOverflow.ellipsis,
              style:GoogleFonts.gugi(
                textStyle: TextStyle(
                  fontSize: 30.0,
                  color: Colors.orange,
                ),),
            ),
            SizedBox(height: 40,),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(38.0),
                child: Progress(performed: performed,missed: missed,),
              ),
            ),
          ],
        ):Center(
          child: Text(
            notPerformed[lang],
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


class Progress extends StatefulWidget {
  final double performed;
  final double missed;
  Progress({this.missed,this.performed});
  @override
  State<StatefulWidget> createState() => ProgressState();
}

class ProgressState extends State<Progress> {
  int touchedIndex;
  Map performed={
    'English':'Performed',
    'Hindi':'प्रदर्शन किया',
    'Spanish':'Realizada',
    'German':'Durchgeführt',
    'French':"Exécutée",
    'Japanese':'実行',
    'Russian':'Выполнено',
    'Chinese':'执行',
    'Portuguese':'Realizada',
  };
  Map missed={
    'English':'Missed',
    'Hindi':'चुक गया',
    'Spanish':'Omitido',
    'German':'Verpasst',
    'French':"Manquée",
    'Japanese':'逃した',
    'Russian':'Пропущенный',
    'Chinese':'错过了',
    'Portuguese':'Esquecidas',
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                          if (desiredTouch && pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: performed[lang],
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: missed[lang],
                  isSquare: true,
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: widget.performed==0.0?5.0:widget.performed,
            title: (widget.performed==0.0?'0':widget.performed.toStringAsFixed(0))+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: widget.missed==0.0?5.0:widget.missed,
            title: (widget.missed==0.0?'0':widget.missed.toStringAsFixed(0))+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}