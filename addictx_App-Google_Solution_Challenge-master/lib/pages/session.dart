import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/bottomSheetForSession.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Session extends StatefulWidget {
  final Map session;
  final List<DocumentSnapshot> snapshot;
  Session({this.session,this.snapshot});

  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  bool loading=true;
  bool flag=true;
  String description,descrip,firstHalf;
  List<DocumentSnapshot> snapshot=[];
  Map about={
    'English':'About',
    'Hindi':'तकरीबन',
    'Spanish':'Acerca de',
    'German':'Über',
    'French':"À propos",
    'Japanese':'約',
    'Russian':'О',
    'Chinese':'关于',
    'Portuguese':'Cerca de',
  };
  Map more={
    'English':'Read more',
    'Hindi':'अधिक पढ़ें',
    'Spanish':'Lee mas',
    'German':'Weiterlesen',
    'French':"Lire la suite",
    'Japanese':'続きを読む',
    'Russian':'Читать далее',
    'Chinese':'阅读更多',
    'Portuguese':'Consulte Mais informação',
  };
  Map less={
    'English':'Read less',
    'Hindi':'कम पढ़ें',
    'Spanish':'Leer menos',
    'German':'Lese weniger',
    'French':"Lire moins",
    'Japanese':'続きを読む',
    'Russian':'Читать меньше',
    'Chinese':'少读',
    'Portuguese':'Leia menos',
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

  @override
  void initState()
  {
    description=widget.session['about'];
    if (description.length > 60) {
      int index=description.substring(0,60).lastIndexOf(RegExp(r"\s+"));
      firstHalf = description.substring(0, index)+" ";
      descrip=firstHalf+" ...";
    } else {
      firstHalf = description;
      descrip=firstHalf;
    }
    snapshot.addAll(widget.snapshot);
    getData();
    super.initState();
  }

  void getData()async
  {
    var lastDoc=widget.snapshot.last;
    QuerySnapshot querySnapshot= await sessionsReference.doc('sessionName').collection(widget.session['heading']).orderBy('sno').startAfter([lastDoc['sno']]).get();
    snapshot.addAll(querySnapshot.docs);
    setState(() {
      loading=false;
    });
  }

  switchBetweenReadMoreAndLess()
  {
    setState(() {
      flag=!flag;
    });
    if(!flag)
      descrip=description;
    else
      descrip=firstHalf+" ...";
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.32,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.session['url']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      widget.session['heading'],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: ()=>Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
                      ),
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.more_horiz,color: Colors.white,),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                color: const Color(0xfff0f0f0),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      about[lang],
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text.rich(
                      TextSpan(
                        text: descrip,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: description.length>60?flag ? "\n\n"+more[lang] : "\n\n"+less[lang]:"",
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap=()=>switchBetweenReadMoreAndLess(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8,),
                    loading?Container(
                      margin: EdgeInsets.only(top: 60),
                      child: Center(child: CircularProgressIndicator(),),
                    ):Container(
                      width: double.infinity,
                      color: const Color(0xfff0f0f0),
                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sessions[lang],
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10,),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.length,
                            separatorBuilder: (context,index)=>SizedBox(height: 8,),
                            itemBuilder: (context,index){
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: ()=>bottomSheetForSession(context, snapshot[index]),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height*0.22,
                                      alignment: Alignment.bottomLeft,
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(snapshot[index].data()['imageUrl']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            snapshot[index].data()['heading'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Text(
                                            "|",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Icon(Icons.access_time,color: Colors.white,size: 18,),
                                          Text(
                                            ' '+snapshot[index].data()['duration'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
