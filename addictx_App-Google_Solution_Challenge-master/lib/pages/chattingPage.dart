import 'dart:io';
import 'dart:async';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/chatRoomRelated.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/expertProfile.dart';
import 'package:addictx/widgets/fullPhoto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class Chat extends StatefulWidget {
  final String recieverAvatar;
  final String recieverName;
  final String recieverId;

  Chat({this.recieverAvatar,this.recieverName,this.recieverId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  Stream<QuerySnapshot> chats;
  Stream<QuerySnapshot> chatRoomStream;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController listScrollController=ScrollController();
  bool isLoading=false;
  bool _isLoading=false;
  final picker=ImagePicker();
  File _image;
  String imageUrl;
  String chatId;
  var listMessage;
  String chatRoomId;
  int limit=15;
  Map<String, dynamic> chatRoom={};
  GlobalKey btnKey = GlobalKey();
  PopupMenu menu;

  String lang='English';
  Map camera={
    'English':"Camera",
    'Hindi':'कैमरा',
    'Spanish':'Cámara',
    'German':'Kamera',
    'French':"Caméra",
    'Japanese':'カメラ',
    'Russian':'Камера',
    'Chinese':'相机',
    'Portuguese':'Câmera',
  };
  Map image={
    'English':"Image",
    'Hindi':'छवि',
    'Spanish':'Imagen',
    'German':'Bild',
    'French':"Image",
    'Japanese':'画像',
    'Russian':'Изображение',
    'Chinese':'图像',
    'Portuguese':'Imagem',
  };
  Map sendMessage={
    'English':"Send Message ...",
    'Hindi':'मेसेज भेजें ...',
    'Spanish':'Enviar mensaje ...',
    'German':'Nachricht senden ...',
    'French':"Envoyer le message...",
    'Japanese':'メッセージを送る...',
    'Russian':'Отправить сообщение...',
    'Chinese':'发信息...',
    'Portuguese':'Enviar mensagem...',
  };
  Map unableToLaunchUrl={
    'English':"Something went wrong!! Please try again later",
    'Hindi':'कुछ गलत हो गया!! बाद में पुन: प्रयास करें',
    'Spanish':'¡¡Algo salió mal. Por favor, inténtelo de nuevo más tarde',
    'German':'Etwas ist schief gelaufen!! Bitte versuchen Sie es später noch einmal',
    'French':"Quelque chose s'est mal passé !! Veuillez réessayer plus tard",
    'Japanese':'何かがうまくいかなかった!!後でもう一度やり直してください',
    'Russian':'Что-то пошло не так!! Пожалуйста, повторите попытку позже',
    'Chinese':'出问题了！！请稍后再试',
    'Portuguese':'Algo deu errado !! Por favor, tente novamente mais tarde'
  };

  void launchLink(String link)async
  {
    if (await canLaunch(link)) {
      await launch(
        link,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String,String>{'header_key':'header_value'},
      );
    } else {
      showToast(unableToLaunchUrl[lang]);
    }
  }


  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        if(!snapshot.hasData)
        {
          _isLoading=true;
          return Expanded(child: Center(child: CircularProgressIndicator(),),);
        }
        else
        {
          _isLoading=false;
          return Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                reverse: true,
                controller: listScrollController,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index){
                  return MessageTile(
                    message: snapshot.data.docs[index].data()["message"],
                    sendByMe: currentUser.id == snapshot.data.docs[index].data()["sendBy"],
                    senderUsername: snapshot.data.docs[index].data()["senderUsername"],
                    type:snapshot.data.docs[index].data()["type"],
                    recieverAvater: widget.recieverAvatar,
                    snapshot:snapshot,
                    index:index,
                    time: snapshot.data.docs[index].data()["time"]==null?Timestamp.fromDate(DateTime.now()):snapshot.data.docs[index].data()["time"],
                    chatRoomId: chatRoomId,
                    total:snapshot.data.docs.length,
                  );
                }),
          );
        }
      },
    );
  }
  chatRoomIdMaker()
  {
    if(currentUser.id.hashCode<=widget.recieverId.hashCode)
      chatRoomId="${currentUser.id}-${widget.recieverId}";
    else
      chatRoomId="${widget.recieverId}-${currentUser.id}";
  }

  @override
  void initState() {
    chatRoomIdMaker();
    listScrollController= ScrollController()..addListener(_scrollListener);
    getChats(chatRoomId);
    getChatRoomStream(chatRoomId).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
    isLoading=false;
    super.initState();
  }

  @override
  void dispose()
  {
    messageEditingController.dispose();
    listScrollController.removeListener(_scrollListener);
    listScrollController.dispose();
    super.dispose();
  }
  void _scrollListener() {
    if (!_isLoading) {
      if (listScrollController.position.pixels == listScrollController.position.maxScrollExtent) {
        limit=limit+10;
        getChats(chatRoomId);
      }
    }
  }

  getChats(String chatRoomId) async{
    setState(() {
      chats= chatRoomReference
          .doc(chatRoomId)
          .collection("chats")
          .orderBy('time',descending: true)
          .limit(limit)
          .snapshots();
    });
  }
  updateMessageCountSeen(int counter)
  {
    chatRoomReference.doc(chatRoomId).update({
      "${currentUser.id}messageCount":counter,
    });
  }
  updateMessageCount()
  {
    chatRoomReference.doc(chatRoomId).update({
      "messageCount":FieldValue.increment(1),
    });
  }

  addMessage(String content, int type)async{
    if (content.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": currentUser.id,
        "message": content,
        'time': FieldValue.serverTimestamp(),
        "type":type,
        "senderUsername":currentUser.username,
      };
      addMessages(chatRoomId, chatMessageMap);
      if(type==0)
        messageEditingController.clear();
      List<String> users = [currentUser.username,widget.recieverName];
      chatRoom = {
        "users": users,
        "chatRoomId" : chatRoomId,
        "Avatar1":widget.recieverAvatar,
        "Avatar2":currentUser.url,
        "ids":[widget.recieverId,currentUser.id],
        "timeStamp":FieldValue.serverTimestamp(),
        "type":type,
        "message":content,
        "sendBy":currentUser.id,
      };
      DocumentSnapshot documentSnapshot=await chatRoomReference.doc(chatRoomId).get();
      if(!documentSnapshot.exists)
      {
        chatRoomReference.doc(chatRoomId).set({
          "messageCount":1,
          "${currentUser.id}messageCount":1,
          "${widget.recieverId}messageCount":0,
          "users": users,
          "chatRoomId" : chatRoomId,
          "Avatar1":widget.recieverAvatar,
          "Avatar2":currentUser.url,
          "ids":[widget.recieverId,currentUser.id],
          "timeStamp":FieldValue.serverTimestamp(),
          "type":type,
          "message":content,
          "sendBy":currentUser.id,
        });
      }
      else
      {
        QuerySnapshot snapshot=await chatRoomReference.doc(chatRoomId).collection("chats").get();
        int count=snapshot.docs.length;
        if(count==1)
        {
          chatRoomReference.doc(chatRoomId).update({
            "messageCount":1,
            "${currentUser.id}messageCount":1,
            "${widget.recieverId}messageCount":0,
          });
        }
        updateMessageCount();
        addChatRoom(chatRoom, chatRoomId);
        listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }
  uploadImageFile() async
  {
    String folderName;
    if(currentUser.id.hashCode<=widget.recieverId.hashCode)
      folderName="${currentUser.id}-${widget.recieverId}";
    else
      folderName="${widget.recieverId}-${currentUser.id}";
    String fileName=DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = messageStorageReference.child(folderName).child(fileName);
    await ref.putFile(_image);
    await ref.getDownloadURL().then((downloadUrl){
      imageUrl=downloadUrl;
      setState(() {
        isLoading=false;
        addMessage(imageUrl+"After this we have--->fileName!!#simplyfy@kuchBhi)(}{><"+fileName,1,);
      });
    },onError: (error)
    {
      setState(() {
        isLoading=false;
      });
      Fluttertoast.showToast(msg: "Error: "+error);
    }
    );
  }
  Future getImage() async
  {
    final imageFile= await picker.getImage(source: ImageSource.gallery,maxHeight: 680,maxWidth: 970);
    setState(() {
      _image=File(imageFile.path);
    });
    if(_image!=null)
      isLoading=true;
    uploadImageFile();
  }
  Future getImageFromCamera() async
  {
    final imageFile= await picker.getImage(source: ImageSource.camera,maxHeight: 680,maxWidth: 970);
    setState(() {
      _image=File(imageFile.path);
    });
    if(_image!=null)
      isLoading=true;
    uploadImageFile();
  }

  openMenu()
  {
    menu = PopupMenu(
      maxColumn: 1,
      onClickMenu: onClickMenu,
      backgroundColor: Colors.white,
      lineColor: Colors.grey[300],
      items: [
        MenuItem(
          title: camera[lang],
          textStyle: TextStyle(fontSize: 12.0,),
          image: Icon(Icons.add_a_photo,),
        ),
        MenuItem(
          title: image[lang],
          textStyle: TextStyle(fontSize: 12.0,),
          image: Icon(Icons.image,),
        ),
      ],
    );
    menu.show(widgetKey: btnKey);
  }

  void onClickMenu(MenuItemProvider item) {
    if(item.menuImage==Icon(Icons.add_a_photo, color: Colors.white,))
      getImageFromCamera();
    else
      getImage();
  }

  getTextFields()
  {
    PopupMenu.context=context;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(3, 3, 3,3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 7,
                      controller: messageEditingController,
                      decoration: InputDecoration(
                          hintText: "  "+sendMessage[lang],
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 5,),
          GestureDetector(
            key: btnKey,
            onTap: openMenu,
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40)
              ),
              padding: EdgeInsets.fromLTRB(6,2,2,2),
              child: Icon(Icons.add,size: 25,),
            ),
          ),
          SizedBox(width: 5,),
          GestureDetector(
            onTap: () {
              addMessage(messageEditingController.text,0);
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40)
              ),
              padding: EdgeInsets.fromLTRB(6,2,2,2),
              child: Icon(Icons.send,size: 25,),
            ),
          )
        ],
      ),
    );
  }

  navigateToProfile()async{
    DocumentSnapshot documentSnapshot=await usersReference.doc(widget.recieverId).get();
    UserModel userModel=UserModel.fromDocument(documentSnapshot);
    if(userModel.isExpert)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpertProfile(userModel: userModel,isFromBottomNavigation: false,)));
      }
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return GestureDetector(
      onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
      child: Scaffold(
        backgroundColor: const Color(0xfff0f0f0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: MediaQuery.of(context).size.height*0.1,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
            onTap: ()=>Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.videocam_outlined, color: Colors.black,),
              iconSize: 35,
              onPressed: (){
                launchLink('https://meet.google.com/');
              },
            ),
            SizedBox(width:10),
          ],
          title: GestureDetector(
            onTap: (){navigateToProfile();},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.recieverAvatar==""?CircleAvatar(radius: 22,child: Icon(Icons.person,size: 35.0,color: Colors.white,),backgroundColor: Colors.black54,):CircleAvatar(radius: 25,backgroundImage: CachedNetworkImageProvider(widget.recieverAvatar),),
                SizedBox(width: 10,),
                Flexible(child: Text(widget.recieverName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20.0),overflow: TextOverflow.ellipsis,)),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: const Color(0xffe3ebee),
            borderRadius: BorderRadius.only(topRight: Radius.circular(35.0),topLeft: Radius.circular(35.0)),
            image: DecorationImage(
              image: AssetImage('assets/chattingPage.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  chatMessages(),
                  StreamBuilder(
                    stream: chatRoomStream,
                    builder: (context,dataSnapshot){
                      if(!dataSnapshot.hasData)
                        return Container();
                      if(dataSnapshot.data.docs.isNotEmpty)
                      {
                        updateMessageCountSeen(dataSnapshot.data.docs[0].data()['messageCount']);
                        int recieverCount=0;
                        int totalMessages=0;
                        bool lastSendByMe=currentUser.id==dataSnapshot.data.docs[0].data()['sendBy'];
                        totalMessages=dataSnapshot.data.docs[0].data()['messageCount'];
                        recieverCount=dataSnapshot.data.docs[0].data()['${widget.recieverId}messageCount'];
                        return lastSendByMe?recieverCount>=totalMessages? Container(
                          padding: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerRight,
                          child: Text("Seen",style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                        ):Container():Container();
                      }
                      return Container();
                    },
                  ),
                  getTextFields(),
                ],
              ),
              isLoading?Center(child: CircularProgressIndicator(),):Container(),
            ],
          ),
        ),
      ),
    );
  }

}
class MessageTile extends StatefulWidget {
  final String message;
  final String chatRoomId;
  final bool sendByMe;
  final String senderUsername;
  final int type;
  final String recieverAvater;
  var snapshot;
  final int index;
  final Timestamp time;
  final int total;

  MessageTile({@required this.message, @required this.sendByMe,@required this.senderUsername,@required this.type,@required this.recieverAvater,@required this.snapshot,@required this.index,@required this.time,@required this.chatRoomId,this.total});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String lang='English';
  Map toastMessage={
    'English':"Saved successfully",
    'Hindi':'सफलतापूर्वक डाउनलोड किया गया',
    'Spanish':'Guardado exitosamente',
    'German':'Erfolgreich gespeichert',
    'French':"Enregistré avec succès",
    'Japanese':'正常に保存',
    'Russian':'Успешно сохранено',
    'Chinese':'保存成功',
    'Portuguese':'Salvo com sucesso',
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
  Map saveImageText={
    'English':"Save Image",
    'Hindi':'चित्र को सेव करें',
    'Spanish':'Guardar imagen',
    'German':'Bild speichern',
    'French':"Enregistrer l'image",
    'Japanese':'画像を保存',
    'Russian':'Сохранить изображение',
    'Chinese':'保存图片',
    'Portuguese':'Salvar imagem',
  };
  Map actions={
    'English':"Actions..",
    'Hindi':'क्रियाएँ ..',
    'Spanish':'Comportamiento..',
    'German':'Aktionen..',
    'French':"Actions..",
    'Japanese':'行動..',
    'Russian':'Действия ..',
    'Chinese':'行动..',
    'Portuguese':'Ações..',
  };
  Map copyText={
    'English':"Copy Text",
    'Hindi':'कॉपी करें',
    'Spanish':'Copiar texto',
    'German':'Text kopieren',
    'French':"Copier le texte",
    'Japanese':'テキストをコピーする',
    'Russian':'Копировать текст',
    'Chinese':'复制文本',
    'Portuguese':'Copiar Texto',
  };
  Map deleteMessageText={
    'English':"Delete message",
    'Hindi':'संदेश को हटाएं',
    'Spanish':'Borrar mensaje',
    'German':'Nachricht löschen',
    'French':"Supprimer le message",
    'Japanese':'メッセージを削除する',
    'Russian':'Удаленное сообщение',
    'Chinese':'删除消息',
    'Portuguese':'Apagar mensagem',
  };
  Map deleteToast={
    'English':"Deleted successfully",
    'Hindi':'सफलतापूर्वक हटाया गया',
    'Spanish':'Borrado exitosamente',
    'German':'Erfolgreich gelöscht',
    'French':"Supprimé avec succès",
    'Japanese':'正常に削除されました',
    'Russian':'Успешно удалено',
    'Chinese':'删除成功',
    'Portuguese':'Apagado com sucesso',
  };
  Map copyToast={
    'English':"Copied text..",
    'Hindi':'कॉपी किया गया टेक्स्ट..',
    'Spanish':'Texto copiado ...',
    'German':'Kopierter Text..',
    'French':"Texte copié..",
    'Japanese':'コピーされたテキスト。',
    'Russian':'Скопированный текст ..',
    'Chinese':'复制的文字。。',
    'Portuguese':'Texto copiado ..',
  };
  updateMessageCountSeen()
  {
    chatRoomReference.doc(widget.chatRoomId).update({
      "${currentUser.id}messageCount":FieldValue.increment(-1),
    });
  }
  updateMessageCount()
  {
    chatRoomReference.doc(widget.chatRoomId).update({
      "messageCount":FieldValue.increment(-1),
    });
  }


  deleteMedia(String url) async
  {
    print(widget.chatRoomId);
    String fileName=widget.message.substring(widget.message.indexOf("After this we have--->fileName!!#simplyfy@kuchBhi)(}{><")+"After this we have--->fileName!!#simplyfy@kuchBhi)(}{><".length);
    print(fileName);
    messageStorageReference.child(widget.chatRoomId).child(fileName).delete();
  }


  void deleteMessage(String type)
  {
    if(type=="message"&&widget.sendByMe)
    {
      deleteChats(widget.index, widget.snapshot);
    }
    else if(type=="sticker"&&widget.sendByMe)
    {
      deleteChats(widget.index, widget.snapshot);
    }
    else if(type=="picture"&&widget.sendByMe)
    {
      deleteChats(widget.index, widget.snapshot);
      deleteMedia(widget.message);
    }
    else if(type=="post"&&widget.sendByMe)
    {
      deleteChats(widget.index, widget.snapshot);
    }
    updateMessageCountSeen();
    updateMessageCount();
  }
  Future<bool> saveImage(String url, String fileName,) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/AddictX";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await Dio().download(url,saveFile.path,onReceiveProgress: (rec,total){

        });
        showToast(toastMessage[lang]);
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadFile(String message) async {
    /*setState(() {
      loading = true;
      progress = 0;
    });*/
    bool downloaded = await saveImage(message, DateTime.now().millisecondsSinceEpoch.toString()+'.jpg',);
    if (downloaded) {
      print("File Downloaded");
    } else {
      print("Problem Downloading File");
    }
    /*setState(() {
      loading = false;
    });*/
  }

  messageActions(mContext,String type)
  {
    FocusScope.of(context).requestFocus(new FocusNode());
    return showDialog(
        context: mContext,
        builder: (context){
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.time.seconds*1000)),style: TextStyle(fontSize: 13.5),),
                Text(actions[lang],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.cyan),),
              ],
            ),
            children: <Widget>[
              type=="message"?SimpleDialogOption(
                child: Text(copyText[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){Clipboard.setData(ClipboardData(text: widget.message)); Navigator.pop(context); showToast(copyToast[lang]);},
              ):Container(),
              type=="picture"?SimpleDialogOption(
                child: Text(saveImageText[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){downloadFile(widget.message.substring(0,widget.message.indexOf("After this we have--->fileName!!#simplyfy@kuchBhi)(}{><"))); Navigator.pop(context);},
              ):Container(),
              widget.sendByMe?SimpleDialogOption(
                child: Text(deleteMessageText[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){deleteMessage(type); Navigator.pop(context); showToast(deleteToast[lang]);},
              ):Container(),
              SimpleDialogOption(
                child: Text(cancel[lang],style: TextStyle(fontSize: 17),),
                onPressed: ()=>Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }

  Widget create(context)
  {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 4,bottom: 4,left: widget.sendByMe ? 0 : 7,right: widget.sendByMe ? 7 : 0),
          alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: widget.type==0
              ?GestureDetector(
            onLongPress: ()=>messageActions(context, "message"),
            child: Container(
              constraints: BoxConstraints(maxWidth:200),
              padding: EdgeInsets.only(top: 12, bottom: 12, left: 13, right: 13),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: widget.sendByMe?const Color(0xff9ad0e5):Colors.white,
              ),
              child: Text(widget.message,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500),),
            ),
          )
              :widget.type==1
              ?GestureDetector(
                child: Material(
                  child: CachedNetworkImage(
                    placeholder: (context,url)=>Container(
                      child: CircularProgressIndicator(),
                      width: 200.0,
                      height: 200.0,
                      padding: EdgeInsets.all(70.0),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                    ),
                    errorWidget: (context,url,error)=>Material(
                      child: Image.asset("images/img_not_available.jpeg",width: 200.0,height: 200.0,fit: BoxFit.cover,),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    imageUrl: widget.message.substring(0,widget.message.indexOf("After this we have--->fileName!!#simplyfy@kuchBhi)(}{><")),
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: widget.sendByMe ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ) :
                  BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  clipBehavior: Clip.hardEdge,
                ),
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>FullPhoto(url:widget.message.substring(0,widget.message.indexOf("After this we have--->fileName!!#simplyfy@kuchBhi)(}{><")),)));},
                onLongPress: ()=>messageActions(context, "picture"),
              )
              :Container(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Container(
      child: create(context),
    );
  }
}