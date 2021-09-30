import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/widgets/addictWatchWidget.dart';
import 'package:addictx/widgets/tutorialWatch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddictXWatch extends StatefulWidget {

  @override
  _AddictXWatchState createState() => _AddictXWatchState();
}

class _AddictXWatchState extends State<AddictXWatch> {
  bool loading=true;
  List<AddictxWatchWidget> watch=[];
  QuerySnapshot querySnapshot;
  var lastDoc;
  Map title={
    'English':'AddictX Watch',
    'Hindi':'एडिक्टएक्स वॉच',
    'Spanish':'AddictX Mirar',
    'German':'AddictX Sehen',
    'French':'AddictX Regarder',
    'Japanese':'AddictX 見る',
    'Russian':'AddictX Смотреть ',
    'Chinese':'AddictX 看',
    'Portuguese':'AddictX Ver',
  };

  Map tapToWatchTutorial={
    'English':'Tap to watch tutorial',
    'Hindi':'ट्यूटोरियल देखने के लिए टैप करें',
    'Spanish':'Toca para ver el tutorial',
    'German':'Tippe, um das Tutorial anzusehen',
    'French':'Appuyez pour regarder le didacticiel',
    'Japanese':'タップしてチュートリアルを見る',
    'Russian':'Нажмите, чтобы посмотреть руководство',
    'Chinese':'点按即可观看教程',
    'Portuguese':'Toque para assistir ao tutorial',
  };


  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData()async{
    querySnapshot=await addictXWatchChallengeReference.orderBy('timeStamp',descending: true).limit(10).get();
    QuerySnapshot snapshot=await addictXWatchReference.orderBy('timeStamp',descending: true).limit(10).get();
    if(snapshot!=null&&snapshot.docs.length>0)
      {
        snapshot.docs.forEach((doc) {
          watch.add(AddictxWatchWidget.fromDocument(doc));
        });
        lastDoc=snapshot.docs.last;
      }
    setState(() {
      loading=false;
    });
  }

  void dialog(BuildContext context, DocumentSnapshot snapshot){
    var alertDialog=Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: TutorialWatch.fromDocument(snapshot),
    );
    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: loading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: querySnapshot.docs.length,
                separatorBuilder: (context,index)=>SizedBox(height: 5,),
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: ()=>dialog(context, querySnapshot.docs[index]),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xff9ad0e5),
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                querySnapshot.docs[index].data()['challengeName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                tapToWatchTutorial[lang],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: const Color(0x99000000),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          CachedNetworkImage(
                            imageUrl: querySnapshot.docs[index].data()['thumbnail'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 25,),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: watch.length,
                separatorBuilder: (context,index)=>SizedBox(height: 10,),
                itemBuilder: (context,index){
                  return watch[index];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
