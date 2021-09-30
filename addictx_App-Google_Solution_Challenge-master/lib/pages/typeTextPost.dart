import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/home.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TypeTextPost extends StatefulWidget {
  final bool isPost;
  const TypeTextPost({Key key,this.isPost}) : super(key: key);

  @override
  _TypeTextPostState createState() => _TypeTextPostState();
}

class _TypeTextPostState extends State<TypeTextPost> {
  TextEditingController textEditingController;
  String lang='English';
  Map toastMessage={
    'English':'Added successfully',
    'Hindi':'सफलतापूर्वक हो गया',
    'Spanish':'Agregado exitosamente',
    'German':'Erfolgreich hinzugefügt',
    'French':"Ajouté avec succès",
    'Japanese':'正常に追加されました',
    'Russian':'Добавлено успешно',
    'Chinese':'添加成功',
    'Portuguese':'Adicionado com sucesso',
  };
  Map emptyText={
    'English':"Can't upload empty text...",
    'Hindi':'खाली टेक्स्ट अपलोड नहीं किया जा सकता...',
    'Spanish':'No se puede cargar texto vacío ...',
    'German':'Leerer Text kann nicht hochgeladen werden...',
    'French':"Impossible de télécharger du texte vide...",
    'Japanese':'空のテキストをアップロードできません...',
    'Russian':'Не могу загрузить пустой текст ...',
    'Chinese':'无法上传空文本...',
    'Portuguese':'Não é possível fazer upload de texto vazio ...',
  };
  Map processing={
    'English':"Processing",
    'Hindi':'प्रसंस्करण',
    'Spanish':'Procesando',
    'German':'wird bearbeitet',
    'French':"Traitement",
    'Japanese':'処理',
    'Russian':'Обработка',
    'Chinese':'加工',
    'Portuguese':'Em processamento',
  };
  Map post={
    'English':"Type a post",
    'Hindi':'पोस्ट टाइप करें',
    'Spanish':'Escribe una publicación',
    'German':'Geben Sie einen Beitrag ein',
    'French':"Tapez un message",
    'Japanese':'投稿を入力します',
    'Russian':'Напишите сообщение',
    'Chinese':'输入帖子',
    'Portuguese':'Digite uma postagem',
  };
  Map ques={
    'English':"Type a question",
    'Hindi':'एक प्रश्न टाइप करें',
    'Spanish':'Escribe una pregunta',
    'German':'Geben Sie eine Frage ein',
    'French':"Tapez une question",
    'Japanese':'質問を入力してください',
    'Russian':'Введите вопрос',
    'Chinese':'输入问题',
    'Portuguese':'Digite uma pergunta',
  };

  @override
  void initState() {
    textEditingController=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    super.dispose();
  }

  saveToFireStore(String content, {bool post})async
  {
    if(post)
    {
      DocumentReference documentReference=postsReference.doc();
      documentReference.set({
        'id':documentReference.id,
        'type':'text',
        'timeStamp':FieldValue.serverTimestamp(),
        'content':content,
        'ownerId':currentUser.id,
        'likes':FieldValue.arrayUnion([]),
        "views":FieldValue.arrayUnion([]),
        "thumbnail":'',
      }).catchError((e)=>print(e));
    }
    else
    {
      DocumentReference documentReference=problemsReference.doc();
      documentReference.set({
        'id':documentReference.id,
        'timeStamp':FieldValue.serverTimestamp(),
        'question':content,
        'ownerId':currentUser.id,
        'likes':FieldValue.arrayUnion([]),
      }).catchError((e)=>print(e));
    }
    showToast(toastMessage[lang]);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: const Color(0xff9ad0e5),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: (){
          if(textEditingController.text!=null&&textEditingController.text!="")
            saveToFireStore(textEditingController.text,post: widget.isPost);
          else
            showToast(emptyText[lang]);
        },
        child: Icon(FontAwesomeIcons.solidPaperPlane,color: Colors.black,size: 25.0,),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: widget.isPost?MediaQuery.of(context).size.height*0.6:MediaQuery.of(context).size.height*0.41,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: const Color(0xffeff8fb),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    currentUser.url!=''?CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(currentUser.url),
                    ):CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: Icon(Icons.person,color: Colors.white,),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentUser.username,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Spacer(),
                    widget.isPost?Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite,size: 26,color: Color(0xffff5588),),
                            Text("44",style: TextStyle(fontSize: 25.0),),
                          ],
                        ),
                        Container(alignment: Alignment.centerRight,child: Text(processing[lang],style: TextStyle(fontSize: 12.0),)),
                      ],
                    ):Icon(Icons.more_vert),
                  ],
                ),
                SizedBox(height: 5,),
                Container(
                  height: widget.isPost?MediaQuery.of(context).size.height*0.47:MediaQuery.of(context).size.height*0.26,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: widget.isPost?const Color(0xffe3e3e3):Colors.transparent,
                  ),
                  child: Center(
                    child: TextFormField(
                      controller: textEditingController,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      style: TextStyle(color: widget.isPost?Colors.white:Colors.grey[500],fontSize: widget.isPost?30.0:20.0),
                      decoration: InputDecoration(
                        hintText: widget.isPost?post[lang]:ques[lang],
                        hintStyle: TextStyle(
                          color: const Color(0x33000000),
                          fontSize: widget.isPost?30.0:20.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                widget.isPost?Container():Row(
                  children: [
                    Spacer(),
                    Icon(Icons.mode_comment,color: Color(0xffa0e6ff),size: 30,),
                    Text(
                      287.toString()+" ",
                      style: GoogleFonts.gugi(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                        )
                      )
                    ),
                    Icon(Icons.favorite,size: 30,color: const Color(0xffff5588),),
                    Text(
                      485.toString(),
                      style: GoogleFonts.gugi(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
