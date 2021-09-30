import 'package:addictx/helpers/details.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitBuilding extends StatefulWidget {
  @override
  _HabitBuildingState createState() => _HabitBuildingState();
}

class _HabitBuildingState extends State<HabitBuilding> {
  String startTime='';
  int dayCount=1;
  List<String> taskCompleteDates=[];
  bool showPopUp=false;
  Map titles={
    'English':'Habit Building',
    'Hindi':'आदत निर्माण',
    'Spanish':'CONSTRUCCIÓN DE HÁBITOS',
    'German':'GEWOHNHEITSBAU',
    'French':"BÂTIMENT D'HABITATION",
    'Japanese':'習慣の構築',
    'Russian':'Привычка',
    'Chinese':'习惯养成',
    'Portuguese':'CONSTRUÇÃO DE HÁBITOS',
  };
  Map day={
    'English':'Day-',
    'Hindi':'दिन-',
    'Spanish':'Día-',
    'German':'Tag-',
    'French':"Jour-",
    'Japanese':'日-',
    'Russian':'День-',
    'Chinese':'日-',
    'Portuguese':'Dia-',
  };
  Map ask={
    'English':"Have you done your today's task?",
    'Hindi':'क्या आपने अपना आज का कार्य पूरा कर लिया है?',
    'Spanish':'¿Has hecho tu tarea de hoy',
    'German':'Haben Sie Ihre heutige Aufgabe erledigt?',
    'French':"Avez-vous fait votre tâche d'aujourd'hui?",
    'Japanese':'今日の仕事は終わりましたか？',
    'Russian':'Вы выполнили свою сегодняшнюю задачу?',
    'Chinese':'你今天的任务完成了吗？',
    'Portuguese':'Você fez sua tarefa de hoje?',
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
    getData();
    super.initState();
  }

  getData()async
  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    startTime=sharedPreferences.getString('startTimeOfHabits')??'';
    taskCompleteDates=sharedPreferences.getStringList('habitBuildingTaskCompleteDates')??[];
    if(taskCompleteDates.contains(DateFormat.yMMMd().format(DateTime.now())))
      showPopUp=false;
    else
      showPopUp=true;
    if(startTime=='')
      {
        var now = DateTime.now();
        startTime = DateTime(now.year, now.month, now.day).toString();
        sharedPreferences.setString('startTimeOfHabits', startTime);
      }
    DateTime startDateTime=DateTime.parse(startTime);
    setState(() {
      dayCount=DateTime.now().difference(startDateTime).inDays+1;
    });
  }

  completedTask()async
  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    taskCompleteDates.add(DateFormat.yMMMd().format(DateTime.now()));
    sharedPreferences.setStringList('habitBuildingTaskCompleteDates', taskCompleteDates);
    setState(() {
      showPopUp=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.width/5,bottom: MediaQuery.of(context).size.width/6),
            color: Color(0x6e77d5f8),
            padding: EdgeInsets.all(15),
            child: Text(
              day[lang]+" $dayCount",
              style: GoogleFonts.gugi(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Flexible(
            child: Swiper(
              loop: false,
              itemBuilder: (context,index)
              {
                return Center(
                  child: Column(
                    children: [
                      Image.asset('assets/habitBuilding/$index.png',),
                      Text(
                        habitDetails[lang][index.toString()],
                        style: GoogleFonts.gugi(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
              controller: SwiperController(),
              pagination: SwiperPagination(
                builder: new DotSwiperPaginationBuilder(
                    color:  const Color(0xffe4e6e7), activeColor: const Color(0x599ad0e5),
                ),
              ),
              itemCount: dayCount,
            ),
          ),
          showPopUp?Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight:Radius.circular(50)),
              color: Colors.blue[100],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ask[lang],
                  style: GoogleFonts.gugi(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 7,),
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: ()=>completedTask(),
                      child: Container(
                        alignment: Alignment.center,
                        width: 85,
                        margin: EdgeInsets.only(right:5.0),
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Text(
                          yes[lang],
                          style: GoogleFonts.gugi(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: ()=>setState(()=>showPopUp=false),
                      child: Container(
                        alignment: Alignment.center,
                        width: 85,
                        margin: EdgeInsets.only(left:5.0),
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Text(
                          no[lang],
                          style: GoogleFonts.gugi(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ):Container(),
        ],
      ),
    );
  }
}
