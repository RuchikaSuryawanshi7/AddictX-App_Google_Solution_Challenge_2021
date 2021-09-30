import 'package:addictx/pages/poses.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:addictx/main.dart';
import 'package:addictx/pages/pedometer.dart';

class ContestsPage extends StatefulWidget {
  final String fileAddress;
  final String heading;
  final String description;
  ContestsPage({this.fileAddress,this.heading,this.description});
  @override
  _ContestsPageState createState() => _ContestsPageState();
}

class _ContestsPageState extends State<ContestsPage> {
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          CustomPaint(
            size: Size(width,(width*2.033333333333333).toDouble()),
            painter: RPSCustomPainter(),
          ),
          Positioned(
            top: 40.0,
            child: Image.asset('assets/addictx.png',height: MediaQuery.of(context).size.width/3,),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        onPressed: ()=>Navigator.pop(context),
                        shape: CircleBorder(),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(Icons.arrow_back_ios_rounded,size: 28,),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width/4.5,),
                  Padding(
                    padding: const EdgeInsets.only(left:4.0,right: 4),
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.gugi(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.fromLTRB(60, 10, 60, 10),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*1.6/3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      image: DecorationImage(
                        image: AssetImage(widget.fileAddress),
                        fit:BoxFit.cover,
                      )
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: Icon(Icons.share_outlined,color: Colors.white,size: 28,),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 60,right: 60),
                    child: RaisedButton(
                      onPressed: (){
                        if(widget.heading=='Yoga')
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Poses(
                              cameras: cameras,
                              title: "Yoga",
                              model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
                              asanas: [
                                'Trikonasana',
                                'Vrikshasana',
                                'Virbhadrasana',
                              ],
                              color: Colors.red,
                            ),));
                          }
                        else if(widget.heading=='Walking')
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DailyStepsPage()));
                          }
                      },
                      padding: EdgeInsets.all(7.0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Text(
                        "Enroll Now",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.gugi(
                          textStyle: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint_0 = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path_0 = Path();
    path_0.moveTo(size.width,0);
    path_0.lineTo(size.width,size.height*0.3107377);
    path_0.quadraticBezierTo(size.width*0.8423333,size.height*0.3884098,size.width*0.6660000,size.height*0.3979836);
    path_0.cubicTo(size.width*0.4755667,size.height*0.4344262,size.width*0.3974333,size.height*0.5417049,size.width*0.3366000,size.height*0.5781803);
    path_0.quadraticBezierTo(size.width*0.1969333,size.height*0.5990656,0,size.height*0.5260164);
    path_0.lineTo(0,0);
    path_0.lineTo(size.width,0);
    path_0.close();

    canvas.drawPath(path_0, paint_0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
