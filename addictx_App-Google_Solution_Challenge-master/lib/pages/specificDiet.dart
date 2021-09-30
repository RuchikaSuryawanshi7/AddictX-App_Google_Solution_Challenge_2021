import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/languageCode.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class SpecificDiet extends StatefulWidget {
  final String category;
  final String subcategory;
  final String convertedSubcategory;
  final String convertedDescription;
  SpecificDiet({this.category,this.subcategory,this.convertedSubcategory,this.convertedDescription});
  @override
  _SpecificDietState createState() => _SpecificDietState();
}

class _SpecificDietState extends State<SpecificDiet> {
  bool loading=true;
  final translator = GoogleTranslator();
  List<String> plans=[];
  String url;
  String lang='English';

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData()async{
    DocumentSnapshot doc=await dietPlanReference.doc(widget.category).collection(widget.subcategory).doc('Plan').get();
    if(doc.exists)
      {
        plans=List.from(doc.data()['plans']);
        url=doc.data()['url'];
      }
    //translate
    if(lang!='English')
      {
        for(int i=0;i<plans.length;i++)
          {
            var translation = await translator.translate(plans[i], from: 'en', to: LanguageCode.getCode(lang));
            plans[i]=translation.text;
          }
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
        child: loading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.3,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(url),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.convertedSubcategory,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                        Text(
                          widget.convertedDescription,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
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
              SizedBox(height: 35,),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: NeverScrollableScrollPhysics(),
                itemCount: plans.length,
                separatorBuilder: (context,index)=>SizedBox(height: 15,),
                itemBuilder: (context,index){
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:1,
                        child: Padding(
                          padding: const EdgeInsets.only(top:3.0),
                          child: Icon(Icons.brightness_1,size: 17,),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          plans[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
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
