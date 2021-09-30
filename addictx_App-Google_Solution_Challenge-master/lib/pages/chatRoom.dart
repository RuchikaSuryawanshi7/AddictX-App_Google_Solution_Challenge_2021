import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/chattingPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController searchTextEditingController=TextEditingController();
  int currentCount=0;
  Map login={
    'English':"Login to start a chat",
    'Hindi':'चैट शुरू करने के लिए लॉगिन करें',
    'Spanish':'Inicie sesión para iniciar un chat',
    'German':'Melden Sie sich an, um einen Chat zu starten',
    'French':"Connectez-vous pour démarrer une discussion",
    'Japanese':'ログインしてチャットを開始します',
    'Russian':'Войдите, чтобы начать чат',
    'Chinese':'登录开始聊天',
    'Portuguese':'Faça login para iniciar um bate-papo',
  };

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomReference.where('ids', arrayContains: currentUser.id).orderBy("timeStamp",descending: true).snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              String recieverAvatar;
              String recieverId,recieverName;
              var users=List.from(snapshot.data.docs[index].data()["users"]);
              var ids=List.from(snapshot.data.docs[index].data()["ids"]);
              recieverName=users[0]==currentUser.username?users[1]:users[0];
              currentUser.url==snapshot.data.docs[index].data()["Avatar1"]?recieverAvatar=snapshot.data.docs[index].data()["Avatar2"]:recieverAvatar=snapshot.data.docs[index].data()["Avatar1"];
              recieverId=ids[0]==currentUser.id?ids[1]:ids[0];
              return ChatRoomsTile(
                userName: recieverName,
                recieverAvatar: recieverAvatar,
                recieverId:recieverId,
                lastMessageType: snapshot.data.docs[index].data()['type'],
                lastMessage: snapshot.data.docs[index].data()['message'],
                sendBy: snapshot.data.docs[index].data()['sendBy'],
                messageCount: snapshot.data.docs[index].data()['messageCount'],
                recieverMessageCount: snapshot.data.docs[index].data()['${recieverId}messageCount'],
                count: snapshot.data.docs[index].data()['${currentUser.id}messageCount'],
                timestamp: snapshot.data.docs[index].data()['timeStamp'],
              );
            })
            : Center(child: CircularProgressIndicator(),);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 25,),
              currentUser!=null?Container(
                child: chatRoomsList(),
              ):Center(
                child: Text(login[lang]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String recieverAvatar;
  final String recieverId;
  final int lastMessageType;
  String lastMessage;
  final String sendBy;
  int count;
  bool seenMessage=false;
  final int messageCount;
  final int recieverMessageCount;
  final Timestamp timestamp;
  String lang='English';

  ChatRoomsTile({this.userName,this.recieverAvatar,this.recieverId,this.lastMessageType,this.lastMessage,this.sendBy,this.count,this.messageCount,this.recieverMessageCount,this.timestamp});
  Map you={
    'English':"You",
    'Hindi':'आप',
    'Spanish':'Tú',
    'German':'Sie',
    'French':"Toi",
    'Japanese':'君は',
    'Russian':'Ты',
    'Chinese':'你',
    'Portuguese':'Vocês',
  };
  Map sharedPhoto={
    'English':"shared a photo",
    'Hindi':'एक तस्वीर साझा की',
    'Spanish':'compartió una foto',
    'German':'ein Foto geteilt shared',
    'French':"a partagé une photo",
    'Japanese':'写真を共有しました',
    'Russian':'поделился фотографией',
    'Chinese':'分享了一张照片',
    'Portuguese':'compartilhou uma foto',
  };

  getLastMessage()
  {
    if(lastMessageType==0)
      lastMessage=sendBy==currentUser.id?"${you[lang]}: "+lastMessage:lastMessage;
    else if(lastMessageType==1)
      lastMessage=sendBy==currentUser.id?"${you[lang]}: "+sharedPhoto[lang]:sharedPhoto[lang];
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    seenMessage=recieverMessageCount>=messageCount?true:false;
    getLastMessage();
    count=messageCount-count;
    print(count);
    count=count>=0?count:0;
    String formattedTime=timestamp!=null?DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp.seconds*1000)):"";
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(
            recieverAvatar: recieverAvatar,
            recieverName: userName,
            recieverId:recieverId,
          ),
        ));
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[200].withAlpha(60),
                  blurRadius: 8.0,
                  spreadRadius: -9.0,
                  offset: Offset(
                    0.0,
                    15.0,
                  ),
                ),
              ],
            ),
            child: ListTile(
              leading: recieverAvatar==""?CircleAvatar(radius: 24,child: Icon(Icons.person,size: 30,color: Colors.white,),backgroundColor: Colors.black12,):CircleAvatar(radius: 24,backgroundImage: CachedNetworkImageProvider(recieverAvatar,),),
              title: Text(userName,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),),
              subtitle: Text(lastMessage,style: TextStyle(fontSize: 15,color: Colors.grey[500]),overflow: TextOverflow.ellipsis,),
              trailing: count!=0?Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(radius: 13,child: Text(count.toString(),style: TextStyle(color: Colors.white),),backgroundColor: Colors.cyan[200],),
                  SizedBox(height: 5,),
                  Text(formattedTime,style: TextStyle(fontSize: 11),),
                ],
              ):Text(formattedTime,style: TextStyle(fontSize: 11),),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            left: 10,
            child: Container(
              height: 3.0,
              color: sendBy==currentUser.id?seenMessage?const Color(0xff9ad0e5):const Color(0xffb8b8b8):Colors.transparent,
            )
          ),
        ],
      ),
    );
  }
}