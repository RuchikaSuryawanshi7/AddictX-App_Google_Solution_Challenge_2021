import 'dart:async';
import 'dart:io';
import 'package:addictx/models/dataModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PlanHeading extends StatefulWidget {
  final DataModel planModel;
  final String url;
  final double screenHeight;
  PlanHeading({this.url,this.planModel,this.screenHeight});
  @override
  _PlanHeadingState createState() => _PlanHeadingState();
}

enum TtsState { playing, stopped, paused, continued }

class _PlanHeadingState extends State<PlanHeading> {
  SwiperController controller;
  ValueNotifier<int> _currentIndex = ValueNotifier(0);
  FlutterTts flutterTts;
  String language;
  String engine;
  double volume = 1.0;
  double pitch = 1.4;
  double rate = 0.7;
  bool isCurrentLanguageInstalled = false;


  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;

  @override
  void initState()
  {
    controller=SwiperController();
    initTts();
    super.initState();
  }

  @override
  void dispose()
  {
    controller?.dispose();
    flutterTts.stop();
    _currentIndex?.dispose();
    super.dispose();
  }

  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _speak() async {
    String content=widget.planModel.heading;
    widget.planModel.content.forEach((sentence) {
      content+="      ";
      content+=sentence;
    });
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.setLanguage('en-US');

    if (content != null) {
      if (content.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(content);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){_speak();},
            icon: Icon(Icons.more_horiz),
          ),
        ],
        title: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded,),
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.url),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
              ),
            ),
            padding: EdgeInsets.all(5.0),
            child: Text(
              widget.planModel.heading,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 50,),
          Expanded(
            child: Swiper(
              controller: controller,
              autoplayDelay: 6000,
              loop: false,
              itemCount: widget.planModel.content.length,
              onIndexChanged: (index)=>_currentIndex.value=index,
              itemBuilder:(context,index){
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.planModel.content[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          widget.planModel.content.length<=1?Container():Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder(
                  valueListenable: _currentIndex,
                  child: Container(),
                  builder: (BuildContext context, int value, Widget child){
                    return AnimatedSmoothIndicator(
                      activeIndex: value,
                      count: widget.planModel.content.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        activeDotColor: const Color(0xff9ad0e5),
                        dotColor: const Color(0xffe4e6e7),
                      ),
                      onDotClicked: (index){
                        _currentIndex.value=index;
                        controller.move(index);
                      },
                    );
                  },
                ),
                Text(
                  "Swipe Right",
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
