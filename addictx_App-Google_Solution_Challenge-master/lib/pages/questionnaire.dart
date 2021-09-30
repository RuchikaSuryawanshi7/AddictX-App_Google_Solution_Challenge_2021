import 'package:addictx/helpers/languageCode.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/models/questionModel.dart';
import 'package:addictx/pages/decision.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class Questionnaire extends StatefulWidget {
  final String name;
  final String heading;
  final String lang;
  Questionnaire({this.name,this.heading,this.lang});
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  bool loading=true;
  int count=0;
  bool canTap=true;
  List<QuestionModel> questionModel=[];
  List<String> responses=[];
  List<Color> color=[];
  final translator = GoogleTranslator();
  Map questionsAnswered={
    'English':'questions answered',
    'Hindi':'सवालों के जवाब दिए',
    'Spanish':'preguntas respondidas',
    'German':'Fragen beantwortet',
    'French':'réponses aux questions',
    'Japanese':'回答された質問',
    'Russian':'ответы на вопросы',
    'Chinese':'回答的问题',
    'Portuguese':'perguntas respondidas',
  };

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData()async
  {
    DocumentSnapshot snapshot=await questionnaireReference.doc(widget.name).get();
    List<Map> content=List.from(snapshot.data()['questions']);
    content.forEach((element) {
      questionModel.add(QuestionModel.fromMap(element));
    });
    //translate
    if(widget.lang!='English')
      {
        for(int i=0;i<questionModel.length;i++)
          {
            var translation = await translator.translate(questionModel[i].question, from: 'en', to: LanguageCode.getCode(widget.lang));
            questionModel[i].question=translation.text;
            for(int j=0;j<questionModel[i].options.length;j++)
              {
                var translation = await translator.translate(questionModel[i].options[j]['value'], from: 'en', to: LanguageCode.getCode(widget.lang));
                questionModel[i].options[j]['value']=translation.text;
              }
          }
      }
    setState(() {
      loading=false;
    });
  }

  onSelect(int index,String result)
  {
    if(canTap)
      {
        canTap=false;
        setState(() {
          color[index]=const Color(0xff9ad0e5);
        });
        Future.delayed(Duration(milliseconds: 600),(){
          setState(() {
            color.clear();
            count++;
            responses.add(result);
          });
          if(responses.length>=questionModel.length)
            {
              double percentage=0.0;
              int count=0;
              int total=0;
              responses.forEach((value) {
                count+=int.parse(value);
              });
              questionModel.forEach((question) {
                int max=0;
                question.options.forEach((element) {
                  max=int.parse(element['weightage'])>max?int.parse(element['weightage']):max;
                });
                total+=max;
              });
              percentage=(count/total);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Decision(percentage: percentage,name: widget.name,heading: widget.heading,)));
            }
          canTap=true;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xfff0f0f0),
        title: Text('${count+1}/${questionModel.length} '+questionsAnswered[lang],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14),),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10,top: 5),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Image.asset('assets/addiction/${widget.name}.png',width: 50,height: 50,),
            ),
          ),
        ],
      ),
      body: loading?Center(child: CircularProgressIndicator(),):responses.length!=questionModel.length?SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10,15,10,20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0),bottomLeft: Radius.circular(15.0)),
                color: const Color(0xfff0f0f0),
              ),
              child: Text(questionModel[count].question,style: TextStyle(fontSize: 22.0,),),
            ),
            ListView.builder(
              padding: EdgeInsets.fromLTRB(10,40,10,10),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: questionModel[count].options.length,
              itemBuilder: (context,index)
              {
                color.add(Color(0xffffffff));
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: ()=>onSelect(index,questionModel[count].options[index]['weightage']),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(width: 1.0, color: const Color(0xff9ad0e5)),
                      color: color[index],
                    ),
                    margin: EdgeInsets.only(top:10,bottom: 10),
                    padding: EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                    width: double.infinity,
                    child: Text(questionModel[count].options[index]['value'],style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center,),
                  ),
                );
              },
            ),
          ],
        ),
      ):Container(),
    );
  }
}
