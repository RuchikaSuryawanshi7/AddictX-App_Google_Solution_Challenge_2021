import 'package:addictx/languageNotifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoYouKnow extends StatelessWidget {
  final String url;
  final String heading;
  final String content;
  DoYouKnow({this.url,this.heading,this.content});
  Map title={
    'English':"Do you Know ?",
    'Hindi':'क्या आपको पता है ?',
    'Spanish':'Lo sabías ?',
    'German':'Wissen Sie ?',
    'French':'Savez-vous ?',
    'Japanese':'あなたは知っていますか',
    'Russian':'Ты знаешь ?',
    'Chinese':'你知道吗',
    'Portuguese':'Você sabe ?',
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Center(
            child: Text(
              title[lang]+' ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
        title: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: const Color(0xfff0f0f0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height*0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text(
                    heading,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    content,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      color: const Color(0xab000000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
