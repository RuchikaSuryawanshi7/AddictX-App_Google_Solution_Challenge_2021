import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/timeAgo.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/expertProfile.dart';
import 'package:addictx/pages/postPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class NotificationsItems extends StatelessWidget {
  final String username;
  final String type;
  final String commentData;
  final String postId;
  final String postOwnerId;
  final String userId;
  final String userProfileImg;
  final String postUrl;
  final Timestamp timeStamp;
  final String postType;
  Widget mediaPreview;
  String notificationItemText;
  NotificationsItems({this.username,this.type,this.commentData,this.postId,this.userId,this.postOwnerId,this.userProfileImg,this.postUrl,this.timeStamp,this.postType});

  factory NotificationsItems.fromDocument(DocumentSnapshot documentSnapshot){
    return NotificationsItems(
      username: documentSnapshot.data()["username"],
      type: documentSnapshot.data()["type"],
      commentData: documentSnapshot.data()["commentData"],
      postId: documentSnapshot.data()["postId"],
      userId: documentSnapshot.data()["userId"],
      postOwnerId: documentSnapshot.data()["postOwnerId"],
      userProfileImg: documentSnapshot.data()["userProfileImg"],
      postUrl: documentSnapshot.data()["postUrl"],
      timeStamp: documentSnapshot.data()["timeStamp"],
      postType: documentSnapshot.data()["postType"],
    );
  }

  String lang='English';
  Map likeText={
    'English':'Liked your post',
    'Hindi':'आपकी पोस्ट पसंद आई',
    'Spanish':'Me gustó tu publicación',
    'German':'Dein Beitrag hat mir gefallen',
    'French':"Aimé votre message",
    'Japanese':'あなたの投稿が気に入りました',
    'Russian':'Понравился ваш пост',
    'Chinese':'喜欢你的帖子',
    'Portuguese':'Gostou da sua postagem',
  };
  Map felt={
    'English':'Felt your problem',
    'Hindi':'आपकी समस्या महसूस की',
    'Spanish':'Sentí tu problema',
    'German':'Habe dein Problem gespürt',
    'French':"J'ai senti ton problème",
    'Japanese':'あなたの問題を感じた',
    'Russian':'Почувствовал твою проблему',
    'Chinese':'感觉到你的问题',
    'Portuguese':'Senti seu problema',
  };
  Map watch={
    'English':'Liked your AddictX Watch post',
    'Hindi':'आपकी एडिक्टएक्स वॉच पोस्ट पसंद आई',
    'Spanish':'Me gustó tu publicación de AddictX Watch',
    'German':'Gefällt mir für Ihren AddictX Watch-Beitrag',
    'French':"J'ai aimé votre publication AddictX Watch",
    'Japanese':'AddictXウォッチの投稿が気に入りました',
    'Russian':'Понравился ваш пост на AddictX Watch',
    'Chinese':'喜欢你的 AddictX Watch 帖子',
    'Portuguese':'Gostou da sua postagem do AddictX Watch',
  };
  Map comment={
    'English':'commented:',
    'Hindi':'टिप्पणी की:',
    'Spanish':'comentó:',
    'German':'kommentiert:',
    'French':"a commenté :",
    'Japanese':'コメント：',
    'Russian':'прокомментировал:',
    'Chinese':'评论道：',
    'Portuguese':'comentou:',
  };

  displayUserProfile(BuildContext context,{String userProfileId})async
  {
    DocumentSnapshot doc=await usersReference.doc(userProfileId).get();
    UserModel userModel=UserModel.fromDocument(doc);
    if(userModel.isExpert)
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpertProfile(userModel: userModel,isFromBottomNavigation: false,)));
  }
  displayPost(BuildContext context,{String postId})
  {
    if(postType=='video'||postType=='image'||postType=='addictXWatch')
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PostPage(docId: postId,isAddictXWatch: postType=='addictXWatch',)));
      }
  }
  configureMediaPreview(context)
  {
    if(postType!='text')
    {
      mediaPreview=GestureDetector(
        onTap: ()=>displayPost(context,postId: postId),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover,image: CachedNetworkImageProvider(postUrl)),
              ),
            ),
          ),
        ),
      );
    }
    else
    {
      mediaPreview=Text("");
    }
    if(type=="like post")
      notificationItemText=" "+likeText[lang]+' '+(postType=='text'?':- '+postUrl.substring(0,postUrl.length>30?30:postUrl.length)+'...':"");
    else if(type=="like problem")
      notificationItemText=" "+felt[lang]+' '+(postType=='text'?':- '+postUrl.substring(0,postUrl.length>30?30:postUrl.length)+'...':"");
    else if(type=="like addictXWatch")
      notificationItemText=" "+watch[lang]+' '+(postType=='text'?':- '+postUrl.substring(0,postUrl.length>30?30:postUrl.length)+'...':"");
    else if(type=="commented on your problem")
    {
      notificationItemText=" ${comment[lang]} $commentData";
      if(notificationItemText.length>55)
        notificationItemText=notificationItemText.substring(0,55)+"...";
      else
        notificationItemText=notificationItemText;
    }
    else
      notificationItemText=" Error, Unknown type =$type";
  }
  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey[100],
        ),
        child: type=="commented on your problem"?ListTile(
          title: RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 14.0,color: Colors.black),
                children: [
                  TextSpan(text: username,style: TextStyle(fontWeight: FontWeight.bold),recognizer: TapGestureRecognizer()..onTap=()=>displayUserProfile(context,userProfileId:userId)),
                  TextSpan(text: "$notificationItemText",),
                ]
            ),
          ),
          leading: GestureDetector(onTap: (){displayUserProfile(context,userProfileId:userId);},child: userProfileImg==""?CircleAvatar(radius: 24,child: Icon(Icons.person,size: 35.0,color: Colors.white,),backgroundColor: Colors.black12,):CircleAvatar(radius: 24,backgroundImage: CachedNetworkImageProvider(userProfileImg),),),
          subtitle: GestureDetector(onTap: (){displayUserProfile(context,userProfileId:userId);},child: Text(TimeAgo.timeAgoSinceDate(timeStamp.toDate(),lang),overflow: TextOverflow.ellipsis,)),
          trailing: mediaPreview,
        ):ListTile(
          title: GestureDetector(
            onTap: (){displayUserProfile(context,userProfileId:userId);},
            child: RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 14.0,color: Colors.black),
                  children: [
                    TextSpan(text: username,style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "$notificationItemText"),
                  ]
              ),
            ),
          ),
          leading: userProfileImg==""?CircleAvatar(radius: 24,child: Icon(Icons.person,size: 35.0,color: Colors.white,),backgroundColor: Colors.black12,):CircleAvatar(radius: 24,backgroundImage: CachedNetworkImageProvider(userProfileImg),),
          subtitle: Text(TimeAgo.timeAgoSinceDate(timeStamp.toDate(),lang),overflow: TextOverflow.ellipsis,),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}