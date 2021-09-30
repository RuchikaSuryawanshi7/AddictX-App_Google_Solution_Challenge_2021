import 'package:addictx/helpers/authRelated.dart';
import 'package:addictx/home.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/models/userModel.dart';
import 'package:addictx/pages/signUp.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  final GoogleSignIn googleSignIn=GoogleSignIn();
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  SharedPreferences sharedPreferences;
  bool loading=false;
  bool isLoggedIn=false;
  final _formKey = GlobalKey<FormState>();
  String lang='English';
  Map loginFailed={
    'English':'Login failed!!',
    'Hindi':'लॉगिन विफल!!',
    'Spanish':'¡¡Error de inicio de sesion',
    'German':'Anmeldung fehlgeschlagen!!',
    'French':"Échec de la connexion!!",
    'Japanese':'ログインに失敗しました！！',
    'Russian':'Ошибка входа!!',
    'Chinese':'登录失败！！',
    'Portuguese':'Falha na autenticação!!',
  };
  Map invalidEmail={
    'English':"This email doesn't exist.",
    'Hindi':'यह ईमेल मौजूद नहीं है।',
    'Spanish':'Este correo electrónico no existe.',
    'German':'Diese E-Mail existiert nicht.',
    'French':"Cet e-mail n'existe pas.",
    'Japanese':'このメールは存在しません。',
    'Russian':'Этого адреса электронной почты не существует.',
    'Chinese':'此电子邮件不存在。',
    'Portuguese':'Este email não existe.',
  };
  Map incorrectPassword={
    'English':"Incorrect password!!",
    'Hindi':'गलत पासवर्ड!!',
    'Spanish':'¡¡Contraseña incorrecta!!',
    'German':'Falsches Passwort!!',
    'French':"Mot de passe incorrect!!",
    'Japanese':'パスワードが間違っています!!',
    'Russian':'Неверный пароль!!',
    'Chinese':'密码错误！！',
    'Portuguese':'Senha incorreta!!',
  };
  Map userNotFound={
    'English':"No user exist with this email",
    'Hindi':'इस ईमेल के साथ कोई उपयोगकर्ता मौजूद नहीं है',
    'Spanish':'Ninguna usuario existe con este correo electrónico',
    'German':'Es existiert kein Benutzer mit dieser E-Mail',
    'French':"Aucun utilisateur n'existe avec cette adresse e-mail",
    'Japanese':'このメールにはユーザーが存在しません',
    'Russian':'Нет пользователей с этим адресом электронной почты',
    'Chinese':'此电子邮件不存在任何用户',
    'Portuguese':'Nenhum usuário existe com este e-mail',
  };
  Map userDisabled={
    'English':"Your account has been disabled",
    'Hindi':'आपके खाते को निष्क्रिय कर दिया गया है',
    'Spanish':'Tu cuenta ha sido inhabilitada',
    'German':'Ihr Konto wurde deaktiviert',
    'French':"Votre compte a été désactivé",
    'Japanese':'アカウントが無効になっています',
    'Russian':'Ваш аккаунт был отключен',
    'Chinese':'您的帐户已禁用',
    'Portuguese':'Sua conta foi desativada',
  };
  Map operationNotAllowed={
    'English':"Please try again later. Requested several times",
    'Hindi':'बाद में पुन: प्रयास करें। कई बार अनुरोध किया',
    'Spanish':'Por favor, inténtelo de nuevo más tarde. Solicitado varias veces',
    'German':'Bitte versuchen Sie es später erneut. Mehrfach angefordert',
    'French':"Veuillez réessayer plus tard. demandé plusieurs fois",
    'Japanese':'後でもう一度やり直してください。数回リクエスト',
    'Russian':'Пожалуйста, повторите попытку позже. Запрошено несколько раз',
    'Chinese':'请稍后再试。多次请求',
    'Portuguese':'Por favor, tente novamente mais tarde. Solicitado várias vezes',
  };
  Map emailTaken={
    'English':"This email has already been taken",
    'Hindi':'यह ईमेल पहले ही लिया जा चुका है',
    'Spanish':'este correo electronico ya esta en uso',
    'German':'Diese E-Mail wurde bereits vergeben',
    'French':"Cet e-mail a déjà été pris",
    'Japanese':'このメールはすでに送信されています',
    'Russian':'Это электронное письмо уже занято',
    'Chinese':'此电子邮件已被占用',
    'Portuguese':'Este e-mail já foi levado',
  };
  Map connection={
    'English':"Check your network connection. And try again later",
    'Hindi':'अपने नेटवर्क कनेक्शन की जाँच करें। और बाद में पुनः प्रयास करें',
    'Spanish':'Verifique su conexión de red. E inténtalo de nuevo más tarde',
    'German':'Überprüfen Sie Ihre Netzwerkverbindung. Und versuche es später noch einmal',
    'French':"Vérifiez votre connexion réseau. Et réessayez plus tard",
    'Japanese':'ネットワーク接続を確認してください。そして後でもう一度やり直してください',
    'Russian':'Проверьте подключение к сети. И попробуйте позже',
    'Chinese':'检查您的网络连接。稍后再试',
    'Portuguese':'Verifique sua conexão de rede. E tente novamente mais tarde',
  };
  Map incorrectEmailToast={
    'English':"Please enter your correct email to send password reset email.",
    'Hindi':'पासवर्ड रीसेट ईमेल भेजने के लिए कृपया अपना सही ईमेल दर्ज करें।',
    'Spanish':'Ingrese su correo electrónico correcto para enviar un correo electrónico de restablecimiento de contraseña.',
    'German':'Bitte geben Sie Ihre korrekte E-Mail-Adresse ein, um eine E-Mail zum Zurücksetzen des Passworts zu senden.',
    'French':"Veuillez entrer votre e-mail correct pour envoyer un e-mail de réinitialisation de mot de passe.",
    'Japanese':'パスワードリセットメールを送信するには、正しいメールアドレスを入力してください。',
    'Russian':'Пожалуйста, введите ваш правильный адрес электронной почты, чтобы отправить письмо для сброса пароля.',
    'Chinese':'请输入您的正确电子邮件以发送密码重置电子邮件。',
    'Portuguese':'Por favor, digite seu e-mail correto para enviar o e-mail de redefinição de senha.',
  };
  Map resetToast={
    'English':"Password reset email sent to",
    'Hindi':'पासवर्ड रीसेट ईमेल भेजा गया',
    'Spanish':'Correo electrónico de restablecimiento de contraseña enviado a',
    'German':'E-Mail zum Zurücksetzen des Passworts gesendet an',
    'French':"E-mail de réinitialisation du mot de passe envoyé à",
    'Japanese':'に送信されたパスワードリセットメール',
    'Russian':'Письмо для сброса пароля отправлено на адрес',
    'Chinese':'密码重置邮件发送至',
    'Portuguese':'Email de redefinição de senha enviado para',
  };
  Map email={
    'English':"Email Id",
    'Hindi':'ईमेल आईडी',
    'Spanish':'Identificación de correo',
    'German':'E-Mail-ID',
    'French':"Identifiant de l'e-mail",
    'Japanese':'電子メールID',
    'Russian':'Электронный идентификатор',
    'Chinese':'电子邮件ID',
    'Portuguese':'Identificação do email',
  };
  Map emailValidation={
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
  Map password={
    'English':'Password',
    'Hindi':'पासवर्ड',
    'Spanish':'Contraseña',
    'German':'Passwort',
    'French':"Mot de passe",
    'Japanese':'パスワード',
    'Russian':'Пароль',
    'Chinese':'密码',
    'Portuguese':'Senha',
  };
  Map passwordValidation={
    'English':"Enter 6 characters password",
    'Hindi':'6 अक्षर का पासवर्ड डालें',
    'Spanish':'Ingrese la contraseña de 6 caracteres',
    'German':'Geben Sie ein 6-stelliges Passwort ein',
    'French':"Entrez un mot de passe de 6 caractères",
    'Japanese':'6文字のパスワードを入力してください',
    'Russian':'Введите пароль из 6 символов',
    'Chinese':'输入 6 个字符的密码',
    'Portuguese':'Digite a senha de 6 caracteres',
  };
  Map forgot={
    'English':"Forgot Password?",
    'Hindi':'पासवर्ड भूल गए?',
    'Spanish':'¿Contraseña?',
    'German':'Passwort vergessen?',
    'French':"Mot de passe oublié?",
    'Japanese':'パスワードをお忘れですか？',
    'Russian':'Забыл пароль?',
    'Chinese':'忘记密码？',
    'Portuguese':'Esqueceu a senha?',
  };
  Map sign={
    'English':"Sign In",
    'Hindi':'साइन इन',
    'Spanish':'Iniciar sesión',
    'German':'Einloggen',
    'French':"S'identifier",
    'Japanese':'サインイン',
    'Russian':'Войти',
    'Chinese':'登入',
    'Portuguese':'Entrar',
  };
  Map or={
    'English':"OR",
    'Hindi':'या',
    'Spanish':'O',
    'German':'ODER',
    'French':"OU ALORS",
    'Japanese':'または',
    'Russian':'ИЛИ ЖЕ',
    'Chinese':'或者',
    'Portuguese':'OU',
  };
  Map noAccount={
    'English':"Don't have an account?",
    'Hindi':'अकांउट नहीं है?',
    'Spanish':'¿No tienes una cuenta?',
    'German':'Sie haben kein Konto?',
    'French':"Vous n'avez pas de compte ?",
    'Japanese':'アカウントをお持ちではありませんか？',
    'Russian':'Нет учетной записи?',
    'Chinese':'没有账户？',
    'Portuguese':'Não tem conta?',
  };
  Map register={
    'English':'Register Now',
    'Hindi':'अभी पंजीकरण करें',
    'Spanish':'Regístrate ahora',
    'German':'Jetzt registrieren',
    'French':"S'inscrire maintenant",
    'Japanese':'今すぐ登録',
    'Russian':'Зарегистрироваться',
    'Chinese':'现在注册',
    'Portuguese':'Registrar agora',
  };


  @override
  void dispose()
  {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  Future handleSignIn()async
  {
    setState(() {
      loading=true;
    });
    GoogleSignInAccount googleUser=await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication=await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    UserCredential userCredential=await firebaseAuth.signInWithCredential(credential);
    final User user=userCredential.user;
    if(user!=null)
      {
        final QuerySnapshot snapshot=await usersReference.where('id',isEqualTo: user.uid).get();
        List<DocumentSnapshot> document=snapshot.docs;
        if(document.length==0)
          {
            usersReference.doc(user.uid).set({
              "id":user.uid,
              "username":user.displayName,
              "url":user.photoURL,
              "email": user.email,
              'isExpert':false,
              'score':0,
              'likes':0,
              'yearsOfExperience':0,
              "description":"",
            });
            configureRealTimePushNotification(user.uid);
            DocumentSnapshot documentSnapshot=await usersReference.doc(user.uid).get();
            currentUser=UserModel.fromDocument(documentSnapshot);
          }
        else
          {
            currentUser=UserModel.fromDocument(document[0]);
          }
        setState(() {
          loading=false;
        });
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
      }
    else{
      showToast(loginFailed[lang]);
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user.uid;
    } catch (e) {
      print(e);
      print(e.code);
      switch (e.code) {
        case "invalid-email":
          showToast(invalidEmail[lang]);
          break;
        case "wrong-password":
          showToast(incorrectPassword[lang]);
          break;
        case "user-not-found":
          showToast(userNotFound[lang]);
          break;
        case "user-disabled":
          showToast(userDisabled[lang]);
          break;
        case "operation-not-allowed":
          showToast(operationNotAllowed[lang]);
          break;
        case "email-already-in-use":
          showToast(emailTaken[lang]);
          break;
        default:
          showToast(connection[lang]);
      }
      return null;
    }
  }

  signIn()async
  {
    if(_formKey.currentState.validate())
      {
        setState(() {
          loading=true;
        });
        await signInWithEmailAndPassword(
            emailEditingController.text, passwordEditingController.text).then((id)async{
          if(id!=null)
          {
            QuerySnapshot snapshot=await usersReference.where('id',isEqualTo: id).get();
            currentUser=UserModel.fromDocument(snapshot.docs[0]);
            sharedPreferences=await SharedPreferences.getInstance();
            await sharedPreferences.setString('email', emailEditingController.text);
            await sharedPreferences.setString('password', passwordEditingController.text);
            await sharedPreferences.setBool('loggedIn', true);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
          }
        });
        setState(() {
          loading=false;
        });
      }
  }

  forgotPassword()
  {
    if(emailEditingController.text!=null&&RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailEditingController.text))
    {
      firebaseAuth.sendPasswordResetEmail(email: emailEditingController.text);
      showToast(resetToast[lang]+" ${emailEditingController.text}.");
    }
    else
      showToast(incorrectEmailToast[lang]);
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Container(
      height: MediaQuery.of(context).size.height*0.5,
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height*0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      indent: MediaQuery.of(context).size.width/3,
                      endIndent: MediaQuery.of(context).size.width/3,
                      thickness: 7.0,
                      color: Colors.blue[100],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x299ad0e5),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 15),
                      padding: EdgeInsets.all(15),
                      height: MediaQuery.of(context).size.height/3.5,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: email[lang],
                              labelStyle: GoogleFonts.gugi(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                                  ? null
                                  : emailValidation[lang];
                            },
                            controller: emailEditingController,
                          ),
                          SizedBox(height: 15,),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: password[lang],
                              labelStyle: GoogleFonts.gugi(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : passwordValidation[lang];
                            },
                            controller: passwordEditingController,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>forgotPassword(),
                      child: Text(
                        '  '+forgot[lang],
                        style:GoogleFonts.gugi(
                          textStyle: TextStyle(
                            color: Colors.blue[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: FlatButton(
                        color: const Color(0x299ad0e5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        padding: EdgeInsets.fromLTRB(30, 7, 30, 7),
                        child: Text(sign[lang],style: GoogleFonts.gugi(
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),),
                        onPressed: (){
                          signIn();
                        },
                      ),
                    ),
                    SizedBox(height: 8,),
                    Center(
                      child: Text.rich(
                          TextSpan(
                              text: noAccount[lang]+" ",
                              style: GoogleFonts.gugi(
                                textStyle: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                              children: [
                                TextSpan(
                                    text: register[lang],
                                    style: TextStyle(color: Colors.blue[300],),
                                    recognizer:TapGestureRecognizer()..onTap=(){
                                      Navigator.pop(context);
                                      bottomSheetForSignUp(context);
                                    },
                                ),
                              ],
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height/3.5,
            right: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(or[lang]+" ",style: GoogleFonts.gugi(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),),
                GestureDetector(
                  onTap: ()=>handleSignIn(),
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    elevation: 5.0,
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0x299ad0e5),
                      ),
                      child: Image.asset('assets/google.png',height: 35,width: 35,),
                    ),
                  ),
                ),
              ],
            ),
          ),
          loading?Center(child: CircularProgressIndicator(),):Container(),
        ],
      ),
    );
  }
}

bottomSheetForSignIn(BuildContext context)
{
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      context: context,
      builder: (context){
        return SignIn();
      }
  );
}