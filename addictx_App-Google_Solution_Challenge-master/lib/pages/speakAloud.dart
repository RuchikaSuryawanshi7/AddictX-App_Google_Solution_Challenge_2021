import 'package:addictx/languageNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/widgets/problemWidget.dart';
import 'package:provider/provider.dart';

class SpeakAloud extends StatefulWidget {
  @override
  _SpeakAloudState createState() => _SpeakAloudState();
}

class _SpeakAloudState extends State<SpeakAloud> {
  List<Problem> problems=[];
  bool loading=true;
  ScrollController scrollController;
  bool load=false;
  var lastDoc;
  String lang='English';
  Map noQuestions={
    'English':'No more questions found',
    'Hindi':'कोई और प्रश्न नहीं मिला',
    'Spanish':'No se encontraron más preguntas',
    'German':'Keine weiteren Fragen gefunden',
    'French':"Aucune autre question trouvée",
    'Japanese':'これ以上質問は見つかりません',
    'Russian':'Больше вопросов не найдено',
    'Chinese':'找不到更多问题',
    'Portuguese':'Não foram encontradas mais perguntas',
  };
  Map detox={
    'English':'DETOX YOUR PROBLEM',
    'Hindi':'अपनी समस्या को दूर करें',
    'Spanish':'DESINTOXICA TU PROBLEMA',
    'German':'DETOX IHR PROBLEM',
    'French':"DÉTOXEZ VOTRE PROBLÈME",
    'Japanese':'あなたの問題を解毒する',
    'Russian':'ВЫБЕРИТЕ СВОЮ ПРОБЛЕМУ',
    'Chinese':'排毒你的问题',
    'Portuguese':'DESINTOXIE SEU PROBLEMA',
  };

  @override
  void initState() {
    scrollController = new ScrollController()..addListener(_scrollListener);
    getData();
    super.initState();
  }

  @override
  void dispose()
  {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener()async{
    if (!loading&&!load) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        setState(() => load = true);
        await getMoreQuestions();
      }
    }
  }

  getMoreQuestions()async
  {
    QuerySnapshot querySnapshot=await problemsReference
        .orderBy("timeStamp",descending: true)
        .startAfter([lastDoc['timeStamp']])
        .limit(10).get();
    if(querySnapshot!=null&&querySnapshot.docs.length>0)
    {
      lastDoc = querySnapshot.docs[querySnapshot.docs.length - 1];
      querySnapshot.docs.forEach((doc) {
        problems.add(Problem.fromDocument(doc));
      });
    }
    else
      showToast(noQuestions[lang]);
    setState(() {
      load=false;
    });
  }

  getData()async
  {
    QuerySnapshot querySnapshot=await problemsReference.orderBy('timeStamp',descending: true).limit(10).get();
    querySnapshot.docs.forEach((doc) {
      problems.add(Problem.fromDocument(doc));
    });
    lastDoc = querySnapshot.docs[querySnapshot.docs.length - 1];

    setState(() {
      loading=false;
    });
  }

  getQuestions()
  {
    problems.clear();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return RefreshIndicator(
      onRefresh: ()async{return getQuestions();},
      child: SingleChildScrollView(
        controller: scrollController,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text(
              '  '+detox[lang],
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: problems.length,
              itemBuilder: (context,index){
                return problems[index];
              },
            ),
          ],
        ),
      ),
    );
  }
}
