import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class Music extends StatefulWidget {
  final List<Map> audios;
  int index;
  Music({this.audios,this.index});
  @override
  _MusicState createState() => _MusicState(audios: audios,index: index);
}

class _MusicState extends State<Music> {
  List<Map> audios;
  int index;
  Duration duration;
  Duration position;
  bool loop=false;
  bool isPlaying=true;
  bool showPlayList=false;
  bool loadingShare=false;

  AudioPlayer audioPlayer;

  AudioPlayerState playerState = AudioPlayerState.STOPPED;

  get durationText =>
      duration != null ? duration.toString().split('.').first.substring(2) : '';

  get positionText =>
      position != null ? position.toString().split('.').first.substring(2) : '';

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  _MusicState({this.audios, this.index});

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
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
            playNextAudioIfNotInLoop();
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
    await audioPlayer.play(audios[index]['audioUrl']);
    setState(() {
      playerState = AudioPlayerState.PLAYING;
      isPlaying=true;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState((){
      playerState = AudioPlayerState.PAUSED;
      isPlaying=false;
    });
  }

  void nextAudio(){
    if(index!=audios.length-1)
      {
        index++;
        loop=false;
        _positionSubscription.cancel();
        _audioPlayerStateSubscription.cancel();
        audioPlayer.stop();
        initAudioPlayer();
        play();
      }
  }

  void prevAudio(){
    if(index!=0)
    {
      index--;
      loop=false;
      _positionSubscription.cancel();
      _audioPlayerStateSubscription.cancel();
      audioPlayer.stop();
      initAudioPlayer();
      play();
    }
  }

  void shufflePlayList()
  {
    Map audio=audios[index];
    audios.shuffle();
    setState(() {
      index=audios.indexOf(audio);
    });
  }

  void playSelectedAudio({int index})
  {
    this.index=index;
    loop=false;
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    initAudioPlayer();
  }

  void onComplete() {
    setState(() => playerState = AudioPlayerState.STOPPED);
  }

  void playNextAudioIfNotInLoop()async
  {
    if(loop)
      {
        audioPlayer.stop();
        play();
      }
    else
      nextAudio();
  }

  Widget _buildControls() => Container(
    padding: EdgeInsets.fromLTRB(16,16,16,showPlayList?0:16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: ()=>setState(()=>loop=!loop),
              iconSize: 35.0,
              icon: Icon(Icons.repeat_rounded,color: loop?const Color(0xff9ad0e5):showPlayList?Colors.white:Colors.black,),
            ),
            IconButton(
              onPressed: index!=0?()=>prevAudio():null,
              iconSize: 40.0,
              icon: Icon(Icons.skip_previous_rounded,color: showPlayList?Colors.white.withOpacity(index==0?0.7:1):Colors.black.withOpacity(index==0?0.4:1),),
            ),
            GestureDetector(
              onTap: (){
                isPlaying ? pause(): play();
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: showPlayList?const Color(0xff6f6e6e):const Color(0xfff0f0f0),
                child: isPlaying==false?Icon(Icons.play_arrow,size: 40.0,color: showPlayList?Colors.white:Colors.black,):
                Icon(Icons.pause,size: 35.0,color: showPlayList?Colors.white:Colors.black,),
              ),
            ),
            IconButton(
              onPressed: (index!=audios.length-1)?(){
                  nextAudio();
              }:null,
              iconSize: 40.0,
              icon: Icon(Icons.skip_next_rounded,color: showPlayList?Colors.white.withOpacity(index==audios.length-1?0.7:1):Colors.black.withOpacity(index==audios.length-1?0.4:1),),
            ),
            IconButton(
              onPressed: ()=>shufflePlayList(),
              iconSize: 25.0,
              icon: Icon(FontAwesomeIcons.random,color: showPlayList?Colors.white:Colors.black,),
            ),
          ],
        ),
      ],
    ),
  );
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
            style: TextStyle(fontSize: 15.0,color: showPlayList?Colors.white:Colors.black),
          ),
          Text(
            position != null
                ? "${durationText ?? ''}"
                : duration != null ? durationText : '',
            style: TextStyle(fontSize: 15.0,color: showPlayList?Colors.white:Colors.black),
          ),
        ],
    );
  }

  Column shrinkedDesign(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  audios[index]['audioName'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: ()=>setState(()=>showPlayList=false),
              icon: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.white,size: 40,),
            ),
          ],
        ),
        Spacer(),
        _buildProgress(),
        _buildControls(),
      ],
    );
  }

  Widget listOfAudio()
  {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 7),
      itemCount: audios.length,
      itemBuilder: (context,index){
        return GestureDetector(
          onTap: ()=>this.index==index?null:playSelectedAudio(index: index),
          child: Container(
            width: double.infinity,
            color: this.index==index?const Color(0xa69ad0e5):const Color(0xfff0f0f0),
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
    );
  }
  Future<bool> onBackPress()
  {
    if(showPlayList)
      setState(() {
        showPlayList=false;
      });
    else
      Navigator.pop(context);
    return Future.value(false);
  }

  void shareAudio()async{
    setState(() {
      loadingShare=true;
    });
    final response = await get(Uri.parse(audios[index]['audioImage']));
    final Directory temp = await getTemporaryDirectory();
    final File imageFile = File('${temp.path}/tempImage.png');
    imageFile.writeAsBytesSync(response.bodyBytes);
    Share.shareFiles(
      ['${temp.path}/tempImage.png'],
      text: "*${audios[index]['audioName']}*\n${audios[index]['audioLine']}"
          + "\n\n${audios[index]['audioDescription']}\n\nGo and listen this amazing therapy in AddictX"
          +"\nhttps://play.google.com/store/apps/details?id=com.exordium.addictx",
    );
    setState(() {
      loadingShare=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: double.infinity,
                          height: showPlayList?MediaQuery.of(context).size.height*0.25:MediaQuery.of(context).size.height*0.38,
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(audios[index]['audioImage']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: showPlayList?shrinkedDesign():Row(
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
                        ),
                        showPlayList?listOfAudio():Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProgress(),
                              SizedBox(height: 20,),
                              Text(
                                audios[index]['audioName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25.0,
                                ),
                              ),
                              Text(audios[index]['audioLine'],),
                              SizedBox(height: 30,),
                              _buildControls(),
                              SizedBox(height: 30,),
                              Text(
                                audios[index]['audioDescription'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xff707070),
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    showPlayList?Container():Positioned(
                      bottom: 5,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: ()=>setState(()=>showPlayList=!showPlayList),
                            icon: Icon(Icons.playlist_play_outlined,size: 40,),
                          ),
                          IconButton(
                            onPressed: ()=>shareAudio(),
                            icon: Icon(FontAwesomeIcons.share,size: 22,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            loadingShare?Center(child: CircularProgressIndicator(),):Container(),
          ],
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}