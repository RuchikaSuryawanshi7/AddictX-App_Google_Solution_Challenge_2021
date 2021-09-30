import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/languageCode.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/dataModel.dart';
import 'package:addictx/pages/resource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class ResourceVariety extends StatefulWidget {
  final String imageUrl;
  final String heading;
  final String convertedHeading;
  ResourceVariety({this.imageUrl,this.heading,this.convertedHeading});

  @override
  _ResourceVarietyState createState() => _ResourceVarietyState();
}

class _ResourceVarietyState extends State<ResourceVariety> {
  bool loading=true;
  List<Map> varieties=[];
  List<Map> convertedVarieties=[];
  final translator = GoogleTranslator();
  String lang='English';

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData()async{
    DocumentSnapshot snapshot=await resourcesReference.doc(widget.heading).get();
    varieties=List.from(snapshot.data()['varieties']);
    //translate
    if(lang!='English')
      {
        for(int i=0;i<varieties.length;i++)
        {
          List<String> content=[];
          var translationHeading = await translator.translate(varieties[i]['heading'], from: 'en', to: LanguageCode.getCode(lang));
          for(int j=0;j<varieties[i]['content'].length;j++)
            {
              var translationContent = await translator.translate(varieties[i]['content'][j], from: 'en', to: LanguageCode.getCode(lang));
              content.add(translationContent.text);
            }
          convertedVarieties.add({
            'heading':translationHeading.text,
            'content':content,
            'url':varieties[i]['url'],
          });
        }
      }
    else
      {
        convertedVarieties.addAll(varieties);
      }
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.35,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.symmetric(horizontal:10.0,vertical: 15),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      widget.convertedHeading,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 20.0,
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
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.more_horiz,color: Colors.white,),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              loading?Center(child: CircularProgressIndicator(),):ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8.0),
                itemCount: varieties.length,
                itemBuilder: (context,index){
                  DataModel dataModel=DataModel.fromMap(convertedVarieties[index]);
                  return GestureDetector(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Resource(dataModel: dataModel,))),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(bottom: 5),
                          alignment: Alignment.bottomLeft,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height*0.2,
                          decoration: BoxDecoration(
                            color: const Color(0x1a9ad0e5),
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(dataModel.url,),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                            ),
                          ),
                          child: Text(
                            dataModel.heading,
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
