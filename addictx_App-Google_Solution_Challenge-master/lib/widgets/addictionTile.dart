import 'package:addictx/pages/combine.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddictionTile extends StatelessWidget {
  final String heading;
  final String fileName;
  final String addictionName;
  final Timestamp timestamp;

  const AddictionTile({Key key,this.addictionName,this.heading,this.fileName,this.timestamp}) : super(key: key);

  void navigate(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Combine(
      heading: addictionName,
      fileName: fileName,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: ()=>navigate(context),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          color: Color(0xfff0f0f0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/blueAddiction/'+getFileName(addictionName)+'.png',),
                        backgroundColor: const Color(0xff9ad0e5),
                        radius: 30,
                      )
                  ),
                  Text(
                    addictionName,
                    style: TextStyle (
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  Spacer(),
                  VerticalDivider(
                    color: Color(0xffcecece),
                    width: 0,
                    thickness:1.0,
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 80,
                    child: Text(
                      DateFormat.MMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp.seconds*1000)).toString(),
                      style: TextStyle (
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}