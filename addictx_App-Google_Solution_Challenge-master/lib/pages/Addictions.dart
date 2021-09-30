import 'package:addictx/languageNotifier.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:addictx/pages/addictionDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Addictions extends StatefulWidget {
  @override
  _AddictionsState createState() => _AddictionsState();
}

class _AddictionsState extends State<Addictions> {
  TextEditingController textEditingController=TextEditingController();
  bool _isSearching=false;
  String lang='English';
  List<String> assets=[
    'socialMedia','fastFood', 'overeating',
    'gaming','procrastination', 'gambling',
    'smoking','alcohol','drugs',
    'weed','watchingTv','lying',
    'coffee','quarrel','notSleeping'
  ];
  Map<String, List> titles={
    'English':['SOCIAL MEDIA','FAST FOOD','OVEREATING', 'GAMING','PROCRASTINATION','GAMBLING', 'SMOKING','ALCOHOL','DRUGS', 'WEED','WATCHING TV','LYING', 'COFFEE','QUARREL','NOT SLEEPING'],
    'Hindi':['सामाजिक मीडिया','फास्ट फूड','ज्यादा खाना', 'गेमिंग','टालमटोल करना','जुआ', 'धूम्रपान','शराब','ड्रग्स', 'जंगली घास','टीवी देखना','झूठ बोलना', 'कॉफ़ी','लड़ाई झगड़ा','नहीं सोना'],
    'Spanish':['MEDIOS DE COMUNICACIÓN SOCIAL','COMIDA RÁPIDA','COMER EN EXCESO','JUEGO DE AZAR','DILACIÓN','JUEGO', 'DE FUMAR','ALCOHOL','DROGAS', 'HIERBA','VIENDO LA TELEVISIÓN','MINTIENDO', 'CAFÉ','PELEA','NO DURMIENDO'],
    'German':['SOZIALEN MEDIEN','FASTFOOD','ÜBERESSEN', 'SPIELE','AUFSCHUB','SPIELEN', 'RAUCHEN','ALKOHOL','DROGEN', 'GRAS','FERNSEHEN','LÜGEN', 'KAFFEE','STREIT','NICHT SCHLAFEND'],
    'French':['DES MÉDIAS SOCIAUX','MAL BOUFFE','TROP MANGER', 'JEU','PROCRASTINATION',"JEUX D'ARGENT", 'FUMEUSE',"DE L'ALCOOL",'DROGUES', 'CANNABIS','REGARDER LA TÉLÉVISION','MENSONGE', 'CAFÉ','QUERELLE','NE PAS DORMIR'],
    'Japanese':['ソーシャルメディア','ファストフード','過食', 'ゲーム','怠慢','ギャンブル', '喫煙','アルコール','薬物', '雑草','テレビを見ている','嘘をつく', 'コーヒー','喧嘩','寝ていません'],
    'Russian':['СОЦИАЛЬНЫЕ МЕДИА','БЫСТРОЕ ПИТАНИЕ','ПЕРЕЕДАНИЕ', 'ИГРОВЫЕ','ПРОКРАСТИНАЦИЯ','ИГРАТЬ В АЗАРТНЫЕ ИГРЫ', 'КУРЕНИЕ','АЛКОГОЛЬ','НАРКОТИКИ', 'СОРНЯК','СМОТРЯ ТЕЛЕВИЗОР','ВРУЩИЙ', 'КОФЕ','ССОРИТЬСЯ','НЕ СПИТ'],
    'Chinese':['社交媒体','快餐','暴饮暴食', '赌博','拖延','赌博', '抽烟','酒精','药物', '杂草','看电视','凌', '咖啡','吵架','不睡觉'],
    'Portuguese':['MÍDIA SOCIAL','COMIDA RÁPIDA','COMER DEMAIS', 'JOGOS','PROCRASTINAÇÃO','JOGATINA', 'FUMAR','ÁLCOOL','DROGAS', 'ERVA','ASSISTINDO TV','DEITADA', 'CAFÉ','BRIGA','NÃO DORME'],
  };
  List searchResult = new List();
  bool showSearchField=false;

  @override
  void initState() {
    textEditingController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.removeListener(_listener);
    textEditingController?.dispose();
    super.dispose();
  }

  void _listener()
  {
    if (textEditingController.text.isEmpty) {
      setState(() {
        _isSearching = false;
      });
    } else {
      setState(() {
        _isSearching = true;
      });
    }
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < titles['English'].length; i++) {
        String data = titles[lang][i];
        if (data.toUpperCase().contains(searchText.toUpperCase())) {
          searchResult.add(data);
        }
      }
    }
  }

  navigate(String value)
  {
    for(int i=0;i<titles['English'].length;i++)
      if(i==titles[lang].indexOf(value))
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddictionDetails(fileName: assets[i],addictionName: titles[lang][i],),));
  }

  Future<bool> onBackPress()async
  {
    if(searchResult.isNotEmpty)
      {
        FocusScope.of(context).requestFocus(new FocusNode());
        textEditingController.clear();
        setState(() {
          searchResult.clear();
        });
      }
    else
      Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: const Color(0xffe9e9e9),
      appBar: AppBar(
        elevation: 2.0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xfff0f0f0),
        title: showSearchField?TextFormField(
          style: TextStyle(color: Colors.black),
          controller: textEditingController,
          onChanged: searchOperation,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: Icon(Icons.search),
            labelText: "Search your addiction",
            labelStyle: GoogleFonts.gugi(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(45.0),
              borderSide: BorderSide(
                color:  Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(45.0),
              borderSide: BorderSide(
                color:  Colors.transparent,
              ),
            ),
          ),
        ):Text.rich(
            TextSpan(
              text: "ADDICT",
              style: TextStyle(fontSize: 25.0,color: Colors.black,fontWeight: FontWeight.w400),
              children: [
                TextSpan(
                  text: "X",
                  style: TextStyle(fontSize: 25.0,color: const Color(0xff9ad0e5),),
                ),
              ],
            ),
        ),
        actions: [
          showSearchField?IconButton(
            icon: Icon(Icons.close,color: Color(0xc277d5f8),),
            onPressed: (){textEditingController.clear();searchResult.clear();},
          ):IconButton(
            onPressed: ()=>setState(()=>showSearchField=true),
            icon: Icon(Icons.search,color: Colors.black,),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: searchResult.length != 0 || textEditingController.text.isNotEmpty?10:0,),
              Flexible(
                  child: searchResult.length != 0 || textEditingController.text.isNotEmpty
                      ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: searchResult.length,
                    itemBuilder: (BuildContext context, int index) {
                      String listData = searchResult[index];
                      return ListTile(
                        onTap: (){FocusScope.of(context).requestFocus(new FocusNode());navigate(listData);},
                        title: Text(listData.toString()),
                      );
                    },
                  )
                      : Container()),
              SizedBox(height: searchResult.length != 0 || textEditingController.text.isNotEmpty?25.0:0,),
              GridView.count(
                shrinkWrap: true,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: ((MediaQuery.of(context).size.width/2.2) / (MediaQuery.of(context).size.height*0.3)),
                children: List.generate(15, (index) => OpenContainer(
                  transitionDuration: Duration(milliseconds: 450),
                  openShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                  closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                  openBuilder: (context,_)=>AddictionDetails(fileName: assets[index],addictionName: titles[lang][index],),
                  closedBuilder: (context,VoidCallback openContainer)=>AddictionCard(
                    title: titles[lang][index],
                    fileName: assets[index],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddictionCard extends StatelessWidget {
  final String title;
  final String fileName;
  AddictionCard({this.title,this.fileName});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Image.asset('assets/addiction/$fileName.png',width: 105,height: 105,),
        ),
        SizedBox(height: 5,),
        Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}