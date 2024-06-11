import 'package:agri_app/config/home_config.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget{
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

@override
  void initState() {
    
    super.initState();
    // navigatehome();

  }

  navigatehome()async{
    await Future.delayed(Duration(seconds: 20),(){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeConfig()));
  }



  @override
  Widget build(BuildContext context) {
   return Scaffold(body: Center(child:Container(child: Text("hii"),)),);
  }
}