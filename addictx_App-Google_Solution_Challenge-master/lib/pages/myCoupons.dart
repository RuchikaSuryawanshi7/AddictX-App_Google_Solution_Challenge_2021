import 'package:addictx/SplashScreen.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/couponsModel.dart';
import 'package:addictx/widgets/couponWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyCoupons extends StatefulWidget {
  @override
  _MyCouponsState createState() => _MyCouponsState();
}

class _MyCouponsState extends State<MyCoupons> {
  bool loading=true;
  List<CouponsModel> couponModels=[];
  Map myCoupons={
    'English':"My Coupons",
    'Hindi':'मेरे कूपन',
    'Spanish':'Mis cupones',
    'German':'Meine Gutscheine',
    'French':"Mes bons de réduction",
    'Japanese':'私のクーポン',
    'Russian':'Мои купоны',
    'Chinese':'我的优惠券',
    'Portuguese':'Meus cupons',
  };
  Map noCoupons={
    'English':"You don't have any coupons..",
    'Hindi':'आपके पास कोई कूपन नहीं है..',
    'Spanish':'No tienes cupones ...',
    'German':'Sie haben keine Gutscheine..',
    'French':"Vous n'avez pas de coupons..",
    'Japanese':'クーポンはありません。',
    'Russian':'У вас нет купонов ..',
    'Chinese':'你没有优惠券..',
    'Portuguese':'Você não tem cupons ..',
  };

  @override
  void initState() {
    getCoupons();
    super.initState();
  }

  getCoupons()async{
    DocumentSnapshot snapshot=await myCouponsReference.doc(currentUser.id).get();
    if(snapshot.exists)
      {
        List<String> couponIds=List.from(snapshot.data()['ids']);
        for(var id in couponIds)
        {
          DocumentSnapshot documentSnapshot=await couponsReference.doc(id).get();
          couponModels.add(CouponsModel.fromDocument(documentSnapshot));
        }
      }
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Center(
            child: Text(
              myCoupons[lang]+' ',
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
      body: loading?Center(child: CircularProgressIndicator(),):couponModels.isNotEmpty?ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: couponModels.length,
        itemBuilder: (context,index){
          return CouponWidget(couponsModel: couponModels[index],isBought: true,);
        },
      ):Center(
        child: Text(
          noCoupons[lang],
          style: GoogleFonts.gugi(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
