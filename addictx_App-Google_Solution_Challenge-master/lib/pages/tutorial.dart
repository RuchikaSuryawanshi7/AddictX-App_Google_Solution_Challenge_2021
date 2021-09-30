import 'package:addictx/pages/addFaceData.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<String> headers = ["Persevere", "Fierce", "Sincere"];
  List<String> footers = [
    "Master the art of proceeding to work even in the hardest of all the circumstance with courage. Don't worry about failure as once you fail then only.",
    "Time fears nothing, so shall you inculcate in yourself. With a little audacity, all your dreams can become reality. It's an art that can be mastered by all.",
    "An ant is slow but consistent even if there are calamities ahead of them. They will certainly cross the mountain of challenges and will never leave any ocean of opportunity at their bay."
  ];
  int index = 0;
  final changeNotifier = new StreamController.broadcast();
  Animation<Offset> _offsetAnimation;
  final key = new GlobalKey();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.reverse) _controller.forward();
    });
  }

  @override
  void dispose() {
    changeNotifier.close();
    _controller.dispose();
    super.dispose();
  }

  onTap()async
  {
    String username;
    var faker = new Faker();
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setBool('shown', true);
    username=faker.person.name();
    sharedPreferences.setString('name', username);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFaceData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BannerCarousel(
            key: key,
            customizedBanners: [
              Image.asset("assets/intro/persevere.png",width: double.infinity,fit: BoxFit.cover,),
              Image.asset("assets/intro/fierce.png",width: double.infinity,fit: BoxFit.cover,),
              Image.asset("assets/intro/sincere.png",width: double.infinity,fit: BoxFit.cover,),
            ],
            customizedIndicators: IndicatorModel.animation(width: 20, height: 10, spaceBetween: 2, widthAnimation: 70),
            height: MediaQuery.of(context).size.height * 0.6,
            activeColor: Colors.blue[200],
            disableColor: Colors.grey[200],
            animation: true,
            borderRadius: 10,
            width: double.infinity,
            indicatorBottom: false,
            shouldTriggerChange: changeNotifier.stream,
            transitionCurve: Curves.decelerate,
            transitionDuration: Duration(seconds: 2),
            onPageChanged: (current) {
              setState(() {
                index = current;
              });
              _controller.forward(from: 0.0);
            },
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.grey[200]),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Be",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      SlideTransition(
                        position: _offsetAnimation,
                        child: Text(headers[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40.0,
                            )),
                      )
                    ],
                  ),
                  Text(
                    footers[index],
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      FlatButton(
                          onPressed: () {
                            // if (index != 0) index--;
                            changeNotifier.sink.add(--index);
                          },
                          child: Text(
                            "Back",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 20.0,
                            ),
                          )),
                      Spacer(),
                      FlatButton(
                          onPressed: () {
                            changeNotifier.sink.add(++index);
                            if(index>=3)
                              onTap();
                          },
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 20.0,
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}