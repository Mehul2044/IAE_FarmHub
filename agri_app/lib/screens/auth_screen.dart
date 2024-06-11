import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '/provider/signin_provider.dart';
import '/config/constants.dart';

class AuthScreen extends StatelessWidget {
   AuthScreen({super.key});

  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
        final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: Consumer<SignInProvider>(builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Stack(
            children: [
              Image.asset(Constants.loginbackground,width: double.infinity,),
              Container(height: height,width: double.infinity, decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Color.fromARGB(100, 165, 59, 0),
                    Color.fromARGB(180, 26, 85, 42),
                  ],
                  stops: [
                    0.0,
                    1.0
                  ],),),),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                 
                  children: [
                    SizedBox(height: height*0.10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Image.asset(Constants.logonew, height: height * 0.15),
                    ),
                    SizedBox(height: height * 0.04),
                    
                     Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Make Farming Easy",style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: "Cursive"),),
                    ),
                    SizedBox(height: height*0.3,),
                       Row(mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text("Sign In With",style: TextStyle(fontSize: 20,color: Colors.white,),),
                         ],
                       ),
                       SizedBox(height: height*0.03,),
                    
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 2,color: Colors.white,width:(width-50)/2,),
                        Container(child: Icon(Icons.accessibility_new_rounded,color: Colors.white,),),
                        Container(height: 2,color: Colors.white,width:(width-50)/2,),
                      ],
                    ),
                    SizedBox(height: height*0.03,),
                    
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: width*0.8,height: height*0.07,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: ElevatedButton(
                              onPressed: () => provider.signIn(context),
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(Constants.googleLogo),
                                  const SizedBox(width: 15),
                                  const Text("Sign In with Google"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("or",style: TextStyle(fontSize: 30,color: Colors.white,fontFamily: "Cursive")),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                      child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  hintText: 'Enter phone number',
                   hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
                    ),
                
                    SizedBox(height: height * 0.01),
                  ],
                ),
              ),
             
            ],
          );
        }
      }),
    );
  }
}
