import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/specificAudioList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AudioTherapy extends StatelessWidget {
  Map<String, List> audioTherapy;
  AudioTherapy({this.audioTherapy});
  Map title={
    'English':'Audio Therapy',
    'Hindi':'ऑडियो थेरेपी',
    'Spanish':'Terapia de audio',
    'German':'Audiotherapie',
    'French':'Audiothérapie',
    'Japanese':'オーディオセラピー',
    'Russian':'Аудиотерапия',
    'Chinese':'音频治疗',
    'Portuguese':'Terapia de Áudio',
  };
  Map tagLine={
    'English':"#Stay Fit With Addictx",
    'Hindi':'#एडिक्टएक्स के साथ फिट रहें',
    'Spanish':'#Mantente en forma con Addictx',
    'German':'#Bleib fit mit Addictx',
    'French':'#Restez en forme avec Addictx',
    'Japanese':'#Addictxで健康を維持',
    'Russian':'#Оставайся в форме с Addictx',
    'Chinese':'与 Addictx 保持健康',
    'Portuguese':'#Fique em forma com Addictx',
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider("https://images.unsplash.com/photo-1587636216714-3043fed23aeb?ixid=MnwxMjA3fDB8MHx2aXN1YWwtc2VhcmNofDF8fHxlbnwwfHx8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      tagLine[lang],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: ()=>Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
                      ),
                      Text(
                        title[lang]+' ',
                        style: TextStyle(
                          fontSize: 25.0,
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                itemCount: audioTherapy['English'].length,
                staggeredTileBuilder: (index)=>StaggeredTile.extent(1,MediaQuery.of(context).size.width*1.3/3),
                itemBuilder: (context,index)
                {
                  return GestureDetector(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SpecificAudioList(audioConvertedHeading: audioTherapy[lang][index],audioHeading: audioTherapy['English'][index],))),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: MediaQuery.of(context).size.width*1.3/3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              image: DecorationImage(
                                  image: AssetImage('assets/audioTherapy/${audioTherapy['English'][index]}.jpg'),
                                  fit: BoxFit.cover
                              )
                          ),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0),),
                            ),
                            child: Text(
                              audioTherapy[lang][index],
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.gugi(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
