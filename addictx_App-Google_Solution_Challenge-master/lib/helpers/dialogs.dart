import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showToast(String content) {
  Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white
  );
}

showReportDialogBox(BuildContext context,{String type,String reportedId,String reporterId,String choice1,String choice2,String choice3})
{
  Map<String, String> reportAs={
    'English':'Report as..',
    'Hindi':'रिपोर्ट करें ..',
    'Spanish':'Informar como ...',
    'German':'Melden als..',
    'French':'Signaler comme..',
    'Japanese':'として報告します。',
    'Russian':'Сообщить как ..',
    'Chinese':'报告为..',
    'Portuguese':'Reportar como ..',
  };
  Map<String, String> toastContent={
    'English':"Reported Successfully",
    'Hindi':'सफलतापूर्वक रिपोर्ट किया गया',
    'Spanish':'Reportado exitosamente',
    'German':'Erfolgreich gemeldet',
    'French':'Signalé avec succès',
    'Japanese':'正常に報告されました',
    'Russian':'Отчет успешно отправлен',
    'Chinese':'成功举报',
    'Portuguese':'Reportado com sucesso',
  };
  return showDialog(
      context: context,
      builder: (context){
        final languageNotifier = Provider.of<LanguageNotifier>(context);
        String lang = languageNotifier.getLanguage();
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
          title: Text(reportAs[lang],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.cyan),),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(choice1,style: TextStyle(fontSize: 17),),
              onPressed: (){report(type, choice1, reportedId,reporterId,toastContent[lang],);Navigator.pop(context);},
            ),
            SimpleDialogOption(
              child: Text(choice2,style: TextStyle(fontSize: 17),),
              onPressed: (){report(type, choice2, reportedId,reporterId,toastContent[lang],);Navigator.pop(context);},
            ),
            SimpleDialogOption(
              child: Text(choice3,style: TextStyle(fontSize: 17),),
              onPressed: (){report(type, choice3, reportedId,reporterId,toastContent[lang],);Navigator.pop(context);},
            ),
          ],
        );
      }
  );
}

void dialog(BuildContext context,String heading,String body){
  Map<String, String> ok={
    'English':'OK',
    'Hindi':'ठीक है',
    'Spanish':'OK',
    'German':'OK',
    'French':"D'accord",
    'Japanese':'OK',
    'Russian':'ОК',
    'Chinese':'好的',
    'Portuguese':'OK',
  };
  final languageNotifier = Provider.of<LanguageNotifier>(context);
  String lang = languageNotifier.getLanguage();
  var alertDialog=AlertDialog(
    title: Text(heading),
    content: Text(body),
    actions: <Widget>[RaisedButton(
      color: Colors.blue[100],
      child: Text(ok[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      onPressed: (){
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
    )],
  );
  showDialog(
      context: context,
      builder: (BuildContext context){
        return alertDialog;
      });
}

report(String type,String category,String reportedId,String reporterId,String toastContent)async
{
  DocumentSnapshot documentSnapshot= await reportReference.doc(type).collection(category).doc(reportedId).get();
  documentSnapshot.exists?reportReference.doc(type).collection(category).doc(reportedId).update({"count":FieldValue.increment(1),"Reported by":FieldValue.arrayUnion([reporterId])}):reportReference.doc(type).collection(category).doc(reportedId).set({"count":1,"Reported by":FieldValue.arrayUnion([reporterId])});
  showToast(toastContent);
}