import 'dart:io';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/addictionTracker.dart';
import 'package:addictx/pages/habbitBuildingTracking.dart';
import 'package:addictx/pages/relaxationActivitiesTracking.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as ImD;
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/home.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  File _image;
  var cropper;
  bool uploading=false;
  bool inProcess=false;
  String postId=Uuid().v4();
  final picker=ImagePicker();
  String downloadUrl;
  String lang='English';
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
  Map newName={
    'English':"Enter new name",
    'Hindi':'नया नाम दर्ज करें',
    'Spanish':'Ingrese nuevo nombre',
    'German':'Neuen Namen eingeben',
    'French':"Entrez un nouveau nom",
    'Japanese':'新しい名前を入力してください',
    'Russian':'Введите новое имя',
    'Chinese':'输入新名称',
    'Portuguese':'Digite o novo nome',
  };
  Map loginToEdit={
    'English':'Login to edit the profile',
    'Hindi':'प्रोफ़ाइल संपादित करने के लिए लॉगिन करें',
    'Spanish':'Inicie sesión para editar el perfil',
    'German':'Melden Sie sich an, um das Profil zu bearbeiten',
    'French':"Connectez-vous pour modifier le profil",
    'Japanese':'ログインしてプロファイルを編集します',
    'Russian':'Авторизуйтесь, чтобы редактировать профиль',
    'Chinese':'登录以编辑个人资料',
    'Portuguese':'Faça login para editar o perfil',
  };
  Map addictionTracker={
    'English':'Addiction Tracker',
    'Hindi':'लत ट्रैकर',
    'Spanish':'Rastreador de adicciones',
    'German':'Sucht-Tracker',
    'French':'Suivi des dépendances',
    'Japanese':'アディクショントラッカー',
    'Russian':'Отслеживание зависимости',
    'Chinese':'成瘾追踪器',
    'Portuguese':'Rastreador de Vício',
  };
  Map addictiondescription={
    'English':"Track your Addiction progress",
    'Hindi':'अपनी लत की प्रगति को ट्रैक करें',
    'Spanish':'Seguimiento de su progreso de adicción',
    'German':'Verfolge deinen Suchtfortschritt',
    'French':'Suivez vos progrès en matière de toxicomanie',
    'Japanese':'あなたの中毒の進行状況を追跡する',
    'Russian':'Отслеживайте свой прогресс в зависимости',
    'Chinese':'跟踪您的成瘾进度',
    'Portuguese':'Acompanhe o progresso do seu vício',
  };
  Map relaxingActivity={
    'English':"Relaxing Activity",
    'Hindi':'आराम की गतिविधि',
    'Spanish':'Actividad relajante',
    'German':'Entspannende Aktivität',
    'French':'Activité de détente',
    'Japanese':'リラックスアクティビティ',
    'Russian':'Расслабляющая деятельность',
    'Chinese':'放松活动',
    'Portuguese':'Atividade Relaxante',
  };
  Map relaxingDescription={
    'English':"Track your Relaxing Activities",
    'Hindi':'अपनी आरामदेह गतिविधियों को ट्रैक करें',
    'Spanish':'Seguimiento de sus actividades relajantes',
    'German':'Verfolgen Sie Ihre entspannenden Aktivitäten',
    'French':'Suivez vos activités de détente',
    'Japanese':'リラックスできるアクティビティを追跡する',
    'Russian':'Следите за своей расслабляющей деятельностью',
    'Chinese':'跟踪您的放松活动',
    'Portuguese':'Monitore suas atividades relaxantes',
  };
  Map habitBuilding={
    'English':'Habit Building',
    'Hindi':'आदत निर्माण',
    'Spanish':'Construcción de hábitos',
    'German':'Gewohnheitsgebäude',
    'French':"Construction d'habitudes",
    'Japanese':'習慣の構築',
    'Russian':'Привычка',
    'Chinese':'习惯养成',
    'Portuguese':'Construção de Hábitos',
  };
  Map habitDescription={
    'English':"Track your daily Habits",
    'Hindi':'अपनी दैनिक आदतों को ट्रैक करें',
    'Spanish':'Seguimiento de sus hábitos diarios',
    'German':'Verfolgen Sie Ihre täglichen Gewohnheiten',
    'French':"Suivez vos habitudes quotidiennes",
    'Japanese':'あなたの毎日の習慣を追跡する',
    'Russian':'Отслеживайте свои повседневные привычки',
    'Chinese':'跟踪您的日常习惯',
    'Portuguese':'Monitore seus hábitos diários',
  };
  Map water={
    'English':"Water Level Indicator",
    'Hindi':'जल स्तर संकेतक',
    'Spanish':'Indicador de nivel de agua',
    'German':'Wasserstandsanzeige',
    'French':"Indicateur de niveau d'eau",
    'Japanese':'水位インジケーター',
    'Russian':'Индикатор уровня воды',
    'Chinese':'水位指示器',
    'Portuguese':'Indicador de nível de água',
  };
  Map waterdescription={
    'English':"Track your water intake",
    'Hindi':'अपने पानी के सेवन को ट्रैक करें',
    'Spanish':'Seguimiento de su ingesta de agua',
    'German':'Verfolgen Sie Ihre Wasseraufnahme',
    'French':"Suivez votre consommation d'eau",
    'Japanese':'あなたの水の摂取量を追跡します',
    'Russian':'Следите за потреблением воды',
    'Chinese':'跟踪您的饮水量',
    'Portuguese':'Monitore sua ingestão de água',
  };
  Map pedometer={
    'English':"Pedometer",
    'Hindi':'पेडोमीटर',
    'Spanish':'Podómetro',
    'German':'Schrittzähler',
    'French':"Pédomètre",
    'Japanese':'歩数計',
    'Russian':'Шагомер',
    'Chinese':'计步器',
    'Portuguese':'Pedômetro',
  };
  Map pedometerdescription={
    'English':"Track your daily steps",
    'Hindi':'अपने दैनिक कदम ट्रैक करें',
    'Spanish':'Seguimiento de sus pasos diarios',
    'German':'Verfolgen Sie Ihre täglichen Schritte',
    'French':"Suivez vos pas quotidiens",
    'Japanese':'あなたの毎日の歩数を追跡する',
    'Russian':'Отслеживайте свои ежедневные шаги',
    'Chinese':'跟踪您的日常步数',
    'Portuguese':'Monitore seus passos diários',
  };

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

  update(String name)async
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
      "username":name,
      "url":downloadUrl==null?currentUser.url:downloadUrl,
    });
    QuerySnapshot snapshot=await chatRoomReference.where('ids', arrayContains: currentUser.id).get();
    snapshot.docs.forEach((document) {
      document.reference.update({
        "users":FieldValue.arrayRemove([currentUser.username]),
      });
      document.reference.update({
        "users":FieldValue.arrayUnion([name]),
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

  void editProfileDialog(BuildContext context){
    TextEditingController nameEditingController=TextEditingController();
    nameEditingController.text=currentUser.username;
    var alertDialog=AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)),
      actions: <Widget>[
        StatefulBuilder(
          builder: (context,updateState)
          {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 80),
                      child: Stack(
                        children: [
                          currentUser!=null&&currentUser.url!=""?CircleAvatar(
                            radius: 60.0,
                            backgroundImage: CachedNetworkImageProvider(currentUser.url),
                          ):CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.person,color: Colors.black26,size: 55,),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: ()=>selectImageFromGallery(context,updateState),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xff9ad0e5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.add_a_photo_rounded,color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    Text(newName[lang],style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: nameEditingController,
                        decoration: InputDecoration(
                          hintText: name[lang],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 145,),
                        RaisedButton(
                          color: Color(0xff9ad0e5),
                          child: Text(cancel[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        SizedBox(width: 10,),
                        RaisedButton(
                          color: Color(0xff9ad0e5),
                          child: Text(save[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          onPressed: (){
                            update(nameEditingController.text);
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ],
                    ),
                  ],
                ),
                inProcess||uploading?Center(child: CircularProgressIndicator(),):Container(),
              ],
            );
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialog;
        });
  }

  selectImageFromGallery(BuildContext context,StateSetter updateState) async
  {
    updateState(() {
      inProcess=true;
    });
    final imageFile= await picker.getImage(source: ImageSource.gallery);
    crop(imageFile,updateState);
  }

  void crop(var pathOrImage,StateSetter updateState) async
  {
    if(pathOrImage!=null)
    {
      cropper=await ImageCropper.cropImage(
        sourcePath: pathOrImage.path,
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
        updateState(() {
          inProcess=false;
        });
      }
      else
      {
        updateState(() {
          inProcess=false;
        });
        setState(() {
          _image=null;
        });
      }
    }
    else
    {
      updateState(() {
        inProcess=false;
      });
    }
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
        title: Text.rich(
          TextSpan(
            text: "ADDICT",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: "X",
                style: TextStyle(
                  color: const Color(0xff9ad0e5),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xfff0f0f0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Stack(
                alignment: Alignment.center,
                children: [
                  Material(
                    shape: CircleBorder(),
                    elevation: 5.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: MediaQuery.of(context).size.width*1.1/5+5,
                    ),
                  ),
                  currentUser!=null&&currentUser.url!=''? CircleAvatar(
                    radius: MediaQuery.of(context).size.width*1.1/5,
                    backgroundImage: CachedNetworkImageProvider(currentUser.url),
                  ):CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: MediaQuery.of(context).size.width*1.1/5,
                    child: Icon(Icons.person,color: Colors.black26,size: 150,),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: ()=>currentUser!=null?editProfileDialog(context):showToast(loginToEdit[lang]),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit,color: Colors.black,),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.0,),
              Text(
                currentUser!=null?currentUser.username:username,
                style: GoogleFonts.gugi(
                  textStyle: TextStyle(
                    fontSize: 24.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
              ListTile(
                tileColor: Colors.white,
                minVerticalPadding: 20,
                onTap: ()=>currentUser!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>AddictionTracker())):showToast('Login to track progress...'),
                title: Text(
                  addictionTracker[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(addictiondescription[lang]),
                leading: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.wine_bar,size: 30.0,color: const Color(0xff9ad0e5),),
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top:10.0),
                  child: Icon(Icons.arrow_forward_ios_rounded,),
                ),
              ),
              Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
              ListTile(
                tileColor: Colors.white,
                minVerticalPadding: 20,
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RelaxationActivitiesTracking())),
                title: Text(
                  relaxingActivity[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(relaxingDescription[lang]),
                leading: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.access_alarm_sharp,size: 30.0,color: const Color(0xff9ad0e5),),
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top:10.0),
                  child: Icon(Icons.arrow_forward_ios_rounded,),
                ),
              ),
              Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
              ListTile(
                tileColor: Colors.white,
                minVerticalPadding: 20,
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>HabitBuildingTracking())),
                title: Text(
                  habitBuilding[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(habitDescription[lang]),
                leading: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.developer_board_outlined,size: 30.0,color: const Color(0xff9ad0e5),),
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top:10.0),
                  child: Icon(Icons.arrow_forward_ios_rounded,),
                ),
              ),
              Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
              ListTile(
                tileColor: Colors.white,
                minVerticalPadding: 20,
                onTap: (){

                },
                title: Text(
                  water[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(waterdescription[lang]),
                leading: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(FontAwesomeIcons.tint,size: 30.0,color: const Color(0xff9ad0e5),),
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top:10.0),
                  child: Icon(Icons.arrow_forward_ios_rounded,),
                ),
              ),
              Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
              ListTile(
                tileColor: Colors.white,
                minVerticalPadding: 20,
                onTap: (){

                },
                title: Text(
                  pedometer[lang],
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(pedometerdescription[lang]),
                leading: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(FontAwesomeIcons.shoePrints,size: 30.0,color: const Color(0xff9ad0e5),),
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top:10.0),
                  child: Icon(Icons.arrow_forward_ios_rounded,),
                ),
              ),
              Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
              SizedBox(height: 120,),
            ],
          ),
        ),
      ),
    );
  }
}