import 'package:addictx/SplashScreen.dart';
import 'package:addictx/helpers/dialogs.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/models/couponsModel.dart';
import 'package:addictx/pages/badgesPopUp.dart';
import 'package:addictx/pages/myCoupons.dart';
import 'package:addictx/widgets/couponWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class Rewards extends StatefulWidget {
  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  bool loading=true;
  bool load=false;
  List<CouponsModel> couponModels=[];
  QuerySnapshot snapshotForRewards;
  ScrollController scrollController;
  var lastDoc;
  ValueNotifier<int> xo = ValueNotifier(currentUser!=null?currentUser.score:0);
  List<String> badges=[];
  String lang='English';
  Map toastMessage={
    'English':'No more coupons found',
    'Hindi':'कोई और कूपन नहीं मिला',
    'Spanish':'No se encontraron más cupones',
    'German':'Keine Gutscheine mehr gefunden',
    'French':'Plus de coupons trouvés',
    'Japanese':'クーポンが見つかりません',
    'Russian':'Купонов больше не найдено',
    'Chinese':'找不到更多优惠券',
    'Portuguese':'Não foram encontrados mais cupons',
  };
  Map title={
    'English':'Rewards',
    'Hindi':'Recompensas',
    'Spanish':'Recompensas',
    'German':'Belohnung',
    'French':'Récompenses',
    'Japanese':'報酬',
    'Russian':'Награды',
    'Chinese':'奖励',
    'Portuguese':'Recompensas',
  };
  Map badgesText={
    'English':"Badges",
    'Hindi':'बैज',
    'Spanish':'Insignias',
    'German':'Abzeichen',
    'French':'Insignes',
    'Japanese':'バッジ',
    'Russian':'Значки',
    'Chinese':'徽章',
    'Portuguese':'Distintivos',
  };
  Map firstCondition={
    'English':'for completing your addiction plan',
    'Hindi':'अपनी लत योजना को पूरा करने के लिए',
    'Spanish':'por completar su plan de adicción',
    'German':'für den Abschluss Ihres Suchtplans',
    'French':'pour compléter votre plan toxicomanie',
    'Japanese':'あなたの中毒計画を完了するために',
    'Russian':'для завершения вашего плана зависимости',
    'Chinese':'完成你的成瘾计划',
    'Portuguese':'por completar seu plano de adicção',
  };
  Map secondCondition={
    'English':"for completing 30 days of your habit building",
    'Hindi':'अपने आदत निर्माण के 30 दिन पूरे करने के लिए',
    'Spanish':'por completar 30 días de desarrollo de hábitos',
    'German':'für den Abschluss von 30 Tagen deiner Gewohnheit',
    'French':"pour avoir terminé 30 jours de construction d'habitudes",
    'Japanese':'あなたの習慣構築の30日を完了するために',
    'Russian':'за 30 дней выработки привычки',
    'Chinese':'完成 30 天的习惯养成',
    'Portuguese':'por completar 30 dias de construção de hábitos',
  };
  Map doing={
    'English':"for doing",
    'Hindi':'करने के लिए ले',
    'Spanish':'por hacerlo, para hacerlo',
    'German':'fürs machen',
    'French':"pour faire",
    'Japanese':'するために',
    'Russian':'для того, чтобы делать',
    'Chinese':'为了做',
    'Portuguese':'por fazer',
  };
  Map more={
    'English':"for more than 30 times",
    'Hindi':'30 से अधिक बार',
    'Spanish':'por más de 30 veces',
    'German':'mehr als 30 mal',
    'French':"plus de 30 fois",
    'Japanese':'30回以上',
    'Russian':'более 30 раз',
    'Chinese':'超过30次',
    'Portuguese':'por mais de 30 vezes',
  };
  Map noBadges={
    'English':"No Badges earned",
    'Hindi':'कोई बैज अर्जित नहीं किया',
    'Spanish':'No se ganaron insignias',
    'German':'Keine Abzeichen verdient',
    'French':"Aucun badge gagné",
    'Japanese':'バッジは獲得できません',
    'Russian':'Значки не заработаны',
    'Chinese':'没有获得徽章',
    'Portuguese':'Nenhum selo conquistado',
  };
  Map couponText={
    'English':"Coupon Code",
    'Hindi':'कूपन कोड',
    'Spanish':'Código promocional',
    'German':'Gutscheincode',
    'French':"Code de réduction",
    'Japanese':'クーポンコード',
    'Russian':'код купона',
    'Chinese':'优惠券代码',
    'Portuguese':'Código do cupom',
  };

  @override
  void initState()
  {
    scrollController = new ScrollController()..addListener(_scrollListener);
    getData();
    super.initState();
  }

  getData()async
  {
    if(currentUser!=null)
      {
        DocumentSnapshot doc=await badgesReference.doc(currentUser.id).get();
        if(doc.exists)
          badges=List.from(doc.data()['badges']);
      }
    QuerySnapshot snapshotForCoupons=await couponsReference
        .where('visibility',isEqualTo: true)
        .limit(10).get();
    if(snapshotForCoupons!=null&&snapshotForCoupons.docs.length>0)
      {
        if(snapshotForCoupons.docs.length>1)
          {
            lastDoc = snapshotForCoupons.docs[snapshotForCoupons.docs.length - 1];
          }
        snapshotForCoupons.docs.forEach((document) {
          couponModels.add(CouponsModel.fromDocument(document));
        });
        couponModels.shuffle();
        if(currentUser!=null)
          {
            couponModels.removeWhere((element) => element.boughtBy.contains(currentUser.id));
          }
      }
    setState(() {
      loading=false;
    });
  }

  void _scrollListener()async{
    if (!loading&&!load) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        setState(() => load = true);
        await getMoreCoupons();
      }
    }
  }

  getMoreCoupons()async{
    QuerySnapshot querySnapshot=await couponsReference
        .where('visibility',isEqualTo: true)
        .startAfter([lastDoc['id']])
        .limit(10).get();
    if(querySnapshot!=null&&querySnapshot.docs.length>0)
    {
      lastDoc = querySnapshot.docs[querySnapshot.docs.length - 1];
      List<CouponsModel> models=[];
      querySnapshot.docs.forEach((document) {
        models.add(CouponsModel.fromDocument(document));
      });
      models.shuffle();
      couponModels.addAll(models);
      if(currentUser!=null)
        {
          couponModels.removeWhere((element) => element.boughtBy.contains(currentUser.id));
        }
    }
    else
      showToast(toastMessage[lang]);
    setState(() {
      load=false;
    });
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
          IconButton(
            icon: Transform.rotate(
              angle: -pi/5,
              child: Icon(FontAwesomeIcons.ticketAlt, color: Colors.black,),
            ),
            onPressed: () => currentUser!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCoupons())):showToast('Login to see your coupons..'),
          ),
          SizedBox(width: 3,),
        ],
        title: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: const Color(0xfff0f0f0),
      ),
      body: loading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            currentUser!=null?Text(
              badgesText[lang],
              style: GoogleFonts.gugi(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ):Container(),
            currentUser!=null?SizedBox(height: 15):Container(),
            currentUser!=null?Container(
              width: double.infinity,
              height: 160,
              child: badges.isNotEmpty?ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: badges.length,
                itemBuilder: (context,index)
                {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BadgesPopUp(
                        title: badges[index]=='Addiction'?firstCondition[lang]:badges[index]=='Habit Building'?secondCondition[lang]:doing[lang]+" ${badges[index]} "+more[lang],
                        fileName: badges[index],
                      )));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/3.5,
                      margin: EdgeInsets.only(right:10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.blue[100].withOpacity(0.3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: AssetImage('assets/badges/${badges[index]}.png'),
                          ),
                          SizedBox(height: 15,),
                          Text(
                            badges[index],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.gugi(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  );
                },
              ):Center(
                child: Text(
                  noBadges[lang],
                  style: GoogleFonts.gugi(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ):Container(),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  couponText[lang],
                  style: GoogleFonts.gugi(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    minWidth: 90
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.blue[100]
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.coins,color: Colors.yellowAccent,),
                      SizedBox(width: 10,),
                      ValueListenableBuilder(
                        valueListenable: xo,
                          child: Container(),
                          builder: (BuildContext context, int value, Widget child)
                          {
                            return Text(
                              value.toString()+' xo',
                              style: GoogleFonts.gugi(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: couponModels.length,
              itemBuilder: (context,index){
                return CouponWidget(couponsModel: couponModels[index],xo: xo,isBought: false,);
              },
            ),
            load?Center(child: CircularProgressIndicator(),):Container(),
          ],
        ),
      ),
    );
  }
}
