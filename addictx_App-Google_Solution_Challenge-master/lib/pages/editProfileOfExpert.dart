import 'dart:io';
import 'dart:ui';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/home.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/userModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

class EditProfileOfExpert extends StatefulWidget {
  @override
  _EditProfileOfExpertState createState() => _EditProfileOfExpertState();
}

class _EditProfileOfExpertState extends State<EditProfileOfExpert> {
  TextEditingController textEditingControllerForName;
  TextEditingController textEditingControllerForExperience;
  TextEditingController textEditingControllerForDescription;
  String downloadUrl;
  var cropper;
  final picker=ImagePicker();
  File _image;
  String postId=Uuid().v4();
  bool inProcess=false;
  bool uploading=false;
  String lang='English';
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
  Map pickImageFromCameraText={
    'English':"Pick image from Camera",
    'Hindi':'कैमरा से छवि चुनें',
    'Spanish':'Elija la imagen de la cámara',
    'German':'Bild von der Kamera auswählen',
    'French':"Choisissez l'image de l'appareil photo",
    'Japanese':'カメラから画像を選択',
    'Russian':'Выбрать изображение с камеры',
    'Chinese':'从相机中选取图像',
    'Portuguese':'Escolha uma imagem da câmera',
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
  Map toastMessage={
    'English':"Profile updated successfully.",
    'Hindi':'प्रोफाइल को सफलतापूर्वक अपडेट किया गया।',
    'Spanish':'Perfil actualizado con éxito.',
    'German':'Profil erfolgreich aktualisiert.',
    'French':"Mise à jour du profil réussie.",
    'Japanese':'プロファイルが正常に更新されました。',
    'Russian':'Профиль успешно обновлен.',
    'Chinese':'个人资料更新成功。',
    'Portuguese':'Perfil atualizado com sucesso.',
  };
  Map addAPhoto={
    'English':"Add a photo",
    'Hindi':'चित्र को अपलोड करें',
    'Spanish':'Agregar una foto',
    'German':'Füge ein Foto hinzu',
    'French':"Ajouter une photo",
    'Japanese':'写真を追加する',
    'Russian':'Добавить фото',
    'Chinese':'添加照片',
    'Portuguese':'Adicionar uma foto',
  };
  Map name={
    'English':"Name",
    'Hindi':'नाम',
    'Spanish':'Nombre',
    'German':'Name',
    'French':"Nom",
    'Japanese':'名前',
    'Russian':'Имя',
    'Chinese':'名称',
    'Portuguese':'Nome',
  };
  Map experience={
    'English':'Experience(in yrs)',
    'Hindi':'अनुभव (वर्षों में)',
    'Spanish':'Experiencia (en años)',
    'German':'Erfahrung (in Jahren)',
    'French':"Expérience (en années)",
    'Japanese':'経験（年）',
    'Russian':'Опыт (в годах)',
    'Chinese':'经验（年）',
    'Portuguese':'Experiência (em anos)',
  };
  Map description={
    'English':"Description",
    'Hindi':'विवरण',
    'Spanish':'Descripción',
    'German':'Beschreibung',
    'French':"La description",
    'Japanese':'説明',
    'Russian':'Описание',
    'Chinese':'描述',
    'Portuguese':'Descrição',
  };
  Map save={
    'English':"Save",
    'Hindi':'सेव',
    'Spanish':'Ahorrar',
    'German':'speichern',
    'French':"Sauvegarder",
    'Japanese':'セーブ',
    'Russian':'Сохранить',
    'Chinese':'保存',
    'Portuguese':'Salve',
  };

  @override
  void initState() {
    textEditingControllerForName=TextEditingController();
    textEditingControllerForExperience=TextEditingController();
    textEditingControllerForDescription=TextEditingController();
    textEditingControllerForName.text=currentUser.username;
    textEditingControllerForExperience.text=currentUser.yearsOfExperience.toString();
    textEditingControllerForDescription.text=currentUser.description;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerForName?.dispose();
    textEditingControllerForExperience?.dispose();
    textEditingControllerForDescription?.dispose();
    super.dispose();
  }

  selectImageFromGallery(BuildContext context) async
  {
    setState(() {
      inProcess=true;
    });
    final imageFile= await picker.getImage(source: ImageSource.gallery);
    crop(imageFile,context);
  }
  selectImageFromCamera(BuildContext context) async
  {
    setState(() {
      inProcess=true;
    });
    final imageFile= await picker.getImage(source: ImageSource.camera);
    crop(imageFile,context);
  }
  void crop(var file,BuildContext context) async
  {
    if(file!=null)
    {
      cropper=await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
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
          initAspectRatio: CropAspectRatioPreset.square,
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
          inProcess=false;
          _image=File(file.path);
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
  pickImage(mContext)
  {
    return showDialog(
        context: mContext,
        builder: (context){
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)),),
            title: Text(actions[lang],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.cyan),),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(selectImageFromGalleyText[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){Navigator.pop(context);selectImageFromGallery(context);},
              ),
              SimpleDialogOption(
                child: Text(pickImageFromCameraText[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){Navigator.pop(context);selectImageFromCamera(context);},
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

  compressPhoto() async
  {
    final tDirectory=await getTemporaryDirectory();
    final path= tDirectory.path;
    ImD.Image mImageFile=ImD.decodeImage(_image.readAsBytesSync());
    final compressedImageFile= File('$path/img_$postId.jpg')..writeAsBytesSync(ImD.encodeJpg(mImageFile,quality: 60));
    setState(() {
      _image=compressedImageFile;
    });
  }
  Future<String> uploadFile(File image) async
  {
    String downloadURL;
    Reference ref = usersStorageReference.child(currentUser.id).child("post_$postId.jpg");
    await ref.putFile(image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  updateProfile()async
  {
    setState(() {
      uploading=true;
    });
    if(_image!=null)
    {
      await compressPhoto();
      downloadUrl=await uploadFile(_image);
    }
    usersReference.doc(currentUser.id).update({
      "username":textEditingControllerForName.text,
      "url":downloadUrl==null?currentUser.url:downloadUrl,
      "yearsOfExperience":int.parse(textEditingControllerForExperience.text),
      "description":textEditingControllerForDescription.text,
    });
    QuerySnapshot snapshot=await chatRoomReference.where('ids', arrayContains: currentUser.id).get();
    snapshot.docs.forEach((document) {
      document.reference.update({
        "users":FieldValue.arrayRemove([currentUser.username]),
      });
      document.reference.update({
        "users":FieldValue.arrayUnion([textEditingControllerForName.text]),
      });
      if(document.data()["Avatar1"]==currentUser.url)
      {
        document.reference.update({
          "Avatar1": downloadUrl==null?currentUser.url:downloadUrl,
        });
      }
      else
      {
        document.reference.update({
          "Avatar2": downloadUrl==null?currentUser.url:downloadUrl,
        });
      }
    });
    setState(() {
      uploading=false;
    });
    DocumentSnapshot documentSnapshot=await usersReference.doc(currentUser.id).get();
    currentUser=UserModel.fromDocument(documentSnapshot);
    showToast(toastMessage[lang]);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*1/2.2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image==null?(currentUser.url!=''?CachedNetworkImageProvider(currentUser.url):AssetImage('assets/noDpForExpert.jpg')):FileImage(File(_image.path)),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.arrow_back_ios_rounded),
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        GestureDetector(
                          onTap: ()=>pickImage(context),
                          child: Center(
                            child: DottedBorder(
                              dashPattern: [8, 4],
                              strokeWidth: 3.0,
                              color: Colors.white,
                              child: Container(
                                width: MediaQuery.of(context).size.width/3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    SizedBox(height: 15,),
                                    Icon(Icons.add,color: Colors.white,size: 70.0,),
                                    SizedBox(height: 30.0,),
                                    Text(addAPhoto[lang],
                                      style: GoogleFonts.gugi(
                                        textStyle: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 7.0,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        ClipRect(
                          child: BackdropFilter(
                            filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              margin: EdgeInsets.only(left:10.0,right: 10.0),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topRight:Radius.circular(20),topLeft: Radius.circular(20)),
                                color: Colors.grey.shade200.withOpacity(0.5),
                              ),
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: name[lang],
                                      labelStyle: GoogleFonts.gugi(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    controller: textEditingControllerForName,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right:MediaQuery.of(context).size.width*1/2),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: experience[lang],
                                        labelStyle: GoogleFonts.gugi(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      controller: textEditingControllerForExperience,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)),
                      color: Color(0xff9ad0e5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description[lang],
                          style: GoogleFonts.gugi(
                            textStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.width/2,
                          padding: EdgeInsets.only(left:10.0,right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 8,
                            minLines: 1,
                            controller: textEditingControllerForDescription,
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        GestureDetector(
                          onTap: ()=>updateProfile(),
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
                            width: double.infinity,
                            child: Text(
                              save[lang],
                              style: GoogleFonts.gugi(
                                textStyle: TextStyle(
                                  color: Color(0xff9ad0e5),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            uploading?Center(child: CircularProgressIndicator(),):Container(),
          ],
        ),
      ),
    );
  }
}
