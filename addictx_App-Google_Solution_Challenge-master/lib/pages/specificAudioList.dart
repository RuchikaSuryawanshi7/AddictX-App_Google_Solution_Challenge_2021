import 'package:addictx/SplashScreen.dart';
import 'package:addictx/pages/music.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SpecificAudioList extends StatefulWidget {
  final String audioConvertedHeading;
  final String audioHeading;
  SpecificAudioList({this.audioConvertedHeading,this.audioHeading});
  @override
  _SpecificAudioListState createState() => _SpecificAudioListState();
}

class _SpecificAudioListState extends State<SpecificAudioList> {
  bool loading=true;
  List<Map> audios=[];

  @override
  void initState(){
    getAudioUrls();
    super.initState();
  }

  void getAudioUrls()async{
    DocumentSnapshot documentSnapshot=await audioTherapiesReference.doc(widget.audioHeading).get();
    audios=List.from(documentSnapshot.data()['audios']);
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    height: MediaQuery.of(context).size.height*0.3,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/audioTherapy/${widget.audioHeading}.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.audioConvertedHeading.toLowerCase().capitalizeFirstOfEach,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                        Text(
                          "Over Eating is the best thing ever.",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 16.0,
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
              SizedBox(height: 15,),
              loading?Center(child: CircularProgressIndicator(),):ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: audios.length,
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> Music(audios: List.from(audios),index: index,),),),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xfff0f0f0),
                      margin: EdgeInsets.only(bottom: 5),
                      padding: EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: CachedNetworkImage(
                              imageUrl: audios[index]['audioImage'],
                              height: MediaQuery.of(context).size.width*0.27,
                              width: MediaQuery.of(context).size.width*0.27,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                audios[index]['audioName'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.5,
                                child: Text(
                                  audios[index]['audioLine'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0x7a000000),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

extension CapExtension on String {
  String get inCaps => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String get capitalizeFirstOfEach => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}