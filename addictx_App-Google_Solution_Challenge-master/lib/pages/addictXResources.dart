import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/languageCode.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/resourceVarieties.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class AddictXResources extends StatefulWidget {
  @override
  _AddictXResourcesState createState() => _AddictXResourcesState();
}

class _AddictXResourcesState extends State<AddictXResources> {
  bool loading=true;
  List<Map> resourcesData=[];
  List<Map> convertedResourcesData=[];
  final translator = GoogleTranslator();
  String lang='English';
  Map title={
    'English':'AddictX Resources',
    'Hindi':'एडिक्टएक्स संसाधन',
    'Spanish':'AddictX Recursos',
    'German':'AddictX-Ressourcen',
    'French':'AddictX Ressources',
    'Japanese':'AddictXリソース',
    'Russian':'AddictX Ресурсы',
    'Chinese':'AddictX 资源',
    'Portuguese':'AddictX Recursos',
  };

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData()async{
    DocumentSnapshot snapshot=await resourcesReference.doc('resourceList').get();
    resourcesData=List.from(snapshot.data()['data']);
    //translate
    if(lang!='English')
      {
        for(int i=0;i<resourcesData.length;i++)
          {
            var translationHeading = await translator.translate(resourcesData[i]['heading'], from: 'en', to: LanguageCode.getCode(lang));
            convertedResourcesData.add({
              'heading':translationHeading.text,
              'url':resourcesData[i]['url'],
            });
          }
      }
    else
      convertedResourcesData.addAll(resourcesData);
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
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
                fontSize: 23.0,
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
      body: loading?Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(child: CircularProgressIndicator(),),
      ):SingleChildScrollView(
        child: Column(
          children: List.generate(resourcesData.length, (index) {
            return Container(
              margin: EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ResourceVariety(imageUrl: resourcesData[index]['url'], heading: resourcesData[index]['heading'],convertedHeading: convertedResourcesData[index]['heading'],))),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.bottomLeft,
                      height: MediaQuery.of(context).size.height*0.2,
                      decoration: BoxDecoration(
                        color: const Color(0x1a9ad0e5),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(convertedResourcesData[index]['url'],),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        convertedResourcesData[index]['heading'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                        ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 20,),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
