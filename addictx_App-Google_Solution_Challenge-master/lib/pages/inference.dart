import 'dart:math';
import 'package:addictx/pages/bndBox.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/pages/camera.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
double counter = 0;
class InferencePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final String customModel;

  const InferencePage({this.cameras, this.title, this.model, this.customModel});

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
    var res = loadModel();
    print('Model Response: ' + res.toString());
  }

  updateScoreOfContest()async{
    if(currentUser!=null)
      {
        await leaderBoardReference.doc("Yoga League").collection('scores').doc(currentUser.id).set({
          'id':currentUser.id,
          'timeStamp':DateTime.now(),
          'score':FieldValue.increment((counter*100).floor()),
        },SetOptions(merge: true));
        await usersReference.doc(currentUser.id).update({
          'score':FieldValue.increment((counter*50).floor()),
        });
      }
    counter=0;
  }

  Future<bool> onBackPress()
  {
    updateScoreOfContest();
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            Camera(
              cameras: widget.cameras,
              setRecognitions: _setRecognitions,
            ),
            BndBox(
              results: _recognitions == null ? [] : _recognitions,
              previewH: max(_imageHeight, _imageWidth),
              previewW: min(_imageHeight, _imageWidth),
              screenH: screen.height,
              screenW: screen.width,
              customModel: widget.customModel,
            ),
          ],
        ),
      ),
    );
  }

  _setRecognitions(recognitions, imageHeight, imageWidth) {
    if (!mounted) {
      return;
    }
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  loadModel() async {
    return await Tflite.loadModel(
      model: widget.model,
    );
  }
}