import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/helpers/timeAgo.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatelessWidget {
  final String username;
  final String comment;
  final Timestamp timestamp;
  final String userUrl;
  final String commentUserId;
  final String documentId;
  final String ownerId;
  final String postId;
  CommentWidget({this.username,this.comment,this.timestamp,this.userUrl,this.commentUserId,this.documentId,this.ownerId,this.postId});

  String lang='English';
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
  Map del={
    'English':"Delete comment",
    'Hindi':'कमेंट हटाएं',
    'Spanish':'Eliminar comentario',
    'German':'Kommentar löschen',
    'French':"Supprimer le commentaire",
    'Japanese':'コメントを削除',
    'Russian':'Удалить комментарий',
    'Chinese':'删除评论',
    'Portuguese':'Excluir comentário',
  };
  Map copy={
    'English':"Copy comment",
    'Hindi':'कॉपी कमेंट',
    'Spanish':'Copiar comentario',
    'German':'Kommentar kopieren',
    'French':"Copier le commentaire",
    'Japanese':'コメントをコピー',
    'Russian':'Копировать комментарий',
    'Chinese':'复制评论',
    'Portuguese':'Copiar comentário',
  };
  Map copyToast={
    'English':"Copied comment..",
    'Hindi':'कॉपी हो गया कमेंट',
    'Spanish':'Comentario copiado ...',
    'German':'Kommentar kopiert..',
    'French':"Commentaire copié..",
    'Japanese':'コメントをコピーしました。',
    'Russian':'Скопированный комментарий ..',
    'Chinese':'复制评论..',
    'Portuguese':'Comentário copiado ..',
  };
  Map delToast={
    'English':"Deleted successfully",
    'Hindi':'सफलतापूर्वक मिटाया गया',
    'Spanish':'Borrado exitosamente',
    'German':'Erfolgreich gelöscht',
    'French':"Supprimé avec succès",
    'Japanese':'正常に削除されました',
    'Russian':'Успешно удалено',
    'Chinese':'删除成功',
    'Portuguese':'Apagado com sucesso',
  };

  factory CommentWidget.fromDocument(DocumentSnapshot documentSnapshot)
  {
    return CommentWidget(
      username: documentSnapshot.data()["username"],
      comment: documentSnapshot.data()['comment'],
      timestamp: documentSnapshot.data()['timeStamp'],
      userUrl: documentSnapshot.data()['url'],
      commentUserId: documentSnapshot.data()['commentUserId'],
      documentId: documentSnapshot.data()['documentId'],
      ownerId: documentSnapshot.data()['ownerId'],
      postId: documentSnapshot.data()['postId'],
    );
  }

  deleteComment()async
  {
    commentsReference.doc(postId).collection("comments").doc(documentId).delete();
    if(ownerId!=commentUserId)
      {
        notificationsReference.doc(ownerId).collection('notificationItems')
            .where('type',isEqualTo: "commented on your post")
            .where('postId',isEqualTo: postId)
            .where('timeStamp',isEqualTo: timestamp)
            .get().then((snapshot) => snapshot.docs.first.reference.delete());
      }
  }

  commentActions(mContext)
  {
    return showDialog(
        context: mContext,
        builder: (context){
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
            title: Text(actions[lang],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue[100]),),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(copy[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){Clipboard.setData(ClipboardData(text: comment)); Navigator.pop(context); showToast(copyToast[lang]);},
              ),
              SimpleDialogOption(
                child: Text(del[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){deleteComment(); Navigator.pop(context); showToast(delToast[lang]);},
              ),
              SimpleDialogOption(
                child: Text(cancel[lang],style: TextStyle(fontSize: 17),),
                onPressed: ()=>Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return ListTile(
      leading: userUrl==""?CircleAvatar(child: Icon(Icons.person,size: 35,color: Colors.white,),backgroundColor: Colors.black87.withOpacity(0.6),radius: 24,):CircleAvatar(radius: 24,backgroundImage: CachedNetworkImageProvider(userUrl),),
      title: Text.rich(
          TextSpan(
              text: "",
              children: [
                TextSpan(
                  text: "$username: ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                  //recognizer: TapGestureRecognizer()..onTap=()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(userProfileId: userId,))),
                ),
                TextSpan(
                    text:'',
                    children: [
                      TextSpan(
                        text: comment
                      ),
                    ],
                ),
              ],
          ),
      ),
      subtitle: Row(mainAxisSize: MainAxisSize.min,children: <Widget>[Text(TimeAgo.timeAgoSinceDate(timestamp.toDate(),lang)),],),
      trailing: currentUser!=null&&(commentUserId==currentUser.id)?GestureDetector(
        onTap: ()=>commentActions(context),
        child: Icon(Icons.more_vert),
      )
          :null,
    );
  }
}
