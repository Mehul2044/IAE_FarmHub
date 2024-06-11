

import 'package:agri_app/screens/helper_bot.dart';
import 'package:agri_app/screens/talking_bot.dart';
import 'package:flutter/material.dart';

class botselect extends StatelessWidget{
  const botselect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Bot"),),body: Stack(children: [Container(height: double.infinity,width: double.infinity,decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.white,
                    Color.fromARGB(100, 249, 228, 188),
                  ],
                  stops: [
                    0.0,
                    1.0
                  ])),),Container(width: double.infinity,height: double.infinity,child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [InkWell(onTap: (){Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const Talkbot()));},
                    child: Container(decoration: BoxDecoration(border: Border.all(width: 2),borderRadius: BorderRadius.all(Radius.circular(50))),height: 100,width: 100,child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset("assets/mic1.png"),
                    ),),
                  ),SizedBox(width: 30,),InkWell(onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const Chatbot()));
                  },
                    child: Container(decoration: BoxDecoration(border: Border.all(width: 2),borderRadius: BorderRadius.all(Radius.circular(50))),height: 100,width: 100,child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset("assets/keyboard1.png"),
                    ),),
                  )],),),)],));
}

}