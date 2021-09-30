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
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;
import 'package:video_compress/video_compress.dart';
import 'package:visibility_detector/visibility_detector.dart';


class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> with AutomaticKeepAliveClientMixin<Upload>{
  final picker=ImagePicker();
  File _image;
  File _thumbnail;
  String thumbnailDownloadUrl="";
  CachedVideoPlayerController _videoPlayerController;
  CameraController cameraController;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  bool pressed =false;
  var ImagePath;
  var cropper;
  bool uploaded=false;
  bool inProcess=false;
  String postId=Uuid().v4();
  String type;
  File imageFile;
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
    'English':'Added successfully',
    'Hindi':'सफलतापूर्वक हो गया',
    'Spanish':'Agregado exitosamente',
    'German':'Erfolgreich hinzugefügt',
    'French':"Ajouté avec succès",
    'Japanese':'正常に追加されました',
    'Russian':'Добавлено успешно',
    'Chinese':'添加成功',
    'Portuguese':'Adicionado com sucesso',
  };
  Map title={
    'English':'New Post',
    'Hindi':'नई पोस्ट',
    'Spanish':'Nueva publicación',
    'German':'Neuer Beitrag',
    'French':"Nouveau poste",
    'Japanese':'新しい投稿',
    'Russian':'Новый пост',
    'Chinese':'最新帖子',
    'Portuguese':'Nova postage',
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
  Map actions={
    'English':"Actions..",
    'Hindi':'क्रियाएँ ..',
    'Spanish':'Comportamiento..',
    'German':'Aktionen..',
    'French':"Actions..",
    'Japanese':'行動..',
    'Russian':'Действия ..',
    'Chinese':'行动..',
    'Portuguese':'Ações..',
  };
  Map selectImageFromGalleyText={
    'English':"Select Image from gallery",
    'Hindi':'गैलरी से छवि चुनें',
    'Spanish':'Seleccionar imagen de la galería',
    'German':'Bild aus der Galerie auswählen',
    'French':"Sélectionnez l'image de la galerie",
    'Japanese':'ギャラリーから画像を選択',
    'Russian':'Выбрать изображение из галереи',
    'Chinese':'从图库中选择图像',
    'Portuguese':'Selecione uma imagem da galeria',
  };
  Map selectVideoFromGalleyText={
    'English':"Select video from gallery",
    'Hindi':'गैलरी से वीडियो चुनें',
    'Spanish':'Seleccionar video de la galería',
    'German':'Video aus Galerie auswählen',
    'French':"Sélectionnez une vidéo dans la galerie",
    'Japanese':'ギャラリーからビデオを選択',
    'Russian':'Выбрать видео из галереи',
    'Chinese':'从图库中选择视频',
    'Portuguese':'Selecione o vídeo da galeria',
  };
  Map cancel={
    'English':"Cancel",
    'Hindi':'नहीं',
    'Spanish':'Cancelar',
    'German':'Stornieren',
    'French':"Annuler",
    'Japanese':'キャンセル',
    'Russian':'Отмена',
    'Chinese':'取消',
    'Portuguese':'Cancelar',
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
    if(type=="video")
      _videoPlayerController.dispose();
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
  void crop(var pathOrImage,var type,) async
  {
    if(pathOrImage!=null)
    {
      cropper=await ImageCropper.cropImage(
        sourcePath: type=="gallery"?pathOrImage.path:pathOrImage,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9
        ],
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.cyan[300],
          toolbarTitle: "Crop image",
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          title: "Crop image",
        ),
      );
      if(cropper!=null)
      {
        _image=File(cropper.path);
        setState(() {
          inProcess=false;
          type="image";
        });
      }
      else
      {
        setState(() {
          inProcess=false;
          _image=null;
        });
      }
    }
    else
    {
      setState(() {
        inProcess=false;
      });
    }
  }

  void onCaptureButtonPressed(BuildContext context) async {
    try {
      final image=await cameraController.takePicture(); //take photo
      setState(() {
        inProcess=true;
        type="image";
      });
      crop(image.path,"camera",);
    } catch (e) {
      print(e);
    }
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

  selectImageFromGallery(BuildContext context) async
  {
    Navigator.pop(context);
    setState(() {
      inProcess=true;
      type="image";
    });
    final imageFile= await picker.getImage(source: ImageSource.gallery);
    crop(imageFile,"gallery",);
  }


  selectVideoFromGallery() async
  {
    var compressedVideoInfo;
    setState(() {
      inProcess=true;
      type="video";
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
          type="video";
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

  compressPhoto() async
  {
    final tDirectory=await getTemporaryDirectory();
    final path= tDirectory.path;
    ImD.Image mImageFile=ImD.decodeImage(_image.readAsBytesSync());
    final compressedImageFile= File('$path/img_$postId.jpg')..writeAsBytesSync(ImD.encodeJpg(mImageFile,quality: 80));
    setState(() {
      _image=compressedImageFile;
    });
  }
  Future<String> uploadFile(File image) async
  {
    String downloadURL;
    Reference ref = type=="image"?postsStorageReference.child(currentUser.id).child("post_$postId.jpg"):postsStorageReference.child(currentUser.id).child("post_$postId.jpg");
    type=='image'?await ref.putFile(image):await ref.putFile(image,SettableMetadata(contentType: 'video/mp4'));
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
  Future<String> uploadThumbNail(File image) async
  {
    String downloadURL;
    Reference ref =postsStorageReference.child(currentUser.id).child("post_${postId}thumbnail.jpg");
    await ref.putFile(image,SettableMetadata(contentType: 'video/mp4'));
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  uploadAndSave(BuildContext context,) async
  {
    setState(() {
      uploaded=true;
    });
    if(type=="image")
      await compressPhoto();
    String downloadUrl=await uploadFile(_image);
    if(type=="video")
      thumbnailDownloadUrl=await uploadThumbNail(_thumbnail);
    savePostInfoToFirestore(url:downloadUrl,);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  savePostInfoToFirestore({String url,})
  {
    DocumentReference documentReference=postsReference.doc();
    documentReference.set({
      'id':documentReference.id,
      'type':type,
      'timeStamp':FieldValue.serverTimestamp(),
      'content':url,
      'ownerId':currentUser.id,
      'likes':FieldValue.arrayUnion([]),
      "views":FieldValue.arrayUnion([]),
      'location':'',
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
                type=="image"?Container(
                  constraints: BoxConstraints(maxHeight: 350,),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(_image,),fit: BoxFit.contain)),
                ):VisibilityDetector(
                  key: Key(type),
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
                onTap: (){pickImage(context);},
                child: Container(
                  child: Icon(Icons.add,size: 50,color: Colors.black54,),
                ),
              ),
              SizedBox(width: 60,),
              GestureDetector(
                  onTap: (){onCaptureButtonPressed(context);},
                  child: Icon(Icons.camera,size: 70,color: Colors.white60,)
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

  pickImage(mContext)
  {
    return showDialog(
        context: mContext,
        builder: (context){
          return SimpleDialog(
            title: Text(actions[lang],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.cyan),),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(selectImageFromGalleyText[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){selectImageFromGallery(context);},
              ),
              SimpleDialogOption(
                child: Text(selectVideoFromGalleyText[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){Navigator.pop(context);selectVideoFromGallery();},
              ),
              SimpleDialogOption(
                child: Text(cancel[lang],style: TextStyle(fontSize: 17),),
                onPressed: ()=>Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }

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
            _image==null||type==null?cameraUploadScreen(context):displayUploadFormScreen(context),
            (inProcess)?Material(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    type=="video"?Text(compressingVideo[lang],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),):Container(),
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