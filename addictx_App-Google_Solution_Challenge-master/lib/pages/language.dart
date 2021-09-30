import 'package:addictx/languageNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language extends StatelessWidget {
  List<String> languages=[
    'Hindi',
    'English',
    'Spanish',
    'German',
    'French',
    'Japanese',
    'Russian',
    'Chinese',
    'Portuguese',
  ];
  List<String> languageSpecific=[
    'हिंदी',
    'English',
    'Española',
    'Deutsche',
    'Français',
    '日本語',
    'русский',
    '中国人',
    'português',
  ];

  Map<String,List> languageContent={
    'English':['Hindi', 'English', 'Spanish', 'German', 'French', 'Japanese', 'Russian', 'Chinese', 'Portuguese',],
    'Hindi':['हिंदी', 'अंग्रेज़ी', 'स्पेनिश', 'जर्मन', 'फ्रेंच', 'जापानी', 'रूसी', 'चीनी', 'पुर्तगाली'],
    'Spanish':['Hindi', 'Inglesa', 'Española', 'Alemana', 'Francesa', 'Japonesa', 'Rusa', 'China', 'Portuguesa'],
    'German':['Hindi', 'Englisch', 'Spanisch', 'Deutsche', 'Französisch', 'Japanisch', 'Russisch', 'Chinesisch', 'Portugiesisch'],
    'French':['Hindi', 'Anglaise', 'Espanol', 'Allemande', 'Français', 'Japonaise', 'Russe', 'Chinoise', 'Portugais'],
    'Japanese':['ヒンディー語', '英語', 'スペイン語', 'ドイツ人', 'フランス語', '日本語', 'ロシア', '中国語', 'ポルトガル語'],
    'Russian':['хинди', 'английский', 'испанский', 'Немецкий', 'Французский', 'Японский', 'русский', 'китайский язык', 'португальский'],
    'Chinese':['印地语', '英语', '西班牙语', '德语', '法语', '日本人', '俄语', '中国人', '葡萄牙语'],
    'Portuguese':['Hindi', 'Inglês', 'Espanhola', 'Alemã', 'Francesa', 'Japonês', 'Russa', 'Chinês', 'Português'],
  };
  Map title={
    'English':'Languages',
    'Hindi':'भाषा',
    'Spanish':'Idiomas',
    'German':'Sprachen',
    'French':'Langues',
    'Japanese':'言語',
    'Russian':'Языки',
    'Chinese':'语言',
    'Portuguese':'Línguas'
  };
  Map otherLanguages={
    'English':'Other Languages',
    'Hindi':'अन्य भाषाएँ',
    'Spanish':'Otros idiomas',
    'German':'Andere Sprachen',
    'French':'Autres langues',
    'Japanese':'他の言語',
    'Russian':'Другие языки',
    'Chinese':'其他语言',
    'Portuguese':'Outras línguas',
  };

  void changeLanguage(String language, LanguageNotifier languageNotifier) async {
    languageNotifier.setLanguage(language);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                lang,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
              tileColor: const Color(0xff9ad0e5),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: Text(
                otherLanguages[lang],
                style: TextStyle(
                  fontSize: 20,
                  color: const Color(0xff898989),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Divider(height: 0,thickness: 2,color: const Color(0x24707070),),
            ListView.separated(
              itemCount: languages.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context,index)=>Divider(height: 0,thickness: 2,color: const Color(0x24707070),),
              itemBuilder: (context,index){
                return Container(
                  height: 70,
                  alignment: Alignment.center,
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      onTap: ()=>changeLanguage(languages[index], languageNotifier),
                      title: Text(languageContent[lang][index],style: TextStyle(fontSize: 18),),
                      subtitle: Text(languageSpecific[index]),
                      trailing: lang==languages[index]?Icon(Icons.check,color: const Color(0xff9ad0e5),):Container(height: 0,width: 0,),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
