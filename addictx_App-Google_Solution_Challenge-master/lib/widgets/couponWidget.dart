import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/couponsModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponWidget extends StatefulWidget {
  final bool isBought;
  var xo;
  final CouponsModel couponsModel;
  CouponWidget({this.couponsModel,this.xo,this.isBought});
  @override
  _CouponWidgetState createState() => _CouponWidgetState(couponsModel: couponsModel,isBought: isBought);
}

class _CouponWidgetState extends State<CouponWidget> {
  final CouponsModel couponsModel;
  bool isBought;
  bool loading=false;
  bool canTap=true;

  _CouponWidgetState({this.couponsModel,this.isBought});

  String lang='English';
  Map unableToLaunchUrl={
    'English':"Something went wrong!! Please try again later",
    'Hindi':'कुछ गलत हो गया!! बाद में पुन: प्रयास करें',
    'Spanish':'¡¡Algo salió mal. Por favor, inténtelo de nuevo más tarde',
    'German':'Etwas ist schief gelaufen!! Bitte versuchen Sie es später noch einmal',
    'French':"Quelque chose s'est mal passé !! Veuillez réessayer plus tard",
    'Japanese':'何かがうまくいかなかった!!後でもう一度やり直してください',
    'Russian':'Что-то пошло не так!! Пожалуйста, повторите попытку позже',
    'Chinese':'出问题了！！请稍后再试',
    'Portuguese':'Algo deu errado !! Por favor, tente novamente mais tarde'
  };
  Map login={
    'English':'Login to buy coupons',
    'Hindi':'कूपन खरीदने के लिए लॉगिन करें',
    'Spanish':'Inicie sesión para comprar cupones',
    'German':'Einloggen um Gutscheine zu kaufen',
    'French':"Connectez-vous pour acheter des coupons",
    'Japanese':'ログインしてクーポンを購入する',
    'Russian':'Войдите, чтобы купить купоны',
    'Chinese':'登录购买优惠券',
    'Portuguese':'Faça login para comprar cupons'
  };
  Map insufficient={
    'English':"You don't have enough xo to buy this coupon",
    'Hindi':'इस कूपन को खरीदने के लिए आपके पास पर्याप्त xo नहीं है',
    'Spanish':'No tienes suficiente xo para comprar este cupón',
    'German':'Sie haben nicht genug xo, um diesen Gutschein zu kaufen',
    'French':"Vous n'avez pas assez de xo pour acheter ce coupon",
    'Japanese':'このクーポンを購入するのに十分なxoがありません',
    'Russian':'У вас недостаточно xo, чтобы купить этот купон',
    'Chinese':'您没有足够的 xo 购买此优惠券',
    'Portuguese':'Você não tem xo suficiente para comprar este cupom'
  };
  Map buy={
    'English':'Buy Now',
    'Hindi':'अभी खरीदें',
    'Spanish':'Compra ahora',
    'German':'Kaufe jetzt',
    'French':"Acheter maintenant",
    'Japanese':'今すぐ購入',
    'Russian':'купить сейчас',
    'Chinese':'立即购买',
    'Portuguese':'Compre Agora'
  };
  Map tc={
    'English':"T  &  C",
    'Hindi':'टी एंड सी',
    'Spanish':'T  &  C',
    'German':'T  &  C',
    'French':"CGV",
    'Japanese':'T＆C',
    'Russian':'T & C',
    'Chinese':'条款与条件',
    'Portuguese':'T & C'
  };

  openSite(String link)async{
    if (await canLaunch(link)) {
      await launch(
        link,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String,String>{'header_key':'header_value'},
      );
    } else {
      showToast(unableToLaunchUrl[lang]);
    }
  }

  buyCoupon()async
  {
    if(canTap)
      {
        if(currentUser!=null)
          {
            if(currentUser.score>=int.parse(couponsModel.value))
            {
              canTap=false;
              setState(() {
                loading=true;
              });
              if(couponsModel.oneTimeUse)
              {
                await couponsReference.doc(couponsModel.id).update({
                  'visibility':false,
                });
              }
              else
              {
                await couponsReference.doc(couponsModel.id).update({
                  'boughtBy':FieldValue.arrayUnion([currentUser.id]),
                });
              }
              currentUser.score-=int.parse(couponsModel.value);
              widget.xo.value-=int.parse(couponsModel.value);
              await myCouponsReference.doc(currentUser.id).set({
                'ids':FieldValue.arrayUnion([couponsModel.id]),
              },SetOptions(merge: true));
              await usersReference.doc(currentUser.id).update({
                'score': FieldValue.increment(-int.parse(couponsModel.value)),
              });
              setState(() {
                isBought=true;
                loading=false;
              });
            }
            else
              showToast(insufficient[lang]);
          }
        else
          showToast(login[lang]);
      }
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.width/2.3,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
              image: CachedNetworkImageProvider(couponsModel.url),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    couponsModel.heading,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.gugi(
                      textStyle: TextStyle(
                        letterSpacing: 3.0,
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    couponsModel.discount,
                    style: GoogleFonts.gugi(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  isBought?Container(
                    alignment: Alignment.centerRight,
                    child: DottedBorder(
                      dashPattern: [8, 4],
                      strokeWidth: 3.0,
                      color: Colors.white,
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              color: Colors.transparent,
                              onPressed: ()=>Clipboard.setData(ClipboardData(text: couponsModel.coupon)),
                              icon: Icon(Icons.copy_rounded,color: Colors.white,),
                            ),
                            Text(
                              couponsModel.coupon+' ',
                              style: GoogleFonts.gugi(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ):Container(),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: ()=>openSite(couponsModel.link),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(7.0),
                        child: Icon(FontAwesomeIcons.shareSquare,color: Colors.black,),
                      ),
                    ),
                    SizedBox(height: 4,),
                    Text(
                      tc[lang],
                      style: GoogleFonts.gugi(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        isBought?Container()
            : Positioned(
          right: 0,
          left: 0,
          bottom: 10,
          child: GestureDetector(
          onTap: ()=>buyCoupon(),
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
                color: Colors.black54,
              ),
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    buy[lang],
                    style: GoogleFonts.gugi(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '@ ${couponsModel.value} xo',
                    style: GoogleFonts.gugi(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ),
        ),
        loading?Center(child: CircularProgressIndicator(),):Container(),
      ],
    );
  }
}
