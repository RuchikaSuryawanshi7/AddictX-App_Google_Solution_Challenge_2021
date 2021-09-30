import 'package:addictx/languageNotifier.dart';
import 'package:addictx/main.dart';
import 'package:addictx/pages/moodResult.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';


class MoodDetector extends StatefulWidget {
  @override
  _MoodDetectorState createState() => _MoodDetectorState();
}

class _MoodDetectorState extends State<MoodDetector> {
  FaceDetector faceDetector =
  GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));
  bool isBusy = false;
  CustomPaint customPaint;
  bool calledOnce=false;
  double smileProb=0.0;

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face Detector',
      customPaint: customPaint,
      onImage: (inputImage) {
        processImage(inputImage);
        if(!calledOnce){
          calledOnce=true;
          Future.delayed(Duration(milliseconds: 1500),(){
            if(smileProb>=0.4)
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MoodResult(isSmiling: true,)));
            else
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MoodResult(isSmiling: false,)));
          });
        }
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    if (faces.length > 0 && faces[0].smilingProbability != null) {
      smileProb = faces[0].smilingProbability;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  CameraView(
      {Key key,
        this.title,
        this.customPaint,
        this.onImage,
        this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String title;
  final CustomPaint customPaint;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController _controller;
  int _cameraIndex = 0;

  Map face={
    'English':"Keep your face inside the frame",
    'Hindi':'अपने चेहरे को फ्रेम के अंदर रखें',
    'Spanish':'Mantén tu cara dentro del marco',
    'German':'Halten Sie Ihr Gesicht innerhalb des Rahmens',
    'French':" Gardez votre visage à l'intérieur du cadre",
    'Japanese':'顔をフレームの中に入れてください',
    'Russian':'Держи лицо в кадре',
    'Chinese':'将脸保持在框架内',
    'Portuguese':'Mantenha seu rosto dentro da moldura',
  };
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == widget.initialDirection) {
        _cameraIndex = i;
      }
    }
    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(face[lang],
                style: GoogleFonts.gugi(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: DottedBorder(
              child: ClipOval(child: _liveFeedBody()),
              borderType: BorderType.Oval,
              padding: EdgeInsets.all(6),
              strokeWidth: 2,
              dashPattern: [8, 4],
              color: Colors.grey[500],
            ),
          )
        ],
      ),
    );
  }

  Widget _liveFeedBody() {
    if (_controller?.value?.isInitialized == false) {
      return Container();
    }
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller),
          if (widget.customPaint != null) widget.customPaint,
        ],
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.low,
      enableAudio: false,
    );
    _controller?.initialize()?.then((_) {
      if (!mounted) {
        return;
      }
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
    Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.Rotation_0deg;

    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
    InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }
}
