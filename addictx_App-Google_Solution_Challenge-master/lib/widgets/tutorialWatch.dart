import 'dart:async';
import 'package:addictx/pages/uploadAddictxWatch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TutorialWatch extends StatefulWidget {
  final String id;
  final String challengeName;
  final Timestamp timestamp;
  final String url;
  final String thumbnail;

  TutorialWatch({this.id,this.timestamp,this.url,this.thumbnail,this.challengeName});

  factory TutorialWatch.fromDocument(DocumentSnapshot documentSnapshot)
  {
    return TutorialWatch(
      id: documentSnapshot.data()["id"],
      timestamp: documentSnapshot.data()['timeStamp'],
      url: documentSnapshot.data()['url'],
      thumbnail: documentSnapshot.data()['thumbnail'],
      challengeName: documentSnapshot.data()['challengeName'],
    );
  }

  @override
  _TutorialWatchState createState() => _TutorialWatchState();
}

class _TutorialWatchState extends State<TutorialWatch> {
  CachedVideoPlayerController _videoPlayerController;
  bool showPause=false;
  bool showPlay=false;
  bool isMute=false;

  @override
  void initState()
  {
    _videoPlayerController = CachedVideoPlayerController.network(widget.url)..setLooping(true)..initialize().then((_) {
      setState(() { });
    });
    super.initState();
  }

  @override
  void dispose()
  {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  controlAudio()
  {
    if(isMute)
    {
      setState(() {
        _videoPlayerController.setVolume(1.0);
        isMute=false;
      });
    }
    else
    {
      setState(() {
        _videoPlayerController.setVolume(0.0);
        isMute=true;
      });
    }
  }

  controlVideoPauseAndPlay()
  {
    if(_videoPlayerController.value.isPlaying)
    {
      _videoPlayerController.pause();
      setState(() {
        showPause=true;
      });
      Timer(Duration(milliseconds: 500),(){
        setState(() {
          showPause=false;
        });
      });
    }
    else
    {
      _videoPlayerController.play();
      setState(() {
        showPlay=true;
      });
      Timer(Duration(milliseconds: 500),(){
        setState(() {
          showPlay=false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: const Color(0xffeff8fb),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.thumbnail),),
                  SizedBox(width: 10,),
                  Text(widget.challengeName,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  Spacer(),
                  IconButton(
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadAddictXWatch(challengeName: widget.challengeName,))),
                    icon: Icon(Icons.add),
                    iconSize: 28,),
                ],
              ),
              SizedBox(height: 5,),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: VisibilityDetector(
                  key: Key(widget.url),
                  onVisibilityChanged: (VisibilityInfo info) {
                    debugPrint("${info.visibleFraction} of my widget is visible");
                    if(info.visibleFraction <0.55){
                      _videoPlayerController.pause();
                    }
                    else{
                      _videoPlayerController.play();
                    }
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _videoPlayerController,
                    builder: (context,value,child){
                      return _videoPlayerController.value.initialized?Stack(
                        children: <Widget>[
                          GestureDetector(
                            onLongPress: (){controlAudio();},
                            onTap: (){controlVideoPauseAndPlay();},
                            child: Container(
                              color: Colors.white,
                              height: _videoPlayerController.value.aspectRatio>1.5?null:MediaQuery.of(context).size.height/2,
                              alignment: Alignment.center,
                              child: AspectRatio(
                                  aspectRatio: _videoPlayerController.value.aspectRatio,
                                  child: CachedVideoPlayer(_videoPlayerController,)
                              ),
                            ),
                          ),
                          Container(padding: EdgeInsets.only(left: 6,top: 6),child: Text((value.duration.inSeconds-value.position.inSeconds).toString()+"s",style: TextStyle(fontSize: 16.5),)),
                          GestureDetector(onTap: (){controlAudio();},child: Container(child: Icon(isMute?Icons.volume_off:Icons.volume_up),alignment: Alignment.topRight,padding: EdgeInsets.only(right: 10,top: 10),))
                        ],
                      ):Center(child: CircularProgressIndicator(),);
                    },
                  ),
                ),
              ),
              SizedBox(height: 12,),
            ],
          ),
        ),
      ],
    );
  }
}
