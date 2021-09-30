import 'dart:io';
import 'package:addictx/languageNotifier.dart';
import 'package:image/image.dart' as ImD;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:addictx/helpers/dialogs.dart';

class BecomeAnExpert extends StatefulWidget {
  @override
  _BecomeAnExpertState createState() => _BecomeAnExpertState();
}

class _BecomeAnExpertState extends State<BecomeAnExpert> {
  TextEditingController profileNameEditingController=TextEditingController();
  TextEditingController emailEditingController=TextEditingController();
  TextEditingController infoEditingController=TextEditingController();
  bool loading=true;
  final picker=ImagePicker();
  File _image;
  var cropper;
  bool inProcess=false;
  String postId=Uuid().v4();
  final _keys = GlobalKey<FormState>();
  String selected;
  String lang='English';
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
  Map uploadImageFromCameraText={
    'English':"Upload image from camera",
    'Hindi':'कैमरे से छवि अपलोड करें',
    'Spanish':'Subir imagen de la cámara',
    'German':'Bild von der Kamera hochladen',
    'French':"Télécharger l'image de la caméra",
    'Japanese':'カメラから画像をアップロードする',
    'Russian':'Загрузить изображение с камеры',
    'Chinese':'从相机上传图像',
    'Portuguese':'Carregar imagem da câmera',
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
  Map toastMessage={
    'English':"Attach photo to continue",
    'Hindi':'जारी रखने के लिए फ़ोटो डालें',
    'Spanish':'Adjuntar foto para continuar',
    'German':'Foto anhängen, um fortzufahren',
    'French':"Joindre une photo pour continuer",
    'Japanese':'続行するには写真を添付し​​てください',
    'Russian':'Чтобы продолжить, прикрепите фото',
    'Chinese':'附上照片以继续',
    'Portuguese':'Anexe a foto para continuar',
  };
  Map dialogTitle={
    'English':"Request sent",
    'Hindi':'निमंत्रण भेजा गया',
    'Spanish':'Solicitud enviada',
    'German':'Anfrage gesendet',
    'French':"Demande envoyée",
    'Japanese':'リクエストが送信されました',
    'Russian':'Запрос отправлен',
    'Chinese':'请求已发送',
    'Portuguese':'Pedido enviado',
  };
  Map dialogContent={
    'English':"Your verification request is sent. We will notify you by sending mail on your email",
    'Hindi':'आपका सत्यापन अनुरोध भेजा गया है। हम आपके ईमेल पर मेल भेजकर आपको सूचित करेंगे',
    'Spanish':'Se envía su solicitud de verificación. Le notificaremos enviando un correo en su correo electrónico',
    'German':'Ihre Verifizierungsanfrage wird gesendet. Wir werden Sie benachrichtigen, indem wir Ihnen eine E-Mail an Ihre E-Mail senden',
    'French':"Votre demande de vérification est envoyée. Nous vous informerons en envoyant un courrier sur votre e-mail",
    'Japanese':'確認リクエストが送信されます。メールでお知らせします',
    'Russian':'Ваш запрос на подтверждение отправлен. Мы уведомим вас, отправив письмо на вашу электронную почту',
    'Chinese':'您的验证请求已发送。我们将通过在您的电子邮件中发送邮件来通知您',
    'Portuguese':'Sua solicitação de verificação foi enviada. Iremos notificá-lo enviando um e-mail em seu e-mail',
  };
  Map title={
    'English':"Become An Expert",
    'Hindi':'एक विशेषज्ञ बनें',
    'Spanish':'Conviértete en un experto',
    'German':'Werden Sie ein Experte',
    'French':"Devenez un expert",
    'Japanese':'エキスパートになる',
    'Russian':'Стать экспертом',
    'Chinese':'成为专家',
    'Portuguese':'Torne-se um especialista',
  };
  Map applyHeading={
    'English':"Apply for AddictX Expert Verification",
    'Hindi':'एडिक्टएक्स विशेषज्ञ सत्यापन के लिए आवेदन करे',
    'Spanish':'Solicite la verificación de experto de AddictX',
    'German':'Beantragen Sie die AddictX-Expertenverifizierung',
    'French':"Demander la vérification expert AddictX",
    'Japanese':'AddictXエキスパート検証を申請する',
    'Russian':'Подать заявку на проверку эксперта AddictX',
    'Chinese':'申请 AddictX 专家验证',
    'Portuguese':'Inscreva-se para a verificação de especialista AddictX',
  };
  Map description={
    'English':"Expert verification on AddictX App shows you are an expert in Mental Health and Addiction Recovery. Your responsibilities are to solve addiction problems and mental health problems for users.",
    'Hindi':'एडिक्टएक्स ऐप पर विशेषज्ञ सत्यापन से पता चलता है कि आप मानसिक स्वास्थ्य और व्यसन वसूली के विशेषज्ञ हैं। आपकी ज़िम्मेदारी उपयोगकर्ताओं के लिए व्यसन समस्याओं और मानसिक स्वास्थ्य समस्याओं को हल करना है।',
    'Spanish':'La verificación de expertos en la aplicación AddictX muestra que es un experto en salud mental y recuperación de adicciones. Sus responsabilidades son resolver los problemas de adicción y los problemas de salud mental de los usuarios.',
    'German':'Die Expertenverifizierung in der AddictX App zeigt, dass Sie ein Experte für psychische Gesundheit und Genesung von Sucht sind. Ihre Verantwortung besteht darin, Suchtprobleme und psychische Probleme für die Benutzer zu lösen.',
    'French':"La vérification par un expert sur l'application AddictX montre que vous êtes un expert en santé mentale et en récupération des dépendances. Vos responsabilités sont de résoudre les problèmes de toxicomanie et les problèmes de santé mentale des usagers.",
    'Japanese':'AddictXアプリの専門家による検証は、あなたがメンタルヘルスと依存症の回復の専門家であることを示しています。あなたの責任は、ユーザーの依存症の問題とメンタルヘルスの問題を解決することです。',
    'Russian':'Экспертная проверка в приложении AddictX показывает, что вы являетесь экспертом в области психического здоровья и избавления от зависимости. В ваши обязанности входит решение проблем с зависимостью и психическим здоровьем пользователей.',
    'Chinese':'AddictX App 上的专家验证表明您是心理健康和成瘾恢复方面的专家。您的职责是为用户解决成瘾问题和心理健康问题。',
    'Portuguese':'A verificação de especialista no aplicativo AddictX mostra que você é um especialista em saúde mental e recuperação de vícios. Suas responsabilidades são resolver problemas de dependência e problemas de saúde mental para os usuários.',
  };
  Map chooseFile={
    'English':"Choose File",
    'Hindi':'फ़ाइल चुनें',
    'Spanish':'Elija el archivo',
    'German':'Datei wählen',
    'French':"Choisir le fichier",
    'Japanese':'ファイルを選ぶ',
    'Russian':'Выбрать файл',
    'Chinese':'选择文件',
    'Portuguese':'Escolher arquivo',
  };
  Map attachPhoto={
    'English':"Please attach a photo of your ID",
    'Hindi':'कृपया अपनी आईडी की एक फोटो संलग्न करें',
    'Spanish':'Adjunte una foto de su identificación',
    'German':'Bitte fügen Sie ein Foto Ihres Ausweises bei',
    'French':"Veuillez joindre une photo de votre pièce d'identité",
    'Japanese':'身分証明書の写真を添付してください',
    'Russian':'Прикрепите фото вашего удостоверения личности',
    'Chinese':'请附上您的身份证照片',
    'Portuguese':'Por favor, anexe uma foto da sua identidade',
  };
  Map id={
    'English':"Please affix a photo of your government issued ID ,that should contain your name and date of birth(D.O.B). (Eg-national Id card or passport or driving licence) or any official Business documents(utility bill,tax filing) in order to review your application.",
    'Hindi':'कृपया अपनी सरकार द्वारा जारी आईडी का एक फोटो चिपकाएं, जिसमें आपका नाम और जन्म तिथि (डी.ओ.बी) होनी चाहिए। (जैसे-राष्ट्रीय आईडी कार्ड या पासपोर्ट या ड्राइविंग लाइसेंस) या आपके आवेदन की समीक्षा करने के लिए कोई आधिकारिक व्यावसायिक दस्तावेज (उपयोगिता बिल, टैक्स फाइलिंग)।',
    'Spanish':'Coloque una foto de su identificación emitida por el gobierno, que debe contener su nombre y fecha de nacimiento (D.O.B). (Por ejemplo, tarjeta de identificación nacional o pasaporte o licencia de conducir) o cualquier documento comercial oficial (factura de servicios públicos, declaración de impuestos) para revisar su solicitud.',
    'German':'Bitte fügen Sie ein Foto Ihres amtlichen Ausweises bei, das Ihren Namen und Ihr Geburtsdatum (D.O.B.) enthalten sollte. (zB Personalausweis oder Reisepass oder Führerschein) oder alle offiziellen Geschäftsdokumente (Stromrechnung, Steuererklärung), um Ihren Antrag zu überprüfen.',
    'French':"Veuillez apposer une photo de votre pièce d'identité émise par le gouvernement, qui doit contenir votre nom et votre date de naissance (D.O.B). (par exemple, carte d'identité nationale ou passeport ou permis de conduire) ou tout document commercial officiel (facture de services publics, déclaration de revenus) afin d'examiner votre demande.",
    'Japanese':'お名前と生年月日（D.O.B）が記載された政府発行の身分証明書の写真を添付してください。 （例-国民IDカード、パスポート、運転免許証）、または申請書を確認するための公式のビジネス文書（公共料金の請求書、税務申告）。',
    'Russian':'Прикрепите фотографию своего удостоверения личности государственного образца, на котором должны быть указаны ваше имя и дата рождения (D.O.B). (Например, национальная идентификационная карта, паспорт или водительские права) или любые официальные деловые документы (счет за коммунальные услуги, налоговая декларация) для рассмотрения вашего заявления.',
    'Chinese':'请贴上政府签发的身份证照片，其中应包含您的姓名和出生日期（D.O.B）。 （例如国民身份证或护照或驾驶执照）或任何官方商业文件（水电费账单、报税）以审查您的申请。',
    'Portuguese':'Afixe uma foto do seu documento de identidade emitido pelo governo, que deve conter seu nome e data de nascimento (D.O.B). (Ex: carteira de identidade nacional, passaporte ou carteira de habilitação) ou quaisquer documentos oficiais da empresa (contas de serviços públicos, declaração de impostos) para analisar seu requerimento.',
  };
  Map profileName={
    'English':'Profile Name',
    'Hindi':'प्रोफ़ाइल नाम',
    'Spanish':'Nombre de perfil',
    'German':'Profilname',
    'French':"Nom de profil",
    'Japanese':'プロファイル名',
    'Russian':'Имя профиля',
    'Chinese':'个人资料名称',
    'Portuguese':'Nome do perfil',
  };
  Map incorrectProfileName={
    'English':"Incorrect profile name. Enter your own profile name.",
    'Hindi':'गलत प्रोफ़ाइल नाम। अपना खुद का प्रोफाइल नाम दर्ज करें।',
    'Spanish':'Nombre de perfil incorrecto. Ingrese su propio nombre de perfil.',
    'German':'Falscher Profilname. Geben Sie Ihren eigenen Profilnamen ein.',
    'French':"Nom de profil incorrect. Entrez votre propre nom de profil.",
    'Japanese':'プロファイル名が正しくありません。独自のプロファイル名を入力します。',
    'Russian':'Неверное имя профиля. Введите свое собственное имя профиля.',
    'Chinese':'个人资料名称不正确。输入您自己的个人资料名称。',
    'Portuguese':'Nome de perfil incorreto. Digite seu próprio nome de perfil.',
  };
  Map email={
    'English':'Email',
    'Hindi':'ईमेल',
    'Spanish':'Correo electrónico',
    'German':'Email',
    'French':"E-mail",
    'Japanese':'Eメール',
    'Russian':'Электронное письмо',
    'Chinese':'电子邮件',
    'Portuguese':'E-mail',
  };
  Map incorrectEmail={
    'English':"Please Enter Correct Email",
    'Hindi':'कृपया सही ईमेल दर्ज करें',
    'Spanish':'Ingrese el correo electrónico correcto',
    'German':'Bitte geben Sie die richtige E-Mail ein',
    'French':"Veuillez saisir un e-mail correct",
    'Japanese':'正しいメールアドレスを入力してください',
    'Russian':'Пожалуйста, введите правильный адрес электронной почты',
    'Chinese':'请输入正确的电子邮件',
    'Portuguese':'Digite o e-mail correto',
  };
  Map info={
    'English':'Tell us something to help us identify you',
    'Hindi':'आपको पहचानने में हमारी मदद करने के लिए हमें कुछ बताएं',
    'Spanish':'Cuéntanos algo que nos ayude a identificarte',
    'German':'Sag uns etwas, damit wir dich identifizieren können',
    'French':"Dites-nous quelque chose pour nous aider à vous identifier",
    'Japanese':'私たちがあなたを特定するのに役立つ何かを教えてください',
    'Russian':'Расскажите нам что-нибудь, что поможет нам идентифицировать вас',
    'Chinese':'告诉我们一些信息以帮助我们识别您的身份',
    'Portuguese':'Diga-nos algo para nos ajudar a identificá-lo',
  };
  Map note={
    'English':"Note - AddictX doesn't guarantee that your account will be verified after submitting a request for verification. And, you will be responsible if you upload false documents/ information or try to be verified on a fake account or any other allegations arising due to this request.",
    'Hindi':'नोट - AddictX इस बात की गारंटी नहीं देता कि सत्यापन के लिए अनुरोध सबमिट करने के बाद आपका खाता सत्यापित हो जाएगा। और, यदि आप झूठे दस्तावेज़/सूचना अपलोड करते हैं या किसी नकली खाते या इस अनुरोध के कारण उत्पन्न होने वाले किसी अन्य आरोप पर सत्यापित होने का प्रयास करते हैं तो आप जिम्मेदार होंगे।',
    'Spanish':'Nota: AddictX no garantiza que su cuenta sea verificada después de enviar una solicitud de verificación. Y usted será responsable si carga documentos / información falsa o intenta ser verificado en una cuenta falsa o cualquier otra acusación que surja debido a esta solicitud.',
    'German':'Hinweis - AddictX garantiert nicht, dass Ihr Konto verifiziert wird, nachdem Sie eine Verifizierungsanfrage gestellt haben. Und Sie sind verantwortlich, wenn Sie falsche Dokumente/Informationen hochladen oder versuchen, sich auf einem gefälschten Konto zu verifizieren oder andere Anschuldigungen, die sich aus dieser Anfrage ergeben.',
    'French':"Remarque - AddictX ne garantit pas que votre compte sera vérifié après avoir soumis une demande de vérification. Et, vous serez responsable si vous téléchargez de faux documents/informations ou essayez d'être vérifié sur un faux compte ou toute autre allégation résultant de cette demande.",
    'Japanese':'注-AddictXは、確認のリクエストを送信した後にアカウントが確認されることを保証しません。また、虚偽の文書/情報をアップロードしたり、偽のアカウントで確認しようとしたり、このリクエストが原因で発生したその他の申し立てがあった場合は、お客様が責任を負います。',
    'Russian':'Примечание. AddictX не гарантирует, что ваша учетная запись будет проверена после отправки запроса на проверку. И вы будете нести ответственность, если вы загрузите ложные документы / информацию или попытаетесь пройти проверку на поддельную учетную запись или любые другие обвинения, возникающие в связи с этим запросом.',
    'Chinese':'注意 - AddictX 不保证您的帐户在提交验证请求后会得到验证。并且，如果您上传虚假文件/信息或试图通过虚假帐户进行验证或因此请求引起的任何其他指控，您将承担责任。',
    'Portuguese':'Nota - AddictX não garante que sua conta será verificada após o envio de um pedido de verificação. E você será responsável se carregar documentos / informações falsos ou tentar ser verificado em uma conta falsa ou quaisquer outras alegações decorrentes desta solicitação.',
  };
  Map sendText={
    'English':"SEND",
    'Hindi':'भेजे',
    'Spanish':'ENVIAR',
    'German':'SENDEN',
    'French':"ENVOYER",
    'Japanese':'送信',
    'Russian':'ОТПРАВИТЬ',
    'Chinese':'发送',
    'Portuguese':'ENVIAR',
  };

  @override
  void initState() {
    showDetails();
    super.initState();
  }

  @override
  void dispose()
  {
    profileNameEditingController.dispose();
    emailEditingController.dispose();
    infoEditingController.dispose();
    super.dispose();
  }

  showDetails()
  {
    setState(() {
      profileNameEditingController.text=currentUser.username;
      emailEditingController.text=currentUser.email;
      loading=false;
    });
  }

  verificationRequestSent(String category,String url)
  {
    expertRequestReference.doc(currentUser.id).set({
      "email": emailEditingController.text,
      "id": currentUser.id,
      "profileName":profileNameEditingController.text,
      "info":infoEditingController.text,
      "docUrl":url,
      "timeStamp":DateTime.now(),
    });
  }
  void crop(var pathOrImage) async
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
        _image=File(cropper.path);
        setState(() {
          inProcess=false;
        });
      }
      else
      {
        setState(() {
          _image=File(pathOrImage.path);
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
    Reference ref = verificationStorageReference.child(currentUser.id).child("post_$postId.jpg");
    await ref.putFile(image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
  selectImageFromGallery(BuildContext context) async
  {
    Navigator.pop(context);
    setState(() {
      inProcess=true;
    });
    final imageFile= await picker.getImage(source: ImageSource.gallery);
    crop(imageFile);
  }
  selectImageFromCamera(BuildContext context) async
  {
    Navigator.pop(context);
    setState(() {
      inProcess=true;
    });
    final imageFile= await picker.getImage(source: ImageSource.camera);
    crop(imageFile);
  }

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
                child: Text(uploadImageFromCameraText[lang],style: TextStyle(fontSize: 17),),
                onPressed: (){selectImageFromCamera(context);},
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
  send()async
  {
    if(_keys.currentState.validate())
    {
      if(_image!=null)
      {
        setState(() {
          inProcess=true;
        });
        await compressPhoto();
        String downloadUrl=await uploadFile(_image);
        verificationRequestSent("abc", downloadUrl);
        setState(() {
          inProcess=false;
          _image=null;
        });
        profileNameEditingController.clear();
        emailEditingController.clear();
        infoEditingController.clear();
        dialog(context, dialogTitle[lang], dialogContent[lang]);
      }
      else
        showToast(toastMessage[lang]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white24,
      ),
      body: SafeArea(
        child: loading||inProcess?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
          child: Form(
            key: _keys,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10,),
                Text(title[lang],style: TextStyle(color: Colors.cyan,fontSize: 25,fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Divider(thickness: 1.4,),
                      SizedBox(height: 14,),
                      Column(
                        children: <Widget>[
                          Text(applyHeading[lang],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          SizedBox(height: 20,),
                          Text(description[lang], style: TextStyle(fontSize: 20,color: Colors.black54,fontWeight: FontWeight.bold),),
                          SizedBox(height: 40,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(attachPhoto[lang],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                              Spacer(),
                              GestureDetector(onTap: (){pickImage(context);},child: _image==null?Text(chooseFile[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.cyan[300],fontSize: 15),)
                                  : CircleAvatar(radius: 40,backgroundImage: FileImage(File(_image.path)))),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Text(id[lang],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 20),),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: profileNameEditingController,
                            decoration: InputDecoration(labelText: profileName[lang]),
                            validator: (val) {
                              return val==currentUser.username
                                  ? null
                                  : incorrectProfileName[lang];
                            },
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: emailEditingController,
                            decoration: InputDecoration(labelText: email[lang]),
                            validator: (val) {
                              return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                                  ? null
                                  : incorrectEmail[lang];
                            },
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: infoEditingController,
                            keyboardType: TextInputType.multiline,
                            maxLines:  10,
                            minLines: 1,
                            decoration: InputDecoration(labelText: info[lang]),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text(note[lang],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black54),),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){send();},
                        child: Container(
                          padding: EdgeInsets.fromLTRB(155, 20, 155, 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey[700],
                                  Colors.grey[700],
                                ],
                              )),
                          child:Text(sendText[lang],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                        ),
                      ),
                      SizedBox(height: 70,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}