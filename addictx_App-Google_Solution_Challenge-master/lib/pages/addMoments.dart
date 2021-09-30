import 'dart:io';
import 'package:addictx/home.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:addictx/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:image/image.dart' as ImD;


class AddMoments extends StatefulWidget {
  @override
  _AddMomentsState createState() => _AddMomentsState();
}

class _AddMomentsState extends State<AddMoments> {
  String postId=Uuid().v4();
  final picker=ImagePicker();
  File _image;
  File _thumbnail;
  var cropper;
  bool uploading=false;
  bool inProcess=false;
  CameraController cameraController;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  String type;
  bool pressed =false;
  TextEditingController descriptionTextEditingController=TextEditingController();
  CachedVideoPlayerController _videoPlayerController;
  String lang='English';
  Map title={
    'English':'Add Moments',
    'Hindi':'जोड़ें मोमेंटस',
    'Spanish':'Agregar momentos',
    'German':'Momente hinzufügen',
    'French':'Ajouter des moments',
    'Japanese':'モーメントを追加',
    'Russian':'Добавить моменты',
    'Chinese':'添加时刻',
    'Portuguese':'Adicionar momentos',
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

  Map toastMessage={
    'English':"Added moment..",
    'Hindi':'एडेड मोमेंट',
    'Spanish':'Momento añadido..',
    'German':'Moment hinzugefügt..',
    'French':'Moment ajouté..',
    'Japanese':'瞬間を追加しました。',
    'Russian':'Добавлен момент ..',
    'Chinese':'添加时刻..',
    'Portuguese':'Momento adicionado ..',
  };

  Map dialogTitle={
    'English':"New Moments",
    'Hindi':'नए मोमेंटस',
    'Spanish':'Nuevos momentos',
    'German':'Neue Momente',
    'French':'De nouveaux instants',
    'Japanese':'新しい瞬間',
    'Russian':'Новые моменты',
    'Chinese':'新时刻',
    'Portuguese':'Novos momentos',
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

  Map writeSomething={
    'English':"Write something..",
    'Hindi':'कुछ लिखिए..',
    'Spanish':'Escribe algo..',
    'German':'Schreibe etwas..',
    'French':"Écris quelque chose..",
    'Japanese':'何かを書く..',
    'Russian':'Напиши что-нибудь..',
    'Chinese':'写一些东西..',
    'Portuguese':'Escreva algo..',
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

  addMoments(BuildContext context) async
  {
    await takeImage(context);
  }
  Future<String> uploadFile(File image) async
  {
    String downloadURL;
    Reference ref = type=="image"?momentsStorageReference.child(currentUser.id).child("post_$postId.jpg"):momentsStorageReference.child(currentUser.id).child("post_$postId.jpg");
    type=='image'?await ref.putFile(image):await ref.putFile(image,SettableMetadata(contentType: 'video/mp4'));
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadThumbNail(File image) async
  {
    String downloadURL;
    Reference ref =momentsStorageReference.child(currentUser.id).child("post_${postId}thumbnail.jpg");
    await ref.putFile(image,SettableMetadata(contentType: 'video/mp4'));
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
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
  uploadAndSave(BuildContext context) async
  {
    String thumbnailDownloadUrl="";
    setState(() {
      uploading=true;
    });
    if(type=="image")
      await compressPhoto();
    String downloadUrl=await uploadFile(_image);
    if(type=="video")
      thumbnailDownloadUrl=await uploadThumbNail(_thumbnail);
    await saveMomentsInfoToFirestore(url:downloadUrl,thumbnailDownloadUrl: thumbnailDownloadUrl);
    showToast(toastMessage[lang]);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  saveMomentsInfoToFirestore({String url,String thumbnailDownloadUrl})
  {
    momentsReference.doc(currentUser.id).collection("userMoments").doc(postId).set({
      "postId":postId,
      "ownerId": currentUser.id,
      "timeStamp":FieldValue.serverTimestamp(),
      "username": currentUser.username,
      "url":url,
      "description":descriptionTextEditingController==null?"":descriptionTextEditingController.text,
      "seenBy":FieldValue.arrayUnion([currentUser.id]),
      "type":type,
      "thumbnail":thumbnailDownloadUrl
    });
  }

  takeImage(mContext)
  {
    return showDialog(
        context: mContext,
        builder: (context){
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            title: Text(dialogTitle[lang],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.cyan),),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(selectImageFromGalleyText[lang],style: TextStyle(fontSize: 17),),
                onPressed: ()=>selectImageFromGallery(context),
              ),
              SimpleDialogOption(
                child: Text(selectVideoFromGalleyText[lang],style: TextStyle(fontSize: 17),),
                onPressed: ()=>selectVideoFromGallery(context),
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
  Scaffold addMomentsDesign(BuildContext context)
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20,),
            uploading?LinearProgressIndicator():Container(),
            type=="image"?Container(
              constraints: BoxConstraints(maxHeight: 350,),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(image: DecorationImage(image: FileImage(_image,),fit: BoxFit.contain)),
            ):GestureDetector(
              onTap: (){_videoPlayerController.value.isPlaying?_videoPlayerController.pause():_videoPlayerController.play();},
              child: Container(
                constraints: BoxConstraints(maxHeight: 350,),
                width: MediaQuery.of(context).size.width,
                child:  _videoPlayerController.value.initialized
                    ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: CachedVideoPlayer(_videoPlayerController),
                )
                    : Center(child: CircularProgressIndicator(),),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30)
                      ),
                      padding: EdgeInsets.only(left: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: descriptionTextEditingController,
                        decoration: InputDecoration(
                            hintText: "  "+writeSomething[lang],
                            hintStyle: TextStyle(
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
                    child: CircleAvatar(child: Icon(Icons.check),backgroundColor: Colors.cyan[200],),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: ()=>uploadAndSave(context),
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
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void crop(var pathOrImage,var type,BuildContext context) async
  {
    if(pathOrImage!=null)
    {
      cropper=await ImageCropper.cropImage(
        sourcePath: type=="gallery"?pathOrImage.path:pathOrImage,
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.cyan[300],
          toolbarTitle: "Crop image",
          toolbarWidgetColor: Colors.white,
          statusBarColor: Colors.cyan[300],
          backgroundColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          title: "Crop image",
        ),
      );
      if(cropper!=null)
      {
        setState(() {
          inProcess=false;
          _image=File(cropper.path);
        });
      }
      else
      {
        setState(() {
          _image=type=="gallery"?File(pathOrImage.path):File(pathOrImage);
          inProcess=false;
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
      crop(image.path,"camera",context);
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
    crop(imageFile,"gallery",context);
  }

  selectVideoFromGallery(BuildContext context) async
  {
    Navigator.pop(context);
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
        final compressedVideoInfo = await VideoCompress.compressVideo(
          videoFile.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
        );
        final thumbnailFile = await VideoCompress.getFileThumbnail(
            videoFile.path,
            quality: 80, // default(100)
            position: -1 // default(-1)
        );
        setState(() {
          _image=File(compressedVideoInfo.path);
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
          fit: StackFit.loose,
          children: <Widget>[
            (!cameraController.value.isInitialized)?Container():buildCameraView(context),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){addMoments(context);},
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
            )
          ],
        )
    );
  }
  Future<bool> onBackPress()
  {
    if(_image!=null)
      setState(() {
        _image=null;
        descriptionTextEditingController=null;
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
            _image==null?cameraUploadScreen(context):addMomentsDesign(context),
            (inProcess)?Material(
              color: Colors.cyan[50],
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    type=="video"?Text(compressingVideo[lang],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),):Container(),
                    Container(
                      height: 70,
                      width: 70,
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
