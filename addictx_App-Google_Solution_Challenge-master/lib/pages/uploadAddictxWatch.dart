import 'dart:async';
import 'dart:io';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/home.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/main.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UploadAddictXWatch extends StatefulWidget {
  final String challengeName;
  UploadAddictXWatch({this.challengeName});
  @override
  _UploadAddictXWatchState createState() => _UploadAddictXWatchState();
}

class _UploadAddictXWatchState extends State<UploadAddictXWatch> with AutomaticKeepAliveClientMixin<UploadAddictXWatch>{
  final picker=ImagePicker();
  File _image;
  File _thumbnail;
  String thumbnailDownloadUrl="";
  CachedVideoPlayerController _videoPlayerController;
  CameraController cameraController;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool uploaded=false;
  bool inProcess=false;
  String postId=Uuid().v4();
  Timer _timer;
  int time=0;
  bool recording=false;
  String lang='English';
  Map reduceVideoSize={
    'English':"Failed to upload!!, Reduce size of the video",
    'Hindi':'अपलोड करने में विफल !!, वीडियो का आकार कम करें',
    'Spanish':'Error al cargar !!, Reducir el tamaño del video',
    'German':'Hochladen fehlgeschlagen!!, Größe des Videos reduzieren',
    'French':"Échec du téléchargement !!, Réduire la taille de la vidéo",
    'Japanese':'アップロードに失敗しました!!、動画のサイズを小さくしてください',
    'Russian':'Не удалось загрузить !!, Уменьшите размер видео',
    'Chinese':'上传失败！！，缩小视频大小',
    'Portuguese':'Falha ao enviar !!, Reduza o tamanho do vídeo',
  };
  Map toastMessage={
    'English':'Uploaded successfully',
    'Hindi':'सफलतापूर्वक अपलोड किया गया',
    'Spanish':'Subido con éxito',
    'German':'Erfolgreich hochgeladen',
    'French':"Téléchargé avec succès",
    'Japanese':'正常にアップロードされました',
    'Russian':'Загружено успешно',
    'Chinese':'上传成功',
    'Portuguese':'Carregado com sucesso',
  };
  Map title={
    'English':'New AddictX Watch',
    'Hindi':'न्यू एडिक्टएक्स वॉच',
    'Spanish':'Nuevo reloj AddictX',
    'German':'Neue AddictX-Uhr',
    'French':"Nouvelle montre AddictX",
    'Japanese':'新しいAddictXウォッチ',
    'Russian':'Новые часы AddictX',
    'Chinese':'新的 AddictX 手表',
    'Portuguese':'Novo AddictX Watch',
  };
  Map share={
    'English':"Share",
    'Hindi':'शेयर',
    'Spanish':'Cuota',
    'German':'Teilen',
    'French':"Partager",
    'Japanese':'シェア',
    'Russian':'доля',
    'Chinese':'分享',
    'Portuguese':'Compartilhar',
  };
  Map compressingVideo={
    'English':"Compressing video..",
    'Hindi':'वीडियो को कंप्रेस किया जा रहा है..',
    'Spanish':'Comprimiendo video ..',
    'German':'Video komprimieren..',
    'French':'Compression vidéo..',
    'Japanese':'ビデオの圧縮..',
    'Russian':'Сжатие видео ..',
    'Chinese':'压缩视频..',
    'Portuguese':'Compactando vídeo ..',
  };

  @override
  void initState()
  {
    cameraController = new CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }
  @override
  void dispose()
  {
    cameraController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      cameraController != null
          ? _initializeControllerFuture = cameraController.initialize()
          : null;
    }
  }
  Future<void> _initializeCamera(CameraDescription description) async {
    cameraController = CameraController(description,ResolutionPreset.medium);
    _initializeControllerFuture = cameraController.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  void startTimer() {
    _timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        time++;
      });
      },
    );
  }

  Future<void> startVideoRecording() async {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
      setState(() {
        recording=true;
      });
      startTimer();
    } on CameraException catch (e) {
      // show camera exception
      return;
    }
    catch(e){
      _timer.cancel();
      setState((){
        time=0;
        recording=false;
      });
      print(e);
    }
  }

  Future<XFile> stopVideoRecording() async {
    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      //camera exception
      return null;
    }
    catch(e){
      _timer.cancel();
      setState((){
        time=0;
        recording=false;
      });
      print(e);
    }
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed(){
    stopVideoRecording().then((file)async {
      if (mounted) setState(() {});
      if (file != null){
        final thumbnailFile = await VideoCompress.getFileThumbnail(
            file.path,
            quality: 80, // default(100)
            position: -1 // default(-1)
        );
        _videoPlayerController = CachedVideoPlayerController.file(File(file.path))..setLooping(true)..initialize().then((_) {
          setState(() {
            _image=File(file.path);
            _thumbnail=File(thumbnailFile.path);
            _videoPlayerController.play();
            recording=false;
            _timer.cancel();
            time=0;
          });
        });
      }
    });
  }

  void _toggleCameraLens()async {
    final cameras = await availableCameras();
    final lensDirection = cameraController.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription =
          cameras.firstWhere((description) => description.lensDirection ==
              CameraLensDirection.back);
    }
    else {
      newDescription =
          cameras.firstWhere((description) => description.lensDirection ==
              CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initializeCamera(newDescription);
    }
    else {
      print('Asked camera not available');
    }
  }

  selectVideoFromGallery() async
  {
    var compressedVideoInfo;
    setState(() {
      inProcess=true;
    });
    final videoFile= await picker.getVideo(source: ImageSource.gallery,);
    if(videoFile!=null)
    {
      if(File(videoFile.path).lengthSync()>750000000)
      {
        setState(() {
          inProcess=false;
        });
        showToast(reduceVideoSize[lang]);
      }
      else
      {
        if(File(videoFile.path).lengthSync()>10000000)
        {
          compressedVideoInfo = await VideoCompress.compressVideo(
            videoFile.path,
            quality: VideoQuality.MediumQuality,
            deleteOrigin: false,
          );
        }
        final thumbnailFile = await VideoCompress.getFileThumbnail(
            videoFile.path,
            quality: 80, // default(100)
            position: -1 // default(-1)
        );
        setState(() {
          _image=File(File(videoFile.path).lengthSync()>5000000?compressedVideoInfo.path:videoFile.path);
          _thumbnail=File(thumbnailFile.path);
          inProcess=false;
        });
        _videoPlayerController = CachedVideoPlayerController.file(File(videoFile.path))..setLooping(true)..initialize().then((_) {
          setState(() { });
          _videoPlayerController.play();
        });
      }
    }
    else
      setState(() {
        inProcess=false;
      });
  }

  clearPostInfo()
  {
    setState(() {
      _image=null;
    });
  }

  Future<String> uploadFile(File image) async
  {
    String downloadURL;
    Reference ref = challengeStorageReference.child(currentUser.id).child("post_$postId.jpg");
    await ref.putFile(image,SettableMetadata(contentType: 'video/mp4'));
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
  Future<String> uploadThumbNail(File image) async
  {
    String downloadURL;
    Reference ref =challengeStorageReference.child(currentUser.id).child("post_${postId}thumbnail.jpg");
    await ref.putFile(image,SettableMetadata(contentType: 'video/mp4'));
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  uploadAndSave(BuildContext context,) async
  {
    setState(() {
      uploaded=true;
    });
    String downloadUrl=await uploadFile(_image);
    thumbnailDownloadUrl=await uploadThumbNail(_thumbnail);
    savePostInfoToFirestore(url:downloadUrl,);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  savePostInfoToFirestore({String url,})async
  {
    await addictXWatchChallengeReference.where('challengeName',isEqualTo: widget.challengeName).limit(1).get().then((doc){
      addictXWatchChallengeReference.doc(doc.docs.first.id).update({
        'participants': FieldValue.increment(1),
      });
    });
    DocumentReference documentReference=addictXWatchReference.doc();
    documentReference.set({
      'id':documentReference.id,
      'challengeName':widget.challengeName,
      'timeStamp':FieldValue.serverTimestamp(),
      'url':url,
      'ownerId':currentUser.id,
      'likes':FieldValue.arrayUnion([]),
      'likeCount':0,
      "views":FieldValue.arrayUnion([]),
      "thumbnail":thumbnailDownloadUrl,
    }).catchError((e)=>print(e));
    showToast(toastMessage[lang]);
  }

  Scaffold displayUploadFormScreen(BuildContext context)
  {
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
                fontSize: 25.0,
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
      body:SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 25,),
                VisibilityDetector(
                  key: UniqueKey(),
                  onVisibilityChanged: (VisibilityInfo info) {
                    debugPrint("${info.visibleFraction} of my widget is visible");
                    if(info.visibleFraction == 0){
                      _videoPlayerController.pause();
                    }
                    else{
                      _videoPlayerController.play();
                    }
                  },
                  child: GestureDetector(
                    onTap: (){_videoPlayerController.value.isPlaying?_videoPlayerController.pause():_videoPlayerController.play();},
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 350,),
                      child:  _videoPlayerController.value.initialized
                          ? AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: CachedVideoPlayer(_videoPlayerController),
                      )
                          : Center(child: CircularProgressIndicator(),),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 12.0),),
                GestureDetector(
                  onTap: uploaded?null:()=>uploadAndSave(context),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(15,25,15,10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    height: 60.0,
                    child: Text(
                      share[lang],
                      style: GoogleFonts.gugi(
                        textStyle: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            uploaded?LinearProgressIndicator():Container(),
          ],
        ),
      ),
    );
  }

  Widget buildCameraView(BuildContext context) {
    var camera = cameraController.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }

  stackDesignForPosts(BuildContext context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){selectVideoFromGallery();},
                child: Container(
                  child: Icon(Icons.add,size: 50,color: Colors.black54,),
                ),
              ),
              SizedBox(width: 60,),
              GestureDetector(
                  onTap: (){cameraController.value.isRecordingVideo?onStopButtonPressed():onVideoRecordButtonPressed();},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(recording?Icons.brightness_1:Icons.camera,size: 70,color: Colors.white60,),
                      recording? Container(
                        padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                        child: Text(time.toString()+'s',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        color: Colors.red,
                      ) :Container(),
                    ],
                  )
              ),
              SizedBox(width: 60,),
              GestureDetector(
                onTap: (){_toggleCameraLens();},
                child: Container(
                  child: Icon(Icons.autorenew,size: 50,color: Colors.black54,),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Scaffold cameraUploadScreen(BuildContext context)
  {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.black.withOpacity(0.15),
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          (!cameraController.value.isInitialized)?Container():buildCameraView(context),
          stackDesignForPosts(context),
        ],
      ),
    );
  }
  @override
  bool get wantKeepAlive=>true;

  Future<bool> onBackPress()
  {
    if(_image!=null)
      setState(() {
        _image=null;
      });
    else
      Navigator.pop(this.context);
    return Future.value(false);
  }
  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return WillPopScope(
      onWillPop: onBackPress,
      child: GestureDetector(
        onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: Stack(
          children: <Widget>[
            _image==null?cameraUploadScreen(context):displayUploadFormScreen(context),
            (inProcess)?Material(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(compressingVideo[lang],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                    SizedBox(height: 17,),
                    Container(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ):Center(),
          ],
        ),
      ),
    );
  }
}