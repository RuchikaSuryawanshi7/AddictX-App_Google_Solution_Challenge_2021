import 'dart:async';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/home.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/widgets/commentsSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/helpers/timeAgo.dart';
import 'package:provider/provider.dart';

class Problem extends StatefulWidget {
  final String id;
  final Timestamp timestamp;
  final String question;
  final String ownerId;
  final List<String> likes;
  Problem({this.id,this.timestamp,this.question,this.ownerId,this.likes});

  factory Problem.fromDocument(DocumentSnapshot documentSnapshot)
  {
    return Problem(
      id: documentSnapshot.data()["id"],
      timestamp: documentSnapshot.data()['timeStamp'],
      question: documentSnapshot.data()['question'],
      ownerId: documentSnapshot.data()['ownerId'],
      likes: List.from(documentSnapshot.data()['likes']),
    );
  }

  @override
  _ProblemState createState() => _ProblemState(
    id:this.id,
    timestamp: this.timestamp,
    question:this.question,
    ownerId:this.ownerId,
    likes:this.likes,
  );
}

class _ProblemState extends State<Problem> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Problem>{
  final String id;
  final Timestamp timestamp;
  final String question;
  final String ownerId;
  final List<String> likes;
  bool showHeart=false;
  bool isLiked=false;
  AnimationController _controller;
  _ProblemState({this.id,this.timestamp,this.question,this.ownerId,this.likes});

  String lang="English";
  Map dialogTitle={
    'English':"Delete Post",
    'Hindi':'पोस्ट को हटाएं',
    'Spanish':'Eliminar mensaje',
    'German':'Beitrag entfernen',
    'French':'Supprimer le message',
    'Japanese':'投稿を削除',
    'Russian':'Удалить сообщение',
    'Chinese':'删除帖子',
    'Portuguese':'Apague a postagem',
  };
  Map dialogContent={
    'English':"Are you sure you want to delete your post?",
    'Hindi':'क्या आप वाकई अपनी पोस्ट हटाना चाहते हैं?',
    'Spanish':'¿Estás segura de que quieres eliminar tu publicación?',
    'German':'Möchten Sie Ihren Beitrag wirklich löschen?',
    'French':'Êtes-vous sûr de vouloir supprimer votre message ?',
    'Japanese':'投稿を削除してもよろしいですか？',
    'Russian':'Вы уверены, что хотите удалить свой пост?',
    'Chinese':'您确定要删除您的帖子吗？',
    'Portuguese':'Tem certeza que deseja deletar sua postagem?',
  };
  Map delete={
    'English':"Delete",
    'Hindi':'हटाएं',
    'Spanish':'Borrar',
    'German':'Löschen',
    'French':'Effacer',
    'Japanese':'削除',
    'Russian':'Удалить',
    'Chinese':'删除',
    'Portuguese':'Excluir',
  };
  Map deleteToast={
    'English':"Post is deleted..",
    'Hindi':'पोस्ट हटा दी गई है..',
    'Spanish':'La publicación está eliminada ...',
    'German':'Beitrag ist gelöscht..',
    'French':'Le message est supprimé..',
    'Japanese':'投稿が削除されます。',
    'Russian':'Сообщение удалено ..',
    'Chinese':'帖子被删了。。',
    'Portuguese':'A postagem foi excluída ..',
  };
  Map moreTitle={
    'English':"What do you want",
    'Hindi':'क्या चाहते हो तुम',
    'Spanish':'Qué quieres',
    'German':'Was willst du',
    'French':"Que veux-tu",
    'Japanese':'なんでしょう',
    'Russian':'Что ты хочешь',
    'Chinese':'你想要什么',
    'Portuguese':'O que você quer',
  };
  Map delQues={
    'English':"Delete this post",
    'Hindi':'इस पोस्ट को डीलीट करें',
    'Spanish':'Borra esta publicación',
    'German':'Lösche diesen Beitrag',
    'French':"Supprimer ce post",
    'Japanese':'この投稿を削除する',
    'Russian':'Удалить это сообщение',
    'Chinese':'删除这个帖子',
    'Portuguese':'Excluir esta postagem',
  };
  Map report={
    'English':"Report this post",
    'Hindi':'इस पोस्ट को रिपोर्ट करे',
    'Spanish':'Reportar esta publicación',
    'German':'Diesen Post melden',
    'French':"Signaler cette publication",
    'Japanese':'この投稿を報告する',
    'Russian':'Пожаловаться на эту публикацию',
    'Chinese':'举报此帖子',
    'Portuguese':'Denunciar esta postagem',
  };
  Map cancel={
    'English':"Cancel",
    'Hindi':'नहीं',
    'Spanish':'Cancelar',
    'German':'Stornieren',
    'French':"Annuler",
    'Japanese':'キャンセル',
    'Russian':'Отмена',
    'Chinese':'取消',
    'Portuguese':'Cancelar',
  };
  Map login={
    'English':'Login to like the post',
    'Hindi':'पोस्ट को लाइक करने के लिए लॉग इन करें',
    'Spanish':'Iniciar sesión para dar me gusta a la publicación',
    'German':'Melden Sie sich an, um den Beitrag zu liken',
    'French':"Connectez-vous pour aimer la publication",
    'Japanese':'投稿を高く評価するにはログインしてください',
    'Russian':'Авторизуйтесь, чтобы лайкнуть пост',
    'Chinese':'登录喜欢帖子',
    'Portuguese':'Faça login para curtir a postagem',
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void initState()
  {
    if(currentUser!=null)
    {
      isLiked=likes.contains(currentUser.id);
    }
    _controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _controller.repeat(reverse: true);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose()
  {
    _controller.dispose();
    super.dispose();
  }

  removeLike()
  {
    bool isNotPostOwner=currentUser.id!=ownerId;
    if(isNotPostOwner)
    {
      notificationsReference.doc(ownerId).collection("notificationItems")
          .where("type",isEqualTo: "like problem")
          .where("userId",isEqualTo: currentUser.id)
          .where("postId",isEqualTo: id)
          .get().then((snapshot){
        snapshot.docs.first.reference.delete();
      });
    }
  }

  addLike() {
    bool isNotPostOwner=currentUser.id!=ownerId;
    if (isNotPostOwner) {
      notificationsReference.doc(ownerId).collection("notificationItems").add({
        "postType":'text',
        "username": currentUser.username,
        "userId": currentUser.id,
        "postOwnerId":ownerId,
        "timeStamp": DateTime.now(),
        "postId": id,
        "userProfileImg": currentUser.url,
        "postUrl":question,
        "commentData":'',
        "type": "like problem",
      });
    }
  }

  controlUserLikePost(bool doubleTap)
  {
    bool _liked=likes.contains(currentUser.id);
    if(_liked&&!doubleTap)
    {
      problemsReference.doc(id).update({
        'likes':FieldValue.arrayRemove([currentUser.id]),
      });
      removeLike();
      setState(() {
        isLiked=false;
        likes.remove(currentUser.id);
      });
      _controller.reset();
      _controller.forward();
    }
    else if(!_liked)
    {
      problemsReference.doc(id).update({
        'likes':FieldValue.arrayUnion([currentUser.id]),
      });
      addLike();
      setState(() {
        likes.add(currentUser.id);
        isLiked=true;
        showHeart=true;
        Timer(Duration(milliseconds: 800),(){
          setState(() {
            showHeart=false;
          });
        });
      });
      _controller.reset();
      _controller.forward();
    }
  }

  moreDetails(BuildContext context,)
  {
    return showDialog(
        context: context,
        builder:(context){
          return SimpleDialog(
            title: Text(moreTitle[lang],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.cyan),),
            children: <Widget>[
              currentUser.id==ownerId?SimpleDialogOption(
                child: Text(delQues[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){
                  deleteQuestion(context);
                },
              ):Container(),
              currentUser.id==ownerId?Container():SimpleDialogOption(
                child: Text(report[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){
                  Navigator.pop(context);
                  showReportDialogBox(
                    context,
                    type: "Question",
                    choice1: "Spam",
                    choice2: "Inappropriate content",
                    choice3: "Offensive",
                    reportedId: id,
                    reporterId: currentUser.id,
                  );
                },
              ),
              SimpleDialogOption(
                child: Text(cancel[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  deleteQuestion(BuildContext context,)
  {
    var alertDialog=AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      title: Text(dialogTitle[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.cyan),),
      content: Text(dialogContent[lang],style: TextStyle(fontSize: 17),),
      actions: <Widget>[
        RaisedButton(
          child: Text(delete[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          onPressed: (){
            Navigator.pop(context);
            removeUserQuestion();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
            showToast(deleteToast[lang]);
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
        ),
        RaisedButton(
          child: Text(cancel[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          onPressed: (){
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialog;
        });
  }

  removeUserQuestion()async
  {
    await problemsReference.doc(id).get().then((document) {
      if(document.exists)
      {
        document.reference.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onDoubleTap: ()=>currentUser!=null?controlUserLikePost(true):showToast(login[lang]),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.fromLTRB(10,0,10,0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: isLiked?Color(0xffeff8fb):Color(0xfff8f8f8),
            ),
            child: FutureBuilder(
              future: usersReference.doc(ownerId).get(),
              builder: (context,snapshot)
              {
                if(!snapshot.hasData)
                  return Center(child: CircularProgressIndicator(),);
                UserModel userModel=UserModel.fromDocument(snapshot.data);
                return Column(
                  children: [
                    Row(
                      children: [
                        userModel.url!=''?CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(userModel.url),
                        ):CircleAvatar(
                          backgroundColor: Colors.black38,
                          child: Icon(Icons.person,color: Colors.white,),
                        ),
                        SizedBox(width: 10,),
                        Text(userModel.username,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                        Spacer(),
                        currentUser!=null?IconButton(icon: Icon(Icons.more_vert), onPressed: (){moreDetails(context);}):Container(),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: EdgeInsets.only(left:10.0,right: 10),
                      child: Text(question,style: GoogleFonts.gugi(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                        ),
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 12,),
                    Row(
                      children: [
                        Text(TimeAgo.timeAgoSinceDate(timestamp.toDate(),lang)),
                        Spacer(),
                        IconButton(icon: Icon(Icons.mode_comment,color: Color(0xffa0e6ff),), onPressed: (){bottomSheetForComments(context,widget.id,widget.ownerId);}),
                        GestureDetector(
                          onTap: ()=>currentUser!=null?controlUserLikePost(false):showToast(login[lang]),
                          child: Align(
                            child: ScaleTransition(
                              scale: Tween(begin: 0.75, end: 1.0)
                                  .animate(CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.elasticOut,
                              ),
                              ),
                              child: isLiked?Icon(Icons.favorite,size: 30,color: const Color(0xffff5588),):Icon(Icons.favorite_border,size: 30,),
                            ),
                          ),
                        ),
                        Text(likes.length.toString()),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        showHeart?Align(
          child: ScaleTransition(
              scale: Tween(begin: 0.75, end: 1.0)
                  .animate(CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticOut
              ),
              ),
              child: Icon(Icons.favorite,color: Color(0xffff5588),size: 120,)
          ),
        ):Container(),
      ],
    );
  }
}