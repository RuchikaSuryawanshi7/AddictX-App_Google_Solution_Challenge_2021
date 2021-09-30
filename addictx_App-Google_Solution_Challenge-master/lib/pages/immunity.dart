import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:addictx/yoga/ai.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

var finalScore = 0;
var questionNumber = 0;
var quiz = ImmunityQuiz();

class ImmunityQuiz{
  var questions = [
    "How Often do you fall Sick??",
    "Do you feel tired and Exhausted ?",
    "Do you take Medicine Regularly ?",
    "Do you Exercise Regularly ?",
    "Do you take any immunity suppressing medicine or having any Immunity suppressing Disease ?",
    "How well do you Sleep ?",
    "How would you Describe your current stress Level ?",
    "How would you rate your eating habbits, is your diet balanced and rich in vitamin and minerals ?",
    "Do you Suffere from Constipation?",
    "Do you Smoke ?",
  ];

  var answers =[
    ["Often Fall sick Alot", "1-2 times a year", "Mostly when the whether Changes", "Never"],
    [ "Tired and Exhausted throughout the day","Normal, Neither Energetic nor Tired", "Energetic during the day, tired in evening",  "Never, I am Always Energetic"],
    ["Daily", "Sometimes", "only when Consulted by Doctors", "Never"],
    ["Never",  "One Time a Week", "More than 1 Time Every week", "Every Day"],
    ["Yes", "Sometimes", "Not Really",  "No"],
    ["Disturbed Sleeping Pattern Throughout the Night", "Less than 4 hours a night", "Less that 6 hours a night", "Sound Sleep for 6 to 8 hours a night"],
    ["High", "Average","Low", "No stress at all."],
    ["Bad Eating Habbits - Eat unhealthy and junk outside food all the time.", "Combination of Healthy food and Junk Food","Average Eating Habbit - Mix of Healthy Food", "Great Eating Habbits - Healthy food always, rarely eat junk food"],
    ["Yes", "Sometimes","Not offen", "Never"],
    ["Daily", "Few times a Week","Few times a month", "Never"],
  ];


}

class WakeUpp extends StatefulWidget {
  const WakeUpp({Key key}) : super(key: key);

  @override
  _WakeUppState createState() => _WakeUppState();
}

class _WakeUppState extends State<WakeUpp> {
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xfff0f0f0),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
              onPressed: ()=>Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(quiz.questions[questionNumber],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.normal,
                  ),),
              ),
              SizedBox(height: 20.0,),

              //Question One
              //button 1
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(color: const Color(0xff99d0e5),width: 1),
                  ),
                  minWidth: double.infinity,
                  height: 70.0,
                  onPressed: (){
                    for(var i=0; i < 4; i++){
                      if(quiz.answers[questionNumber][0] == quiz.answers[questionNumber][i]){
                        debugPrint("Correct");
                        finalScore = finalScore + (i+1);
                      }else{
                        debugPrint("Wrong");
                        debugPrint("$questionNumber");
                      }

                    }
                    updateQuestion();
                  },
                  child: Text(quiz.answers[questionNumber][0], textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0,),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(color: const Color(0xff99d0e5),width: 1),
                  ),
                  minWidth: double.infinity,
                  height: 70.0,
                  onPressed: (){
                    for(var i=0; i < 4; i++){
                      if(quiz.answers[questionNumber][1] == quiz.answers[questionNumber][i]){
                        debugPrint("Correct");
                        finalScore = finalScore + (i+1);
                      }else{
                        debugPrint("Wrong");
                      }
                    }
                    updateQuestion();
                  },
                  child: new Text(quiz.answers[questionNumber][1],
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 20.0,
                    ),),
                ),
              ),

              //button 4
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(color: const Color(0xff99d0e5),width: 1),
                  ),
                  minWidth: double.infinity,
                  height: 70.0,
                  onPressed: (){

                    for(var i=0; i < 4; i++){
                      if(quiz.answers[questionNumber][2] == quiz.answers[questionNumber][i]){
                        debugPrint("Correct");
                        finalScore = finalScore + (i+1);
                      }else{
                        debugPrint("Wrong");
                        debugPrint("$questionNumber");
                      }
                    }
                    updateQuestion();
                  },
                  child: new Text(quiz.answers[questionNumber][2],
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 20.0,
                    ),),
                ),
              ),

              //button 2
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(color: const Color(0xff99d0e5),width: 1),
                  ),
                  minWidth: double.infinity,
                  height: 70.0,
                  onPressed: (){

                    for(var i=0; i < 4; i++){
                      if(quiz.answers[questionNumber][3] == quiz.answers[questionNumber][i]){
                        debugPrint("Correct");
                        finalScore = finalScore + (i+1);
                      }else{
                        debugPrint("Wrong");
                        debugPrint("$questionNumber");
                      }
                    }
                    updateQuestion();
                  },
                  child: new Text(quiz.answers[questionNumber][3],
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 20.0,
                    ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateQuestion(){
    setState(() {
      if(questionNumber == quiz.questions.length - 1){
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> new Summary(score: finalScore,)));

      }else{
        questionNumber++;
      }
    });
  }
}






class Summary extends StatefulWidget{
  int score;

  Summary({Key key, @required this.score}) : super(key: key);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  var shortMsg = ["Opps!! Low Immunity", "Average Immunity!!", "Great!!"];

  var longMsg = ["Your Immunity Seems to be very Low", "Your Immunity Seems to be in Good Health", "Wow,Your Immunity is Perfect"];

  var checkPoints = [
    ["A healthy diet is key to a strong immune system. Make sure you eat plenty of vegetables, fruits, legumes, whole grains, lean protein and healthy fats. Maintaining a healthy diet can help ensure you're getting sufficient amounts of micronutrients.",
      "Exercising regularly is an important part of being healthy and supporting a healthy immune system. 30 minutes of moderate-to-vigorous exercise every day helps stimulate your immune system, say experts. Exercise may improve circulation, making it easier for immune cells to travel more easily.",
      "Being dehydrated slows down the movement of lymph, leading to an impaired immune system. Be sure you're replacing the water you lose with water you can use. Hydration is essential for your body's immune system and skin health. If you're not drinking enough water, you may be at risk of dehydration.",
      "Get plenty of sleep to boost your immune system and fight off illness. Sleep is a good way to improve your body's ability to fight infection. Get more sleep if you're feeling tired or fatigued.",
      "Stress is different for everyone, and how we relieve it is, too. Deep breathing, mediation, prayer and exercise can help you reduce stress-related symptoms. Find out how to identify your body's response to stress by visiting your.",
    ],
    ["Drinking more than 8 cups of herbal tea a day can help your body regenerate disease-fighting lymphatic cells naturally. The recommends drinking at least 8 cups throughout the day to stay hydrated and prevent infections. Healthier you look after your body by drinking more water.",
      "Bone broth is packed with vitamins and minerals to help heal and get you back on your feet. Supercharge your bone broth with garlic for its powerful anti-viral and anti-bacterial properties. Turmeric, cinnamon and a dash of fresh ginger can also help to speed up recovery.",
      "Eating lots of berries, citrus fruits, kiwi, papayas, broccoli and red peppers can help keep you protected from a cold. Vitamin C is extremely helpful when fighting infection. If you have a cold, make sure to increase your vitamin C intake.",
      "Take some time out to de-stress and relax if you're feeling under the weather. Rest up, take a break from your phone and TV and read a great book or. This can also boost your immune system.",
      "Think of your gut as a personal bodyguard - 70% of your immune system is in your gut. Fermented foods like kimchi, miso, kefir, tempeh, and sauerkraut can reduce the duration of a cold"
    ],
    ["Regular health checkups can diagnose predisposition to diseases and detect underlying conditions. The reports can be a practical guide to boost the immune system according to the. Find out how you can improve your overall health by visiting your or pharmacist.",
      "Exercise can boost your mood and improve sleep quality according to the National Meningitis Society.",
      "Overstressed people's immunity goes down and makes them ill. Take a break whenever you need to relieve stress, according to the. Do you have a story to share? Send it to us!",
      "Eating a well-balanced diet with lots of fruits and veggies can help you fight infections. Leafy greens and brightly-colored fruits are abundant in antioxidants that boost our body's defense mechanism.",
      "Lack of sleep releases higher levels of stress hormones in the body and this can cause more inflammation. Getting a regular 8-hour sleep can work miracles to boost your immune system."
    ],
  ];

  List<List> poses=[
    ['Low Lungs','Lotus pose','Salamba Shrishasana','Cobra Pose','Camel Pose','Vajrasana'],
    ['Tadasana', 'Pigeon Pose', 'Cobra Pose', 'Bow Pose', 'Child Pose', 'Plow Pose', 'Viparita Karani',],
    ['Tree Pose', 'Triangle Pose', 'Chair Pose', 'Uttasana', 'Bridge', 'Viparita Karani', 'Child Pose', 'Cobra Pose', 'Seated Forward Fold', 'Plank', 'Viparita Karani',],
    ['Tadasana', 'Warrior-1', 'Low Lungs', 'Uttasana', 'Cobra Pose', 'Bow Pose', 'Cat Stretch', 'Viparita Shabasana', 'Plank', 'Gomukhasana', 'Vajrasana',],
    ['Tree Pose', 'Low Lungs', 'Camel Pose', 'Cobra Pose', 'Child Pose', 'Viparita Shabasana', 'Plank', 'Viparita Karani',],
    ['Tadasana', 'Triangle Pose', 'Revolved head of knee', 'Pigeon Pose', 'Cobra Pose', 'Bow Pose', 'Viparita Shabasana', 'Gomukhasana',],
    ['Tree Pose', 'Dolphin Pose', 'Child Pose', 'Cobra Pose','Cat Stretch', 'Bow Pose', 'Seated Forward Fold', 'Seated Spinal Twist', 'Fish Pose', 'Viparita Karani',],
    ['Tadasana', 'Gomukhasana', 'Seated Spinal Twist', 'Child Pose', 'Mandukhasana', 'Plank', 'Viparita Karani', 'Salamba Shrishasana',],
    ['Tree Pose', 'Triangle Pose', 'Chair Pose', 'Dolphin pose', 'Downward Facing Dog', 'Child Pose', 'Cobra Pose', 'Plank', 'Viparita Karani',],
    ['Warrior-1', 'Low Lungs', 'Pigeon Pose', 'Seated Forward Fold', 'Knee to Chest', 'Vajrasana', 'Lotus pose',],
    ['Bound Angle Pose', 'Gomukhasana', 'Revolved head of knee', 'Tree Pose', 'Pigeon Pose', 'Low Lungs',],
    ['Tadasana', 'Uttasana', 'Downward Facing Dog', 'Cobra Pose', 'Fish Pose', 'Knee to Chest', 'Viparita Karani', 'Gomukhasana', 'Vajrasana',],
    ['Tree Pose', 'Chakrasana', 'Viparita Karani', 'Plow Pose', 'Cobra Pose', 'Bow Pose', 'Vajrasana',],
    ['Child Pose', 'Salamba Shrishasana', 'Fish Pose', 'Bound Angle Pose',],
    ['Tadasana', 'Triangle Pose', 'Chair Pose', 'Cat Stretch', 'Cobra Pose', 'Child Pose', 'Revolved head of knee', 'Viparita Karani',],
  ];

  String returnPoseName(String poseName){
    switch (poseName) {
      case 'Cat Stretch':
        return 'Cat Stretch';
        break;
      case 'Chair Pose':
        return 'Chair Pose';
        break;
      case 'Chakrasana':
        return 'Chakrasana';
        break;
      case 'Child Pose':
        return 'Child Pose';
        break;
      case 'Cobra Pose':
        return 'Cobra pose';
        break;
      case 'Dolphin Pose':
        return 'Dolphin pose';
      case 'Downward Facing Dog':
        return 'Downward-Facing Dog';
        break;
      case 'Fish Pose':
        return 'fish pose';
        break;
      case 'Gomukhasana':
        return 'Gomukhasana';
        break;
      case 'Knee to Chest':
        return 'knee to chest';
        break;
      case 'Lotus pose':
        return 'lotus pose';
        break;
      case 'Low Lungs':
        return 'low lungs';
        break;
      case 'Mandukhasana':
        return 'Mandukasana';
        break;
      case 'Pigeon Pose':
        return 'Pigeon Pose';
        break;
      case 'Plank':
        return 'plank';
        break;
      case 'Revolved head of knee':
        return 'Revolved Head-of-the-Knee Pose';
        break;
      case 'Salamba Shrishasana':
        return 'Salamba Shirshasana';
        break;
      case 'Seated Forward Fold':
        return 'seated forward fold';
        break;
      case 'Seated Spinal Twist':
        return 'Seated Spinal Twist';
        break;
      case 'Tadasana':
        return 'tadasan';
        break;
      case 'Plow Pose':
        return 'The Plow Pose';
        break;
      case 'Tree Pose':
        return 'tree pose';
        break;
      case 'Triangle Pose':
        return 'Triangle Pose';
        break;
      case 'Uttasana':
        return 'Uttanasana';
        break;
      case 'Vajrasana':
        return 'Vajrasana';
        break;
      case 'Viparita Karani':
        return 'Viparita Karani';
        break;
      case 'Viparita Shabasana':
        return 'viparita shalabhasana';
        break;
      case 'Warrior-1':
        return 'warrior 1';
        break;
      case 'Bound Angle Pose':
        return 'Bound Angle Pose';
        break;
      case 'Bow Pose':
        return 'Bow pose';
        break;
      case 'Bridge':
        return 'Bridge Pose';
        break;
      case 'Camel Pose':
        return 'Camel pose';
        break;
      default:
        return 'no pose exists';
    }
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
      showToast("Something went wrong!! Please try again later");
    }
  }
  @override
  void dispose() {
    finalScore = 0;
    questionNumber = 0;
    quiz = ImmunityQuiz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    poses.shuffle();
    final double immunityScore = widget.score/4;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff0f0f0),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: ()=>Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 60.0,
              width: double.infinity,
              child: Center(
                child: Text(
                  "IMMUNITY REPORT",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.normal,
                  ),),
              ),
            ),
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=735&q=80'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcATop),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  Text(
                    "Dear, "+(currentUser!=null?currentUser.username:username),
                    style: TextStyle(fontSize: 22.0, color: Colors.white,fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Your Immunity Score : $immunityScore / 10",
                    style: TextStyle(fontSize: 22.0, color: Colors.white,fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    height: 175,
                    width: 300,
                    child: SfRadialGauge(
                      axes:<RadialAxis>[
                        RadialAxis(showLabels: false, showAxisLine: false, showTicks: false,
                            minimum: 0, maximum: 10,
                            ranges: <GaugeRange>
                            [GaugeRange(startValue: 0, endValue: 4.5,
                                  color: const Color(0xffff9899), label: 'Low',
                                  sizeUnit: GaugeSizeUnit.factor,
                                  labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:  20,),
                                  startWidth: 0.25, endWidth: 0.25
                              ),GaugeRange(startValue: 4.5, endValue: 7,
                                color:const Color(0xffffeb64), label: 'Average',
                                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20,),
                                startWidth: 0.25, endWidth: 0.25, sizeUnit: GaugeSizeUnit.factor,
                              ),
                              GaugeRange(startValue: 7, endValue: 10,
                                color:const Color(0xff89d688), label: 'Good',
                                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20,),
                                sizeUnit: GaugeSizeUnit.factor,
                                startWidth: 0.25, endWidth: 0.25,
                              ),

                            ],
                            pointers: <GaugePointer>[NeedlePointer(value: immunityScore,
                              needleColor: Colors.white,
                              needleStartWidth: 1, needleEndWidth: 5,
                              knobStyle: KnobStyle(knobRadius: 0.05, borderColor: Colors.grey,
                                borderWidth: 0.02,
                                color: Colors.white,
                              ),)]
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (immunityScore <= 4.5)
                        Text(shortMsg[0],
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else if(immunityScore >= 4.5 && immunityScore <= 7)
                        Text(shortMsg[1],
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500
                          ),
                        )
                      else
                        Text(shortMsg[2],
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      SizedBox(height: 5,),
                      if (immunityScore <= 4.5)
                        Text(longMsg[0],
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400
                          ),
                        )
                      else if(immunityScore >= 4.5 && immunityScore <= 7)
                        Text(longMsg[1],
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400
                          ),
                        )
                      else
                        Text(
                          longMsg[2],
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400
                          ),
                        )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: const Color(0xfff0f0f0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              "CheckPoints : ",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:14.0),
                        child: Column(
                          children: [
                            if (immunityScore <= 4.5)
                              Column(
                                children: [
                                  Text(checkPoints[0][0],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),

                                  Text(checkPoints[0][1],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(checkPoints[0][2],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),

                                  Text(checkPoints[0][3],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(checkPoints[0][4],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                ],
                              )
                            else if(immunityScore >= 4.5 && immunityScore <= 7)
                              Column(
                                children: [
                                  Text(checkPoints[1][0],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),

                                  Text(checkPoints[1][1],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(checkPoints[1][2],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),

                                  Text(checkPoints[1][3],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(checkPoints[1][4],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  Text( checkPoints[2][0],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),

                                  Text(checkPoints[2][1],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(checkPoints[2][2],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),

                                  Text(checkPoints[2][3],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  Divider(),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(checkPoints[2][4],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),),
                                  SizedBox(height: 10,),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: const Color(0xff99d0e5),
                  child: Text(
                    'RECOMMENDATION',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: poses[0].getRange(0, 3).toList().length,
                  separatorBuilder: (context,index)=>SizedBox(height: 5,),
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewExample(poseName: returnPoseName(poses[0][index]),))),
                      child: Container(
                        width: double.infinity,
                        height: 130,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: AssetImage('assets/yogaPoses/${poses[0][index]}.jpg'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.srcATop),
                          ),
                        ),
                        child: Text(
                          poses[0][index],
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.27,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/covid.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COVID-19',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Ultimately, the greatest lesson that COVID-19 can teach humanity is that we are all in this together.",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: ()=>launchLink('https://covid19.who.int/'),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: const Color(0xb0000000),
                          ),
                          child: Text(
                            "Learn more",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}