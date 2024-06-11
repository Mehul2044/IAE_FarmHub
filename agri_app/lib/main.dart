import 'package:agri_app/provider/userdata_provider.dart';
import 'package:agri_app/screens/splashscreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '/provider/signin_provider.dart';

import '/config/firebase_options.dart';

import 'config/home_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ],
      child: MaterialApp( 
        debugShowCheckedModeBanner: false,
        title: 'Farm Hub',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(),
          useMaterial3: true,
        ),
        home:  AnimatedSplashScreen(splashIconSize: 300,splashTransition: SplashTransition.fadeTransition,duration: 5000,splash: Center(child:Container(width: 200, child: FittedBox(child: ClipRRect(borderRadius: BorderRadius.circular(600), child: Image.asset("assets/splash.gif",)),),)), nextScreen: HomeConfig()),
      ),
    );
  }
}