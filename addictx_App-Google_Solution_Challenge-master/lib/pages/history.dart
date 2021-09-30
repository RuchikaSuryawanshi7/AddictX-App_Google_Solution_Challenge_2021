import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/widgets/postWidget.dart';
import 'package:addictx/widgets/problemWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin{
  List<Post> posts=[];
  List<Problem> problems=[];
  ScrollController scrollControllerForMotivation;
  ScrollController scrollControllerForProblems;
  TabController tabController;
  bool load=false;
  var lastDocForPosts;
  var lastDocForProblems;
  bool loading=true;
  String lang='English';
  Map noPosts={
    'English':'No more posts found',
    'Hindi':'कोई और पोस्ट नहीं मिली',
    'Spanish':'No se encontraron más publicaciones',
    'German':'Keine weiteren Beiträge gefunden',
    'French':"Plus de messages trouvés",
    'Japanese':'これ以上投稿は見つかりません',
    'Russian':'Больше сообщений не найдено',
    'Chinese':'没有找到更多帖子',
    'Portuguese':'Não foram encontradas mais postagens',
  };
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
  Map title={
    'English':'History',
    'Hindi':'इतिहास',
    'Spanish':'Historia',
    'German':'Geschichte',
    'French':"Histoire",
    'Japanese':'歴史',
    'Russian':'История',
    'Chinese':'历史',
    'Portuguese':'História',
  };
  Map dailyMotivationText={
    'English':'DAILY MOTIVATION',
    'Hindi':'दैनिक प्रेरणा',
    'Spanish':'MOTIVACIÓN DIARIA',
    'German':'TÄGLICHE MOTIVATION',
    'French':"MOTIVATION AU QUOTIDIEN",
    'Japanese':'毎日のモチベーション',
    'Russian':'ЕЖЕДНЕВНАЯ МОТИВАЦИЯ',
    'Chinese':'每日动力',
    'Portuguese':'MOTIVAÇÃO DIÁRIA',
  };
  Map speakAloudText={
    'English':'SPEAK LOUD',
    'Hindi':'व्यक्त करें',
    'Spanish':'HABLA ALTO',
    'German':'SPRICH LAUT',
    'French':"PARLE FORT",
    'Japanese':'大声で話す',
    'Russian':'ГОВОРИТЬ ГРОМКО',
    'Chinese':'大声说出来',
    'Portuguese':'FALAR ALTO',
  };

  @override
  void initState() {
    tabController= new TabController(vsync: this, length: 2,initialIndex: 0);
    scrollControllerForMotivation = new ScrollController()..addListener(_scrollListener);
    scrollControllerForProblems = new ScrollController()..addListener(scrollListener);
    getData();
    super.initState();
  }

  @override
  void dispose() {
    scrollControllerForMotivation.removeListener(_scrollListener);
    scrollControllerForMotivation.dispose();
    scrollControllerForProblems.removeListener(scrollListener);
    scrollControllerForProblems.dispose();
    super.dispose();
  }
  void _scrollListener()async{
    if (!loading&&!load) {
      if (scrollControllerForMotivation.position.pixels == scrollControllerForMotivation.position.maxScrollExtent) {
        setState(() => load = true);
        await getMorePosts();
      }
    }
  }
  void scrollListener()async{
    if (!loading&&!load) {
      if (scrollControllerForMotivation.position.pixels == scrollControllerForMotivation.position.maxScrollExtent) {
        setState(() => load = true);
        await getMoreProblems();
      }
    }
  }
  getMorePosts()async
  {
    QuerySnapshot querySnapshot=await postsReference
          .where('ownerId',isEqualTo: currentUser.id)
          .orderBy("timeStamp",descending: true)
          .startAfter([lastDocForPosts['timeStamp']])
          .limit(10).get();
    if(querySnapshot!=null&&querySnapshot.docs.length>0)
    {
      lastDocForPosts = querySnapshot.docs[querySnapshot.docs.length - 1];
      querySnapshot.docs.forEach((doc) {
        posts.add(Post.fromDocument(doc));
      });
    }
    else
      showToast(noPosts[lang]);
    setState(() {
      load=false;
    });
  }

  getMoreProblems()async
  {
    QuerySnapshot querySnapshot=await problemsReference
          .where('ownerId',isEqualTo: currentUser.id)
          .orderBy("timeStamp",descending: true)
          .startAfter([lastDocForProblems['timeStamp']])
          .limit(10).get();
    if(querySnapshot!=null&&querySnapshot.docs.length>0)
    {
      lastDocForProblems = querySnapshot.docs[querySnapshot.docs.length - 1];
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
    QuerySnapshot querySnapshotForPosts=await postsReference.where('ownerId',isEqualTo: currentUser.id).orderBy('timeStamp',descending: true).limit(10).get();
    QuerySnapshot querySnapshotForProblems=await problemsReference.where('ownerId',isEqualTo: currentUser.id).orderBy('timeStamp',descending: true).limit(10).get();
    querySnapshotForPosts.docs.forEach((doc) {
      posts.add(Post.fromDocument(doc));
    });
    querySnapshotForProblems.docs.forEach((doc) {
      problems.add(Problem.fromDocument(doc));
    });
    if(querySnapshotForProblems.docs.isNotEmpty)
      {
        lastDocForProblems = querySnapshotForProblems.docs[querySnapshotForProblems.docs.length - 1];
      }
    if(querySnapshotForPosts.docs.isNotEmpty)
      lastDocForPosts = querySnapshotForPosts.docs[querySnapshotForPosts.docs.length - 1];

    setState(() {
      loading=false;
    });
  }

  dailyMotivation()
  {
    return SingleChildScrollView(
      controller: scrollControllerForMotivation,
      child: Column(
        children: [
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
    );
  }

  speakAloud()
  {
    return SingleChildScrollView(
      controller: scrollControllerForProblems,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: problems.length,
            itemBuilder: (context,index)
            {
              return problems[index];
            },
          ),
          load?Center(child: CircularProgressIndicator(),):Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
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
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Color(0xc277d5f8),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: dailyMotivationText[lang],),
            Tab(text: speakAloudText[lang],),
          ],
        ),
      ),
      body: loading?Center(child:CircularProgressIndicator(),):TabBarView(
        controller: tabController,
        children: [
          dailyMotivation(),
          speakAloud(),
        ],
      ),
    );
  }
}
