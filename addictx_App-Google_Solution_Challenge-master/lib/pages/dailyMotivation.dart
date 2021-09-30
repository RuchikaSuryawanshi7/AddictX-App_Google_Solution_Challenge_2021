import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/myMoments.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/addMoments.dart';
import 'package:addictx/widgets/momentsWidget.dart';
import 'package:addictx/widgets/postWidget.dart';
import 'package:provider/provider.dart';

class DailyMotivation extends StatefulWidget {
  @override
  _DailyMotivationState createState() => _DailyMotivationState();
}

class _DailyMotivationState extends State<DailyMotivation> {
  List<String> ids=[];
  bool loading=true;
  List<Post> posts=[];
  ScrollController scrollController;
  bool load=false;
  var lastDoc;
  String lang='English';
  Map toastMessage={
    'English':'No more posts found',
    'Hindi':'कोई और पोस्ट नहीं मिली',
    'Spanish':'No se encontraron más publicaciones',
    'German':'Keine weiteren Beiträge gefunden',
    'French':'Plus de messages trouvés',
    'Japanese':'これ以上投稿は見つかりません',
    'Russian':'Больше сообщений не найдено',
    'Chinese':'没有找到更多帖子',
    'Portuguese':'Não foram encontradas mais postagens'
  };
  Map addMoments={
    'English':'Add Moments',
    'Hindi':'जोड़ें मोमेंटस',
    'Spanish':'Agregar momentos',
    'German':'Momente hinzufügen',
    'French':'Ajouter des moments',
    'Japanese':'モーメントを追加',
    'Russian':'Добавить моменты',
    'Chinese':'添加时刻',
    'Portuguese':'Adicionar momentos',
  };
  Map dailyFeed={
    'English':'DAILY FEED',
    'Hindi':'दैनिक फ़ीड',
    'Spanish':'ALIMENTACIÓN DIARIA',
    'German':'TÄGLICHES FUTTER',
    'French':'ALIMENTATION QUOTIDIENNE',
    'Japanese':'毎日の餌',
    'Russian':'ЕЖЕДНЕВНАЯ КОРМА',
    'Chinese':'每日饲料',
    'Portuguese':'ALIMENTAÇÃO DIÁRIA',
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
        await getMorePosts();
      }
    }
  }

  getMorePosts()async
  {
    QuerySnapshot querySnapshot=await postsReference
        .orderBy("timeStamp",descending: true)
        .startAfter([lastDoc['timeStamp']])
        .limit(10).get();
    if(querySnapshot!=null&&querySnapshot.docs.length>0)
      {
        lastDoc = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          posts.add(Post.fromDocument(doc));
        });
      }
    else
      showToast(toastMessage[lang]);
    setState(() {
      load=false;
    });
  }

  getData()async
  {
    QuerySnapshot snapshot=await usersReference.where('isExpert',isEqualTo: true).get();
    snapshot.docs.forEach((doc) {
      ids.add(doc.data()['id']);
    });

    QuerySnapshot querySnapshot=await postsReference.orderBy('timeStamp',descending: true).limit(10).get();
    querySnapshot.docs.forEach((doc) {
      posts.add(Post.fromDocument(doc));
    });
    lastDoc = querySnapshot.docs[querySnapshot.docs.length - 1];

    setState(() {
      loading=false;
    });
  }

  getPosts()
  {
    setState(() {
      loading=true;
    });
    ids.clear();
    posts.clear();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return loading?Center(child: CircularProgressIndicator(),):RefreshIndicator(
      onRefresh: ()async{return getPosts();},
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10,right: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    currentUser!=null&&currentUser.isExpert?GestureDetector(
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddMoments())),
                        onLongPress: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>MyMoments())),
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CircleAvatar(backgroundColor: Colors.black12,radius: 40,child: Icon(Icons.person,size: 80.0,color: Colors.white,)),
                            Text(addMoments[lang],style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        )
                    ):Container(),
                    ListView.builder(
                      padding: EdgeInsets.only(left: 10),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: ids.length,
                      itemBuilder: (context,index){
                        return Moments(
                          id: ids[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 13,),
            Text(
              '  '+dailyFeed[lang],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8,),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context,index)
              {
                return posts[index];
              },
            ),
            load?Center(child: CircularProgressIndicator(),):Container(),
          ],
        ),
      ),
    );
  }
}
class Moments extends StatefulWidget {
  final String id;
  Moments({this.id});

  @override
  _MomentsState createState() => _MomentsState();
}

class _MomentsState extends State<Moments> {
  UserModel user;
  bool show=true;

  List<bool> seen=[];

  displayMoments(BuildContext context,{UserModel user,var documents})async
  {
    await Navigator.push(context, MaterialPageRoute(builder: (context)=>MomentsWidget(user: user,documents: documents,seen:seen)));
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([usersReference.where("id",isEqualTo: widget.id).get(),momentsReference.doc(widget.id).collection("userMoments").orderBy("timeStamp",descending: false).where("timeStamp", isGreaterThan: DateTime.now().subtract(Duration(days: 1))).get(),momentsReference.doc(widget.id).collection("userMoments").orderBy("timeStamp",descending: true).where("timeStamp", isLessThan: DateTime.now().subtract(Duration(days: 1))).get(),]),
      builder: (context,snapshot){
        if(!snapshot.hasData)
        {
          return Center(child: CircularProgressIndicator(),);
        }
        snapshot.data[0].docs.forEach((document){
          user=UserModel.fromDocument(document);
        });
        if(currentUser!=null)
          {
            snapshot.data[2].docs.forEach((document){
              String postId=document.data()["postId"];
              momentsStorageReference.child(currentUser.id).child(("post_$postId.jpg")).delete();
              document.reference.delete();
            });
          }
        if(snapshot.data[1].docs.length==0)
          show=false;
        else
        {
          seen.clear();
          if(currentUser!=null)
            {
              snapshot.data[1].docs.forEach((document){
                if(List.from(document.data()["seenBy"]).contains(currentUser.id))
                  seen.add(true);
                else
                  seen.add(false);
              });
            }
        }
        return show?Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
              onTap: ()=>displayMoments(context,user: user,documents: snapshot.data[1].docs),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: seen.contains(false)?Colors.cyanAccent[400].withAlpha(60):Colors.grey[400].withAlpha(60),
                            blurRadius: 6.0,
                            spreadRadius: 6.0,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                          ),
                        ]
                    ),
                    child: CircleAvatar(
                      radius: 43,
                      backgroundColor: seen.contains(false)?Colors.cyan[200]:Colors.grey[300],
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(backgroundColor: Colors.black12,radius: 37,child: user.url==""?Icon(Icons.person,size: 65.0,color: Colors.white,) : CircleAvatar(radius: 37,backgroundColor: Colors.black,backgroundImage: CachedNetworkImageProvider(user.url),),),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(user.username,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                ],
              )
          ),
        ):Container();
      },
    );
  }
}