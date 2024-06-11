import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:agri_app/constants/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';

class HomePageTest extends StatefulWidget {
  const HomePageTest({super.key});

  @override
  State<HomePageTest> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePageTest> {
  final apiService = ApiService();
  File? _selectedImage;
  String diseaseName = '';
  String diseasePrecautions = '';
  bool detecting = false;
  bool precautionLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  detectDisease() async {
    setState(() {
      detecting = true;
    });
    try {
      GenerateContentResponse temp = await apiService.sendImageToGPT4Vision(image: _selectedImage!);
      diseaseName = temp.text!;
    } catch (error) {
      _showErrorSnackBar(error);
    } finally {
      setState(() {
        detecting = false;
      });
    }
  }

  showPrecautions() async {
    setState(() {
      precautionLoading = true;
    });
    try {
      if (diseasePrecautions == '') {
        GenerateContentResponse temp2 = await apiService.sendMessageGPT(diseaseName: diseaseName);
        diseasePrecautions = temp2.text!;
      }
      _showSuccessDialog(diseaseName, diseasePrecautions);
    } catch (error) {
      _showErrorSnackBar(error);
    } finally {
      setState(() {
        precautionLoading = false;
      });
    }
  }

  void _showErrorSnackBar(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.toString()),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccessDialog(String title, String content) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: title,
      desc: content,
      btnOkText: 'Got it',
      btnOkColor: themeColor,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Disese Predictor"),),
      body: Stack(
        children: [
          Container(height: double.infinity,width: double.infinity,decoration: BoxDecoration(
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
                  ])),),
          Column(
            children: <Widget>[
              const SizedBox(height: 20),
              
              _selectedImage == null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Image.asset('assets/pick1.png'),
                    )
                  : Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: double.infinity,
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
              if (_selectedImage != null)
                detecting
                    ? SpinKitWave(
                        color: themeColor,
                        size: 30,
                      )
                    : Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            // Set some horizontal and vertical padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15), // Rounded corners
                            ),
                          ),
                          onPressed: () {
                            detectDisease();
                          },
                          child: const Text(
                            'DETECT',
                            style: TextStyle(
                              color: Colors.white, // Set the text color to white
                              fontSize: 16, // Set the font size
                              fontWeight:
                                  FontWeight.bold, // Set the font weight to bold
                            ),
                          ),
                        ),
                      ),
              if (diseaseName != '')
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultTextStyle(
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                            child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                repeatForever: false,
                                displayFullTextOnTap: true,
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    diseaseName.trim(),
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                    precautionLoading
                        ? const SpinKitWave(
                            color: Colors.blue,
                            size: 30,
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 157, 157, 158),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            onPressed: () {
                              showPrecautions();
                            },
                            child: Text(
                              'PRECAUTION',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ),
                  ],
                ),
                Expanded(flex: 1,
             child: Container(),
                ),
                Stack(
                children: [
                  
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(97, 255, 211, 128),
                      borderRadius: const BorderRadius.only(
                        // Top right corner
                        // bottomLeft: Radius.circular(50.0),
                        // bottomRight: Radius.circular(50.0), // Bottom right corner
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          // Shadow color with some transparency
                          spreadRadius: 1,
                          // Extend the shadow to all sides equally
                          blurRadius: 5,
                          // Soften the shadow
                          offset: const Offset(2, 2), // Position of the shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            _pickImage(ImageSource.gallery);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'OPEN GALLERY',
                                style: TextStyle(color: textColor),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.image,
                                color: textColor,
                              )
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _pickImage(ImageSource.camera);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('START CAMERA',
                                  style: TextStyle(color: textColor)),
                              const SizedBox(width: 10),
                              Icon(Icons.camera_alt, color: textColor)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
