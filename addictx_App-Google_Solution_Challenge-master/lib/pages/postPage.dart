import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/widgets/postWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PostPage extends StatelessWidget {
  final String docId;
  final bool isAddictXWatch;
  PostPage({this.docId,this.isAddictXWatch});
  Map title={
    'English':"Post",
    'Hindi':'पोस्ट',
    'Spanish':'Correo',
    'German':'Post',
    'French':'Poster',
    'Japanese':'役職',
    'Russian':'Почта',
    'Chinese':'邮政',
    'Portuguese':'Publicar'
  };
  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff9ad0e5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.black,),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
        title: Text(
          title[lang],
          style: GoogleFonts.gugi(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: isAddictXWatch?addictXWatchReference.doc(docId).get():postsReference.doc(docId).get(),
        builder: (context,snapshot)
        {
          if(!snapshot.hasData)
            return Center(child: CircularProgressIndicator(),);
          Post post=Post.fromDocument(snapshot.data);
          return post;
        },
      ),
    );
  }
}
