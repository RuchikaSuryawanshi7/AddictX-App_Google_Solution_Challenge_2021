import 'package:addictx/pages/inference.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';

class Poses extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final List<String> asanas;
  final Color color;

  const Poses({this.cameras, this.title, this.model, this.asanas, this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,style: GoogleFonts.gugi(
            textStyle: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image(image: AssetImage("assets/yoga/yogaback.png"),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,),
          Center(
            child: Swiper(
              itemCount: asanas.length,
              loop: false,
              viewportFraction: 0.8,
              scale: 0.82,
              outer: true,
              pagination: SwiperPagination(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.all(32.0),
              ),
              onTap: (index) => _onSelect(context, asanas[index]),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Container(
                    height: 500,
                    width: 500,
                    child: YogaCard(
                      asana: asanas[index],
                      color: color,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSelect(BuildContext context, String customModelName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InferencePage(
          cameras: cameras,
          title: customModelName,
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          customModel: customModelName,
        ),
      ),
    );
  }
}

class YogaCard extends StatelessWidget {
  final String asana;
  final Color color;

  const YogaCard({this.asana, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            "assets/yoga/" + asana + ".jpg",
            fit: BoxFit.contain,
            height: 450,
          ),
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  asana,
                  style: GoogleFonts.gugi(
                    textStyle: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}