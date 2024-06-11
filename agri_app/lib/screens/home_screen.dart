import 'package:agri_app/config/constants.dart';
import 'package:agri_app/screens/botselect.dart';
import 'package:agri_app/screens/calender_screen.dart';
import 'package:agri_app/screens/crop_detail_screen.dart';
import 'package:agri_app/screens/helper_bot.dart';
import 'package:agri_app/screens/schemes_screen.dart';
import 'package:agri_app/screens/shop_screen.dart';
import 'package:agri_app/screens/test.dart';
import 'package:agri_app/screens/todo_screen.dart';
import 'package:agri_app/screens/weather.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../provider/signin_provider.dart';

import '../widgets/drawer_widget.dart';

enum FilterOptions { signOut, viewProfile }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    cropdata();
    super.initState();
  }

  bool loadingdata = false;
  var crops;

  void cropdata() async {
    setState(() {
      loadingdata = true;
    });

    print("inside");
    try {
      var response3 = await Dio()
          .get('https://agriapp-3b18f-default-rtdb.firebaseio.com/crops.json');
      if (response3.statusCode! >= 200 && response3.statusCode! <= 300) {
        setState(() {
          print(response3.data);
          crops = response3.data;
          print(crops.length);
          print("insisde");
        });
      }
    } catch (e) {
      print("insssside");
    }

    setState(() {
      loadingdata = false;
    });
  }

  void mldata() async {
    setState(() {
      loadingdata = true;
    });

    print("inside");
    try {
      var response4 = await Dio()
          .get('https://192.168.137.1:5000/getmodeloutput');
      if (response4.statusCode! >= 200 && response4.statusCode! <= 300) {
        setState(() {
          print(response4.data);
          crops = response4.data;
          print(crops.length);
          print("insisde");
        });
      }
    } catch (e) {
      print("insssside");
    }

    setState(() {
      loadingdata = false;
    });
  }

  List<int> list = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final signInProvider = Provider.of<SignInProvider>(context, listen: true);

    if (signInProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget cropWidget(String image, String text, int count) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(image),
                    // child: Container(
                    //     height: 50, width: 50, child: FittedBox(fit: BoxFit.fill,child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(50)),child: Image.network(image,fit: BoxFit.cover,)))),
                    minRadius: 30,
                  ), // Only show the text if count is not null
                ],
              ),
              const SizedBox(height: 5),
              Text(text),
            ],
          ),
        ],
      );
    }

    Widget functionalityWidget(String image, String text) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          child: Container(
            
            child: Card(
              
              // color: Colors.grey.shade100,
              elevation: 10,
              child: Container(
                
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(height: height*0.16,width: width*0.4,child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.asset(image,fit: BoxFit.fill,)),),
                    Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return loadingdata == true
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Farm Hub"),
              actions: [
                PopupMenuButton(
                  onSelected: (FilterOptions selectedValue) {
                    if (selectedValue == FilterOptions.signOut) {
                      signInProvider.signOut();
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.signOut,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(width: 10),
                          Text("Sign Out"),
                        ],
                      ),
                    ),
                    
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            drawer: const DrawerWidget(),
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
                SingleChildScrollView(
                  // scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Column(
                              children: [
                                
                              ],
                            ),
                            for (var item in crops)
                              InkWell(
                                  onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CropDetailScreen(id: item["id"].toString(), cropData: crops)));},
                                  child:
                                      cropWidget(item["imageUrl"], item["name"], 10)),
                            // cropWidget(Constants.bananaImage, "Banana", 10),
                            // cropWidget(Constants.sugarcaneImage, "SugarCane", 11),
                            // cropWidget(Constants.maizeImage, "Maize", 15),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.03),

                      Container(
          child: CarouselSlider(
        options: CarouselOptions(autoPlay: true,autoPlayInterval: Duration(seconds: 3),aspectRatio: 2,enlargeCenterPage: true),
        items: list
            .map((item) => Container(width: width,height: height*0.12,
                  child: FittedBox(child: Center(child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20)),child: Image.asset("assets/slider$item.jpg",))),fit: BoxFit.fill,),
                  // color: Colors.green,
                ))
            .toList(),
      )),
                      
                      SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(child: Text("Services",style: TextStyle(fontSize: 24),),),
                        ],
                      ),
                      // SizedBox(height: height * 0.02),
                      Container(
                        // margin: EdgeInsets.only(bottom: height * 0.05),
                        height: height * 0.95,
                        child: GridView(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1,
                          ),
                          children: [
                            InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Weather()));},child: functionalityWidget("assets/wether.jpeg", "Weather")),
                             InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CalenderScreen()));},child: functionalityWidget("assets/calender.png", "Calender")),
                        InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePageTest()));},child: functionalityWidget("assets/plantdieses.jpg", "Dieses Predictor")),
                        InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const botselect()));},child: functionalityWidget("assets/chatbot.jpg", "Kisan Mitra")),
                        InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SchemesScreen()));},child: functionalityWidget("assets/slider1.jpg", "Govt Scheme")),
                        InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ShopScreen()));},child: functionalityWidget("assets/farmu.jpg", "Utility Shop")),
                        InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ToDoScreen()));},child: functionalityWidget("assets/todo.png", "Todo List")),
                        // InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(
                        // builder: (context) => const ShopScreen()));},child: functionalityWidget("assets/b2bs.jpeg", "Rent Market")),
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                ),
                
              ],
            ),
            floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const botselect()));
        },
        tooltip: 'Listen',
        backgroundColor: Color.fromARGB(100, 249, 228, 188),
        child: Container(padding: EdgeInsets.all(5),
          child: Image.asset(
            "assets/bot.png" ,
            
          ),
        ),
      ),
          );
  }
}
