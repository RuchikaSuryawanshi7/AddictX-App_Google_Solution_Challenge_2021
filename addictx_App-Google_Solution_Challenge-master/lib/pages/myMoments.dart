import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/timeAgo.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/profile.dart';
import 'package:addictx/widgets/momentsWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyMoments extends StatefulWidget {
  @override
  _MyMomentsState createState() => _MyMomentsState();
}

class _MyMomentsState extends State<MyMoments> {
  bool hasMoments=false;
  Map title={
    'English':"MY MOMENTS",
    'Hindi':'मेरे मोमेंटस',
    'Spanish':'MIS MOMENTOS',
    'German':'MEINE MOMENTE',
    'French':'MES MOMENTS',
    'Japanese':'私の瞬間',
    'Russian':'МОИ МОМЕНТЫ',
    'Chinese':'我的时刻',
    'Portuguese':'MEUS MOMENTOS',
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white24,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title[lang],
                style: TextStyle(fontSize: 28,fontWeight: FontWeight.w400,color: Colors.black54),
              ),
              SizedBox(height: 17,),
              FutureBuilder(
                future: Future.wait([momentsReference.doc(currentUser.id).collection("userMoments").orderBy("timeStamp",descending: false).where("timeStamp", isGreaterThan: DateTime.now().subtract(Duration(days: 1))).get(),momentsReference.doc(currentUser.id).collection("userMoments").orderBy("timeStamp",descending: true).where("timeStamp", isLessThan: DateTime.now().subtract(Duration(days: 1))).get(),]),
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                    return Center(child: CircularProgressIndicator(),);
                  snapshot.data[1].docs.forEach((document){
                    String postId=document.data["postId"];
                    momentsStorageReference.child(("post_$postId.jpg")).delete();
                    document.reference.delete();
                  });
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data[0].docs.length,
                    itemBuilder: (context,index){
                      return BuildStories(
                        document: snapshot.data[0].docs[index],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildStories extends StatelessWidget {
  var document;
  int views=0;
  List<String> seenBy=[];
  BuildStories({this.document});
  String lang='English';
  Map viewText={
    'English':"Views",
    'Hindi':'देखा',
    'Spanish':'Vista',
    'German':'Gesehen',
    'French':'Vue',
    'Japanese':'見られる',
    'Russian':'Видимый',
    'Chinese':'看过',
    'Portuguese':'Visto',
  };
  Map noView={
    'English':"No Views",
    'Hindi':'नहीं देखा',
    'Spanish':'No Vista',
    'German':'Nicht gesehen',
    'French':'Non vu',
    'Japanese':'見られない',
    'Russian':'Не видел',
    'Chinese':'没见过',
    'Portuguese':'Não visto',
  };
  displayMoments(BuildContext context,{var document})async
  {
    List<dynamic> docs=[];
    docs.add(document);
    await Navigator.push(context, MaterialPageRoute(builder: (context)=>MomentsWidget(user: currentUser,documents: docs,)));
  }
  deleteMoments(BuildContext context)
  {
    momentsReference.doc(currentUser.id).collection("userMoments").doc(document.data["postId"]).delete();
    momentsStorageReference.child(currentUser.id).child("post_${document.data["postId"]}.jpg").delete();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyMoments()));
  }
  showSheet(BuildContext context)
  {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
        ),
        context: context,
        builder: (context){
          seenBy.remove(currentUser.id);
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10,bottom: 10),
                  child: Text(viewText[lang],style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.cyan[200],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                  ),
                ),
                seenBy.length!=0?ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: seenBy.length,
                  itemBuilder: (context,index){
                    return Viewers(
                      id: seenBy[index],
                    );
                  },
                ):Container(
                  height: 150,
                  child: Center(
                    child: Text(noView[lang],style: TextStyle(fontSize: 17),),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    seenBy=List.from(document.data()["seenBy"]);
    views=seenBy.length-1;
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return ListTile(
      onTap: (){showSheet(context);},
      leading: GestureDetector(child: CircleAvatar(radius: 25,backgroundImage: CachedNetworkImageProvider(document.data()["type"]=="image"?document.data()["url"]:document.data()["thumbnail"]),),onTap: (){displayMoments(context,document: document);},),
      title: Text(views.toString() + " "+viewText[lang],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17.0),),
      subtitle: Text(TimeAgo.timeAgoSinceDate(document.data()["timeStamp"].toDate(),lang),overflow: TextOverflow.ellipsis,),
      trailing: IconButton(
        onPressed: (){deleteMoments(context);},
        icon: Icon(Icons.delete),
      ),
    );
  }
}

class Viewers extends StatelessWidget {
  final String id;
  Viewers({this.id});
  UserModel user;
  String lang='English';

  displayUserProfile(BuildContext context,{String userProfileId})
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
  }
  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return FutureBuilder(
      future: usersReference.where("id",isEqualTo: id).get(),
      builder: (context,snapshot){
        if(!snapshot.hasData)
        {
          return Center(child: CircularProgressIndicator(),);
        }
        snapshot.data.documents.forEach((document){
          user=UserModel.fromDocument(document);
        });
        if(user!=null)
        {
          return ListTile(
            onTap: ()=>displayUserProfile(context,userProfileId: user.id),
            leading: user.url==""?CircleAvatar(radius: 24,backgroundColor: Colors.black12,child: Icon(Icons.person,size: 30.0,color: Colors.white,)):CircleAvatar(backgroundColor: Colors.black,backgroundImage: CachedNetworkImageProvider(user.url),),
            title: Text(user.username),
          );
        }
        else
          return Container();
      },
    );
  }
}