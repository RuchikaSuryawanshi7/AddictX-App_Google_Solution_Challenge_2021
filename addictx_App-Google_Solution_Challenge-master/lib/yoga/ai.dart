import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WebViewExample extends StatefulWidget {
  final String poseName;

  const WebViewExample({Key key, this.poseName}) : super(key: key);
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> with TickerProviderStateMixin {
  double acc = 0;
  Animation<double> animation;
  AnimationController _controller;
  int i = 0;
  bool first = true;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 200), vsync: this);
    animation = Tween<double>(begin: 200, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          i = animation.value.toInt();
        });
      });
    // _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    InAppWebViewController _webViewController;
    return Scaffold(
        appBar: AppBar(title: Text("${widget.poseName} Pose")),
        body: Stack(
          children: [
            Container(
                child: Column(children: <Widget>[
                  Expanded(
                    child: Container(
                      child: InAppWebView(
                        // initialUrl: "help/index.html",
                          initialFile: "help/index.html",
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                              mediaPlaybackRequiresUserGesture: false,
                              debuggingEnabled: true,
                            ),
                          ),
                          onWebViewCreated: (InAppWebViewController controller) {
                            _webViewController = controller;
                            _webViewController.addJavaScriptHandler(
                                handlerName: 'updater',
                                callback: (args) {
                                  List predictions = args[0];
                                  predictions.forEach((element) {
                                    double k = element["probability"] ?? 0;
                                    if (first) {
                                      _controller.forward();
                                    }
                                    setState(() {
                                      if (widget.poseName == element["className"])
                                        acc = k;
                                    });
                                  });
                                });
                          },
                          androidOnPermissionRequest:
                              (InAppWebViewController controller, String origin,
                              List<String> resources) async {
                            return PermissionRequestResponse(
                                resources: resources,
                                action: PermissionRequestResponseAction.GRANT);
                          }),
                    ),
                  ),
                ])),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // color: ,
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${(i ~/ 60)}:${i % 60}min",
                              style: GoogleFonts.gugi(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                        ],
                      ),
                      LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width,
                          animation: true,
                          lineHeight: 10.0,
                          animationDuration: 2000,
                          percent: acc,
                          backgroundColor: Colors.transparent,
                          linearStrokeCap: LinearStrokeCap.butt,
                          progressColor: Colors.blueAccent),
                    ],
                  )),
            )
          ],
        ));
  }
}