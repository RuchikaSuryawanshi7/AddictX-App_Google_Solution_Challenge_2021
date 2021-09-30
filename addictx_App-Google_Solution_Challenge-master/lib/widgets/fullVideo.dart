import 'dart:async';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullVideo extends StatefulWidget {
  final CachedVideoPlayerController videoPlayerController;
  final Widget createIndicator;
  FullVideo({this.videoPlayerController,this.createIndicator});

  @override
  _FullVideoState createState() => _FullVideoState();
}

class _FullVideoState extends State<FullVideo> {
  bool fullScreen=false;
  bool showPause=false;
  bool showPlay=false;

  @override
  void dispose() {
    if(widget.videoPlayerController.value.isPlaying)
      widget.videoPlayerController.pause();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void switchScreen()
  {
    if(fullScreen)
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    else
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    setState(() {
      fullScreen=!fullScreen;
    });
  }

  controlVideoPauseAndPlay()
  {
    if(widget.videoPlayerController.value.isPlaying)
    {
      widget.videoPlayerController.pause();
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
      widget.videoPlayerController.play();
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: Colors.grey
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: ()=>controlVideoPauseAndPlay(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: widget.videoPlayerController.value.aspectRatio,
                child: CachedVideoPlayer(widget.videoPlayerController,
                ),
              ),
              Positioned(
                right: 5,
                left: 5,
                bottom: 0,
                child: widget.createIndicator,
              ),
              Positioned(
                right: 5,
                bottom: 10,
                child: GestureDetector(
                  onTap: ()=>switchScreen(),
                  child: Icon(fullScreen?Icons.fullscreen_exit:Icons.fullscreen,color: Colors.white,size: 26,),
                ),
              ),
              showPause?Icon(Icons.pause,color: Colors.white,size: 50,):Container(),
              showPlay?Icon(Icons.play_arrow,color: Colors.white,size: 50,):Container(),
            ],
          ),
        ),
      ),
    );
  }
}