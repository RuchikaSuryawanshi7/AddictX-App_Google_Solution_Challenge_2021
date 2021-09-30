import 'dart:async';
import 'package:addictx/home.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/helpers/timeAgo.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AddictxWatchWidget extends StatefulWidget {
  final String id;
  final Timestamp timestamp;
  final String url;
  final String ownerId;
  final List<String> likes;
  final List<String> views;
  final String thumbnail;

  AddictxWatchWidget({this.id,this.timestamp,this.url,this.ownerId,this.likes,this.views,this.thumbnail});

  factory AddictxWatchWidget.fromDocument(DocumentSnapshot documentSnapshot)
  {
    return AddictxWatchWidget(
      id: documentSnapshot.data()["id"],
      timestamp: documentSnapshot.data()['timeStamp'],
      url: documentSnapshot.data()['url'],
      ownerId: documentSnapshot.data()['ownerId'],
      likes: List.from(documentSnapshot.data()['likes']),
      views: List.from(documentSnapshot.data()['views']),
      thumbnail: documentSnapshot.data()['thumbnail'],
    );
  }

  @override
  _AddictxWatchWidgetState createState() => _AddictxWatchWidgetState(
    id:this.id,
    timestamp: this.timestamp,
    url:this.url,
    ownerId:this.ownerId,
    likes:this.likes,
    views: this.views,
    thumbnail: this.thumbnail,
  );
}

class _AddictxWatchWidgetState extends State<AddictxWatchWidget> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<AddictxWatchWidget>{
  final String id;
  final Timestamp timestamp;
  final String url;
  final String ownerId;
  final List<String> likes;
  final List<String> views;
  final String thumbnail;
  bool showHeart=false;
  bool isLiked=false;
  AnimationController _controller;
  CachedVideoPlayerController _videoPlayerController;
  bool showPause=false;
  bool showPlay=false;
  bool isMute=false;
  _AddictxWatchWidgetState({this.id,this.timestamp,this.url,this.ownerId,this.likes,this.views,this.thumbnail});

  String lang='English';
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
  Map delPost={
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
    _videoPlayerController = CachedVideoPlayerController.network(url)..setLooping(true)..initialize().then((_) {
      setState(() { });
    });
    _controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _controller.repeat(reverse: true);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose()
  {
    _videoPlayerController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  removeLike()
  {
    bool isNotPostOwner=currentUser.id!=ownerId;
    if(isNotPostOwner)
    {
      notificationsReference.doc(ownerId).collection("notificationItems")
          .where("type",isEqualTo: "like addictXWatch")
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
        "postType":"addictXWatch",
        "type": "like addictXWatch",
        "username": currentUser.username,
        "userId": currentUser.id,
        "postOwnerId":ownerId,
        "timeStamp": DateTime.now(),
        "postId": id,
        "userProfileImg": currentUser.url,
        "postUrl":thumbnail,
        "commentData":'',
      });
    }
  }

  controlUserLikePost(bool doubleTap)
  {
    bool _liked=likes.contains(currentUser.id);
    if(_liked&&!doubleTap)
    {
      addictXWatchReference.doc(id).update({
        'likes':FieldValue.arrayRemove([currentUser.id]),
        'likeCount':FieldValue.increment(-1),
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
      addictXWatchReference.doc(id).update({
        'likes':FieldValue.arrayUnion([currentUser.id]),
        'likeCount':FieldValue.increment(1),
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

  controlViews()
  {
    views.add(currentUser.id);
    addictXWatchReference.doc(id).update({
      "views":FieldValue.arrayUnion([currentUser.id]),
    });
  }
  controlVideoPauseAndPlay()
  {
    if(_videoPlayerController.value.isPlaying)
    {
      _videoPlayerController.pause();
      setState(() {
        showPause=true;
      });
      Timer(Duration(milliseconds: 500),(){
        setState(() {
          showPause=false;
        });
      });
    }
    else
    {
      _videoPlayerController.play();
      setState(() {
        showPlay=true;
      });
      Timer(Duration(milliseconds: 500),(){
        setState(() {
          showPlay=false;
        });
      });
    }
  }
  controlAudio()
  {
    if(isMute)
    {
      setState(() {
        _videoPlayerController.setVolume(1.0);
        isMute=false;
      });
    }
    else
    {
      setState(() {
        _videoPlayerController.setVolume(0.0);
        isMute=true;
      });
    }
  }

  removeUserPost()async
  {
    await addictXWatchReference.doc(id).get().then((document) {
      if(document.exists)
      {
        document.reference.delete();
      }
    });
  }

  deletePost(BuildContext context,)
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
            removeUserPost();
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

  moreDetails(BuildContext context,)
  {
    return showDialog(
        context: context,
        builder:(context){
          return SimpleDialog(
            title: Text(moreTitle[lang],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.cyan),),
            children: <Widget>[
              currentUser.id==ownerId?SimpleDialogOption(
                child: Text(delPost[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){
                  deletePost(context);
                },
              ):Container(),
              currentUser.id==ownerId?Container():SimpleDialogOption(
                child: Text(report[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){
                  Navigator.pop(context);
                  showReportDialogBox(
                    context,
                    type: "Post",
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
            padding: EdgeInsets.all(10),
            color: isLiked?const Color(0xffeff8fb):const Color(0xfff0f0f0),
            child: FutureBuilder(
              future: usersReference.doc(ownerId).get(),
              builder: (context,snapshot)
              {
                if(!snapshot.hasData)
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.3,
                    child: Center(child: CircularProgressIndicator(),),
                  );
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userModel.username,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: ()=>currentUser!=null?controlUserLikePost(false):showToast(login[lang]),
                              child: Align(
                                child: ScaleTransition(
                                  scale: Tween(begin: 0.75, end: 1.0)
                                      .animate(CurvedAnimation(
                                      parent: _controller,
                                      curve: Curves.elasticOut
                                  ),
                                  ),
                                  child: isLiked?Icon(Icons.favorite,size: 26,color: Color(0xffff5588),):Icon(Icons.favorite,size: 26,color :const Color(0xffcccccc),),
                                ),
                              ),
                            ),
                            SizedBox(width: 3,),
                            Text(likes.length.toString(),style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w400),),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: VisibilityDetector(
                        key: Key(url),
                        onVisibilityChanged: (VisibilityInfo info) {
                          debugPrint("${info.visibleFraction} of my widget is visible");
                          if(info.visibleFraction <0.55){
                            _videoPlayerController.pause();
                          }
                          else{
                            _videoPlayerController.play();
                            if(!views.contains(currentUser.id))
                            {
                              controlViews();
                            }
                          }
                        },
                        child: ValueListenableBuilder(
                          valueListenable: _videoPlayerController,
                          builder: (context,value,child){
                            return _videoPlayerController.value.initialized?Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onLongPress: (){if(currentUser!=null)moreDetails(context);},
                                  onTap: (){controlVideoPauseAndPlay();},
                                  child: Container(
                                    color: Colors.white,
                                    height: _videoPlayerController.value.aspectRatio>1.5?null:MediaQuery.of(context).size.height/2,
                                    alignment: Alignment.center,
                                    child: AspectRatio(
                                        aspectRatio: _videoPlayerController.value.aspectRatio,
                                        child: CachedVideoPlayer(_videoPlayerController,)
                                    ),
                                  ),
                                ),
                                Container(padding: EdgeInsets.only(left: 6,top: 6),child: Text((value.duration.inSeconds-value.position.inSeconds).toString()+"s",style: TextStyle(fontSize: 16.5),)),
                                GestureDetector(onTap: (){controlAudio();},child: Container(child: Icon(isMute?Icons.volume_off:Icons.volume_up),alignment: Alignment.topRight,padding: EdgeInsets.only(right: 10,top: 10),))
                              ],
                            ):Center(child: CircularProgressIndicator(),);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 12,),
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
        showPause?Icon(Icons.pause,color: Colors.white,size: 50,):Container(),
        showPlay?Icon(Icons.play_arrow,color: Colors.white,size: 50,):Container(),
      ],
    );
  }
}