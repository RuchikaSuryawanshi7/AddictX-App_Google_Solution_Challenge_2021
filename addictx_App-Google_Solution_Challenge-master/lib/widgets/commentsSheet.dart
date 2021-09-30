import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/widgets/commentWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String ownerId;
  Comments({this.postId,this.ownerId});
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController commentsTextEditingController;
  Map noAdvice={
    'English':"No experts advice as of yet",
    'Hindi':'अभी तक कोई विशेषज्ञ सलाह नहीं है',
    'Spanish':'Aún no hay consejos de expertos',
    'German':'Noch keine Expertenberatung',
    'French':"Aucun avis d'experts pour l'instant",
    'Japanese':'現時点では専門家のアドバイスはありません',
    'Russian':'Советов экспертов пока нет',
    'Chinese':'目前还没有专家建议',
    'Portuguese':'Nenhum conselho de especialistas ainda',
  };
  Map hint={
    'English':"Comment...",
    'Hindi':'टिप्पणी...',
    'Spanish':'Comentario...',
    'German':'Kommentar...',
    'French':"Commenter...",
    'Japanese':'コメント...',
    'Russian':'Комментарий...',
    'Chinese':'评论...',
    'Portuguese':'Comente...',
  };

  @override
  void initState() {
    commentsTextEditingController=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    commentsTextEditingController?.dispose();
    super.dispose();
  }

  saveComment()async
  {
    final timeStamp=DateTime.now();
    DocumentReference documentReference=commentsReference.doc(widget.postId).collection("comments").doc();
    documentReference.set({
      "username":currentUser.username,
      "comment":commentsTextEditingController.text,
      "timeStamp":timeStamp,
      "url":currentUser.url,
      "commentUserId":currentUser.id,
      "postOwnerId":widget.ownerId,
      "postId":widget.postId,
      "documentId":documentReference.id,
    });
    if(currentUser.id!=widget.ownerId)
      {
        DocumentReference doc=notificationsReference.doc(widget.ownerId).collection("notificationItems").doc();
        doc.set({
          "postType":'text',
          "username": currentUser.username,
          "userId": currentUser.id,
          "postOwnerId":widget.ownerId,
          "timeStamp": DateTime.now(),
          "postId": widget.postId,
          "userProfileImg": currentUser.url,
          "postUrl":'',
          "commentData":commentsTextEditingController.text,
          'id':doc.id,
          "type": "commented on your problem",
        });
      }
    commentsTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width*1/3,
          height: 5,
          decoration: BoxDecoration(
            color: Color(0xff9ad0e5),
            borderRadius: BorderRadius.all(Radius.circular(25))
          ),
        ),
        StreamBuilder(
          stream: commentsReference.doc(widget.postId).collection('comments').orderBy("timeStamp",descending: true).snapshots(),
          builder: (context,snapshot)
          {
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator(),);
            return snapshot.data.docs.isEmpty?Expanded(
              child: Center(
                child: Text(
                  noAdvice[lang],
                  style: GoogleFonts.gugi(
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ):Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index)
                {
                  return CommentWidget.fromDocument(snapshot.data.docs[index]);
                },
              ),
            );
          },
        ),
        currentUser!=null&&(currentUser.isExpert||currentUser.id==widget.ownerId)?Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: TextFormField(
            autofocus: true,
            controller: commentsTextEditingController,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff9ad0e5),width: 1.0),
              ),
              hintText: hint[lang],
              hintStyle: TextStyle(color: Colors.grey[700]),
              suffixIcon: IconButton(icon: Icon(Icons.send,size: 30,color: Color(0xff9ad0e5),),onPressed: (){saveComment();},),
            ),
          ),
        ):Container(),
      ],
    );
  }
}


bottomSheetForComments(BuildContext context,String postId,String ownerId)
{
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context){
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height*1/3,minHeight: 0
            ),
            child: Comments(postId: postId,ownerId: ownerId,),
          ),
        );
      }
  );
}