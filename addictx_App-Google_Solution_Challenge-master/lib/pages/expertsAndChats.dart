import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/chatRoom.dart';
import 'package:addictx/widgets/expertTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpertsAndChats extends StatefulWidget {
  @override
  _ExpertsAndChatsState createState() => _ExpertsAndChatsState();
}

class _ExpertsAndChatsState extends State<ExpertsAndChats> with SingleTickerProviderStateMixin{
  TabController tabController;
  ScrollController scrollController;
  var lastDoc;
  QuerySnapshot snapshot;
  bool loading=true;
  bool load=false;
  String lang='English';
  Map toastMessage={
    'English':'No more experts found',
    'Hindi':'कोई और विशेषज्ञ नहीं मिला',
    'Spanish':'No más expertas encontradas',
    'German':'Keine Experten mehr gefunden',
    'French':"Aucun autre expert trouvé",
    'Japanese':'これ以上専門家は見つかりませんでした',
    'Russian':'Больше экспертов не найдено',
    'Chinese':'找不到更多专家',
    'Portuguese':'Nenhum outro especialista encontrado',
  };
  Map ourExperts={
    'English':'Our Experts',
    'Hindi':'हमारे विशेषज्ञ',
    'Spanish':'Nuestras Expertas',
    'German':'Unsere Experten',
    'French':"Nos experts",
    'Japanese':'私たちの専門家',
    'Russian':'Наши специалисты',
    'Chinese':'我们的专家',
    'Portuguese':'Nossos especialistas',
  };
  Map chats={
    'English':'Chats',
    'Hindi':'चैट',
    'Spanish':'Chats',
    'German':'Chats',
    'French':"Discussions",
    'Japanese':'チャット',
    'Russian':'Чаты',
    'Chinese':'聊天',
    'Portuguese':'Chats',
  };


  @override
  void initState() {
    tabController= new TabController(vsync: this, length: 2,initialIndex: 0);
    scrollController = new ScrollController()..addListener(_scrollListener);
    getExperts();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void _scrollListener()async{
    if (!loading&&!load) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        setState(() => load = true);
        await getMoreExperts();
      }
    }
  }

  getMoreExperts()async
  {
    QuerySnapshot querySnapshot=await usersReference
        .orderBy('likes',descending: true)
        .where('isExpert',isEqualTo: true)
        .startAfter([lastDoc['id']])
        .limit(10).get();
    if(querySnapshot!=null&&querySnapshot.docs.length>0)
    {
      lastDoc = querySnapshot.docs[querySnapshot.docs.length - 1];
      snapshot.docs.addAll(querySnapshot.docs);
    }
    else
      showToast(toastMessage[lang]);
    setState(() {
      load=false;
    });
  }

  getExperts()async
  {
    snapshot=await usersReference.orderBy('likes',descending: true).where('isExpert',isEqualTo: true).limit(10).get();
    lastDoc = snapshot.docs[snapshot.docs.length - 1];
    setState(() {
      loading=false;
    });
  }

  Widget listOfExperts()
  {
    return loading?Center(child: CircularProgressIndicator(),):ListView.separated(
      padding: EdgeInsets.fromLTRB(8, 15, 8, 10),
      itemCount: snapshot.docs.length,
      shrinkWrap: true,
      separatorBuilder: (context,index)=>SizedBox(height: 10,),
      itemBuilder: (context,index){
        UserModel userModel=UserModel.fromDocument(snapshot.docs[index]);
        return ExpertTile(userModel: userModel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height/9,
        elevation: 0.0,
        actions: [
          Center(
            child: Text.rich(
              TextSpan(
                text: "ADDICT",
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 25.0,color: Colors.black),
                children: [
                  TextSpan(
                    text: "X ",
                    style: TextStyle(color: const Color(0xff9ad0e5),),
                  ),
                ],
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
          indicatorColor: const Color(0xff9ad0e5),
          labelColor: const Color(0xff9ad0e5),
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: ourExperts[lang],),
            Tab(text: chats[lang],),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                listOfExperts(),
                ChatRoom(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
