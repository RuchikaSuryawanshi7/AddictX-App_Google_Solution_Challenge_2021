import 'dart:async';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/languageCode.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/music.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class ToDoToday extends StatefulWidget {

  @override
  _ToDoTodayState createState() => _ToDoTodayState();
}

class _ToDoTodayState extends State<ToDoToday> {
  bool loading=true;
  Map task;

  //for audio
  Duration duration;
  Duration position;
  AudioPlayer audioPlayer;
  AudioPlayerState playerState = AudioPlayerState.STOPPED;
  get isPlaying => playerState == AudioPlayerState.PLAYING;
  get durationText =>
      duration != null ? duration.toString().split('.').first.substring(2) : '';
  get positionText =>
      position != null ? position.toString().split('.').first.substring(2) : '';
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  bool visible=true;
  bool up=true;
  int sec=500;
  double bound=15;
  final translator = GoogleTranslator();
  String lang='English';
  Map title={
    'English':'AddictX Therapy',
    'Hindi':'एडिक्टएक्स थेरेपी',
    'Spanish':'Terapia AddictX',
    'German':'AddictX-Therapie',
    'French':"Thérapie AddictX",
    'Japanese':'アディクトXセラピー',
    'Russian':'AddictX терапия',
    'Chinese':'AddictX 疗法',
    'Portuguese':'Terapia AddictX',
  };
  Map toDoToday={
    'English':"Things To Do Today",
    'Hindi':'आज करने वाले काम',
    'Spanish':'Cosas que hacer hoy',
    'German':'Dinge, die heute zu tun sind',
    'French':"Choses à faire aujourd'hui",
    'Japanese':'今日やるべきこと',
    'Russian':'Что делать сегодня',
    'Chinese':'今天要做的事情',
    'Portuguese':'Coisas para fazer hoje',
  };

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _audioPlayerStateSubscription?.cancel();
    audioPlayer?.stop();
    super.dispose();
  }

  getData()async
  {
    DocumentSnapshot doc=await toDoTodayReference.doc('todaysTask').get();
    task=doc.data()['task'];
    //translate
    if(lang!='English')
      {
        var heading = await translator.translate(task['heading'], from: 'en', to: LanguageCode.getCode(lang));
        task['heading']=heading.text;
        var content = await translator.translate(task['content'], from: 'en', to: LanguageCode.getCode(lang));
        task['content']=content.text;
        var author = await translator.translate(task['author'], from: 'en', to: LanguageCode.getCode(lang));
        task['author']=author.text;
      }
    setState(() {
      loading=false;
    });
    if(task['type']=="audio")
    {
      initAudioPlayer();
    }
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
          if (s == AudioPlayerState.PLAYING) {
            setState(() => duration = audioPlayer.duration);
          } else if (s == AudioPlayerState.STOPPED) {
            onComplete();
            setState(() {
              position = duration;
            });
          } else if(s == AudioPlayerState.COMPLETED) {
            play();
          }
        }, onError: (msg) {
          setState(() {
            playerState = AudioPlayerState.STOPPED;
            duration = Duration(seconds: 0);
            position = Duration(seconds: 0);
          });
        });
    duration=Duration(seconds: 0);
    position=Duration(seconds: 0);
    play();
  }

  Future play() async {
    await audioPlayer.play(task['audioUrl']);
    setState(() {
      playerState = AudioPlayerState.PLAYING;
      up=!up;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState((){
      playerState = AudioPlayerState.PAUSED;
    });
  }

  void onComplete() {
    setState(() => playerState = AudioPlayerState.STOPPED);
  }

  Column _buildProgress(){
    return Column(
      children: [
        if (duration != null)
          Container(
            height: 20,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                trackShape: CustomTrackShape(),
              ),
              child: Slider(
                value: position?.inMilliseconds?.toDouble() ?? 0.0,
                onChanged: (double value) {
                  return audioPlayer.seek((value / 1000).roundToDouble());
                },
                activeColor: const Color(0xff9ad0e5),
                inactiveColor: const Color(0xfff0f0f0),
                min: 0.0,
                max: duration.inMilliseconds.toDouble(),
              ),
            ),
          ),
        if (position != null) _buildProgressView(),
      ],
    );
  }
  Row _buildProgressView(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          position != null
              ? "${positionText ?? ''}"
              : duration != null ? durationText : '',
          style: TextStyle(fontSize: 15.0,color: Colors.black),
        ),
        Text(
          position != null
              ? "${durationText ?? ''}"
              : duration != null ? durationText : '',
          style: TextStyle(fontSize: 15.0,color: Colors.black),
        ),
      ],
    );
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
                fontSize: 20.0,
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/toDoTodayBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: loading?Center(child: CircularProgressIndicator(),)
            :task['type']=="video"?VideoPlayer(task: task,)
            :task['type']=="content"?Content(task: task,):Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              SizedBox(height: 45,),
              Text(
                toDoToday[lang],
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width*0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(task['image']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      color: Colors.white38,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width/8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: sec), // Animation speed
                            transform: Transform.translate(
                              offset: Offset(0, up == true ? -1*bound : bound), // Change -100 for the y offset
                            ).transform,
                            onEnd: (){
                              setState(() {
                                if(isPlaying)up=!up;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width/7,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                color: isPlaying?const Color(0xff9ad0e5):Colors.black,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: sec), // Animation speed
                            transform: Transform.translate(
                              offset: Offset(0, up == true ? bound :-1* bound), // Change -100 for the y offset
                            ).transform,
                            onEnd: (){
                              setState(() {
                                if(isPlaying)up=!up;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width/7,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                color: isPlaying?const Color(0xff9ad0e5):Colors.black,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: sec), // Animation speed
                            transform: Transform.translate(
                              offset: Offset(0, up == true ? -1*bound : bound), // Change -100 for the y offset
                            ).transform,
                            onEnd: (){
                              setState(() {
                                if(isPlaying)up=!up;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width/7,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                color: isPlaying?const Color(0xff9ad0e5):Colors.black,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: sec), // Animation speed
                            transform: Transform.translate(
                              offset: Offset(0, up == true ? bound :-1* bound), // Change -100 for the y offset
                            ).transform,
                            onEnd: (){
                              setState(() {
                                if(isPlaying)up=!up;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width/7,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                color: isPlaying?const Color(0xff9ad0e5):Colors.black,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: sec), // Animation speed
                            transform: Transform.translate(
                              offset: Offset(0, up == true ? -1*bound : bound), // Change -100 for the y offset
                            ).transform,
                            onEnd: (){
                              setState(() {
                                if(isPlaying)up=!up;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width/7,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                color: isPlaying?const Color(0xff9ad0e5):Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                task['heading'],
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 22.0,
                ),
              ),
              Text(
                task['author'],
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){
                  isPlaying ? pause(): play();
                },
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black,width: 3),
                  ),
                  child: Icon(isPlaying?Icons.pause:Icons.play_arrow_rounded,size: 45.0,color: Colors.black),
                ),
              ),
              SizedBox(height: 10,),
              _buildProgress(),
              SizedBox(height: 10,),
              Text(
                task['content'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayer extends StatefulWidget {
  final Map task;
  VideoPlayer({this.task});
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  CachedVideoPlayerController _videoPlayerController;
  bool loading=true;
  bool showPause=false;
  bool showPlay=false;
  bool isMute=false;
  Map toDoToday={
    'English':"Things To Do Today",
    'Hindi':'आज करने वाले काम',
    'Spanish':'Cosas que hacer hoy',
    'German':'Dinge, die heute zu tun sind',
    'French':"Choses à faire aujourd'hui",
    'Japanese':'今日やるべきこと',
    'Russian':'Что делать сегодня',
    'Chinese':'今天要做的事情',
    'Portuguese':'Coisas para fazer hoje',
  };

  @override
  void initState() {
    _videoPlayerController = CachedVideoPlayerController.network(widget.task['videoUrl'])..setLooping(false)..initialize().then((_) {
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
          lineHeight: 5,
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
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: loading?Center(child: CircularProgressIndicator(),):Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 45,),
          Center(
            child: Text(
              toDoToday[lang],
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 45,),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              GestureDetector(
                onDoubleTap: (){controlAudio();},
                onTap: (){controlVideoPauseAndPlay();},
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.3,
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
                left: 10,
                right: 10,
                bottom: 10,
                child: createIndicator(),
              ),
              showPause?Center(child: Icon(Icons.pause,color: Colors.white,size: 70,)):Container(),
              showPlay?Center(child: Icon(Icons.play_arrow_rounded,color: Colors.white,size: 70,)):Container(),
            ],
          ),
          SizedBox(height: 15,),
          Text(
            widget.task['heading'],
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 22.0,
            ),
          ),
          Text(
            widget.task['author'],
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 35,),
          Text(
            widget.task['content'],
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  final Map task;
  Content({this.task});
  Map toDoToday={
    'English':"Things To Do Today",
    'Hindi':'आज करने वाले काम',
    'Spanish':'Cosas que hacer hoy',
    'German':'Dinge, die heute zu tun sind',
    'French':"Choses à faire aujourd'hui",
    'Japanese':'今日やるべきこと',
    'Russian':'Что делать сегодня',
    'Chinese':'今天要做的事情',
    'Portuguese':'Coisas para fazer hoje',
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 45,),
            Center(
              child: Text(
                toDoToday[lang],
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 45,),
            ClipRRect(
              borderRadius: BorderRadius.circular(13.0),
              child: CachedNetworkImage(
                imageUrl: task['image'],
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.3,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15,),
            Text(
              task['heading'],
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 22.0,
              ),
            ),
            Text(
              task['author'],
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 35,),
            Text(
              task['content'],
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
