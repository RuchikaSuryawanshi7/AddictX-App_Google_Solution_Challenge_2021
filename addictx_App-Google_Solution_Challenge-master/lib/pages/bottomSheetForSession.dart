import 'package:addictx/widgets/fullVideo.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

bottomSheetForSession(BuildContext context,DocumentSnapshot snapshot)
{
  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context){
        return SpecificSession(snapshot: snapshot,);
      }
  );
}

class SpecificSession extends StatefulWidget {
  final DocumentSnapshot snapshot;
  SpecificSession({this.snapshot});
  @override
  _SpecificSessionState createState() => _SpecificSessionState();
}

class _SpecificSessionState extends State<SpecificSession> {
  CachedVideoPlayerController _videoPlayerController;
  bool loading=true;
  bool isPaused=false;
  bool isMute=false;

  @override
  void initState() {
    _videoPlayerController = CachedVideoPlayerController.network(widget.snapshot.data()['videoUrl'])..setLooping(true)..initialize().then((_) {
      setState(() {loading=false; });
    });
    _videoPlayerController.play();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  controlVideoPauseAndPlay()
  {
    if(_videoPlayerController.value.isPlaying)
    {
      _videoPlayerController.pause();
      setState(() {
        isPaused=true;
      });
    }
    else
    {
      _videoPlayerController.play();
      setState(() {
        isPaused=false;
      });
    }
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

  createIndicator()
  {
    return ValueListenableBuilder(
      valueListenable: _videoPlayerController,
      builder: (context,value,child){
        return _videoPlayerController.value.initialized?LinearPercentIndicator(
          padding: EdgeInsets.zero,
          lineHeight: 7,
          animationDuration: 200,
          animateFromLastPercent: true,
          backgroundColor: const Color(0xfff0f0f0),
          progressColor: const Color(0xff9ad0e5),
          percent: value.position.inMilliseconds/value.duration.inMilliseconds>1.0?1.0:value.position.inMilliseconds/value.duration.inMilliseconds,
          animation: true,
        ):Center(child: CircularProgressIndicator(),);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.close)),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              SizedBox(height: 10,),
              loading?Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.25,
                child: Center(child: CircularProgressIndicator(),),
              ):Stack(
                alignment: Alignment.centerRight,
                children: [
                  GestureDetector(
                    onDoubleTap: (){controlAudio();},
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height*0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13.0),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                              height: _videoPlayerController.value.size?.height ?? 0,
                              width: _videoPlayerController.value.size?.width ?? 0,
                              child: CachedVideoPlayer(_videoPlayerController,)
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: (){controlAudio();},
                      child: Container(
                        child: Icon(isMute?Icons.volume_off:Icons.volume_up,color: Colors.white60,),alignment: Alignment.topRight,padding: EdgeInsets.only(right: 10,top: 10),),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>FullVideo(videoPlayerController: _videoPlayerController,createIndicator: createIndicator(),))),
                      child: Icon(Icons.fullscreen,color: Colors.white,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12,),
              Row(
                children: [
                  Text(
                    widget.snapshot.data()['heading'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.access_time,size: 18,),
                  Text(
                    ' '+widget.snapshot.data()['duration'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Text(
                widget.snapshot.data()['about'],
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: createIndicator(),
              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.replay_5),
                    iconSize: 35,
                    onPressed: (){
                      _videoPlayerController.seekTo(Duration(seconds: _videoPlayerController.value.position.inSeconds-5));
                    },
                  ),
                  SizedBox(width: 10,),
                  RawMaterialButton(
                    onPressed: (){controlVideoPauseAndPlay();},
                    elevation: 2.0,
                    fillColor: const Color(0xff9ad0e5),
                    child: Center(
                      child: Icon(
                        isPaused?Icons.play_arrow_rounded:Icons.pause,
                        size: 35.0,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 50,
                      maxWidth: 50,
                      minHeight: 50,
                      minWidth: 50,
                    ),
                    shape: CircleBorder(),
                  ),
                  SizedBox(width: 10,),
                  IconButton(
                    icon: Icon(Icons.forward_5),
                    iconSize: 35,
                    onPressed: (){
                      _videoPlayerController.seekTo(Duration(seconds: _videoPlayerController.value.position.inSeconds+5));
                    },
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ],
    );
  }
}
