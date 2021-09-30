import 'package:addictx/SplashScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var cameras;
SharedPreferences preferences;
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox<int>('steps');
  await Permission.camera.request();
  await Permission.microphone.request();
  cameras = await availableCameras();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SharedPreferences.getInstance().then((prefs) {
    String language = prefs.getString('language') ?? 'English';
    runApp(ChangeNotifierProvider<LanguageNotifier>(
      create: (_) => LanguageNotifier(language),
      child: MyApp(),
    ),);
  });
  preferences=await SharedPreferences.getInstance();
  username=preferences.getString('name')??"";
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageNotifier>(
      builder: (context, appState, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}