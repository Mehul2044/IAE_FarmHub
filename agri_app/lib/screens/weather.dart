import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  bool isLoading = false;
  bool isError = false;

  Map<String, dynamic> weatherInfo = {};

  @override
  void initState() {
    // TODO: implement initState
    getLocationData();
    super.initState();
  }

  void getLocationData() async {
    setState(() => isLoading = true);
    try {
      var response = await Dio().get(
          'https://api.openweathermap.org/data/2.5/weather?q=tada&appid=730d719ac3bd3c2ae02d0483af92253f&units=metric');
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        weatherInfo = response.data;
        print(weatherInfo);
      }
    } catch (e) {
      setState(() => isError = true);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather Info")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? const Center(
                  child: AlertDialog(
                    title: Text("Error Occurred!"),
                    content: Text(
                        "Unable to fetch data. Please check your internet connection and refresh!"),
                  ),
                )
              : Stack(
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
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 180,
                              child: Image.asset("assets/cloud.png"),
                            ),
                            const SizedBox(width:0,),
                            Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text("${weatherInfo["weather"][0]["description"]} today".toUpperCase(),style: TextStyle(fontFamily: "Roberto",fontSize:12),),   
                            Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Humidity ${weatherInfo["main"]["humidity"]} %",style: TextStyle(fontFamily: "Roberto",fontSize: 16),)],),
                            Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Temprature ${weatherInfo["main"]["temp"]}°C",style: TextStyle(fontFamily: "Roberto",fontSize: 16),)],)],),
                         
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Minimum Temprature ${weatherInfo["main"]["temp_min"]}°C",style: TextStyle(fontSize: 12),),SizedBox(width:10,),Text("Max Temprature ${weatherInfo["main"]["temp_max"]}°C",style: TextStyle(fontSize: 12),)],),
                        SizedBox(height: 20,),
                        Container(
                              height: 100,
                              child: Image.asset("assets/House.png"),
                            ),
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 70),
                              child: Row(mainAxisAlignment: MainAxisAlignment.start,children: [Text("Good Day To Farm",style: TextStyle(fontFamily: "cursive",fontSize: 30))],),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                    
                                Container(decoration: BoxDecoration(color: Color.fromARGB(100, 201, 199, 199),borderRadius: BorderRadius.all(Radius.circular(20))),alignment: Alignment.center,height: 120,width: 140,child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(children: [Icon(Icons.visibility,size: 28,),SizedBox(height: 4,),Text("${weatherInfo["visibility"]} m",style: TextStyle(fontSize: 20),),Text("Visibility",style: TextStyle(fontSize: 10),)],),
                                ),),
                                SizedBox(width: 20,),
                                Container(decoration: BoxDecoration(color: Color.fromARGB(100, 201, 199, 199),borderRadius: BorderRadius.all(Radius.circular(20))),alignment: Alignment.center,height: 120,width: 140,child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(children: [Icon(Icons.place,size: 28,),SizedBox(height: 4,),Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${weatherInfo["coord"]["lat"]}".substring(0,5),style: TextStyle(fontSize: 20),),
                                      SizedBox(width: 10,),
                                      Text("${weatherInfo["coord"]["lon"]}".substring(0,5),style: TextStyle(fontSize: 20),),
                                    ],
                                  ),Text("Location",style: TextStyle(fontSize: 10),)],),
                                ),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                    
                                Container(decoration: BoxDecoration(color: Color.fromARGB(100, 201, 199, 199),borderRadius: BorderRadius.all(Radius.circular(20))),alignment: Alignment.center,height: 120,width: 140,child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(children: [Icon(Icons.air,size: 28,),SizedBox(height: 4,),Text("${weatherInfo["wind"]["speed"]} Kmph",style: TextStyle(fontSize: 20),),Text("Wind Speed",style: TextStyle(fontSize: 10),)],),
                                ),),
                                SizedBox(width: 20,),
                                Container(decoration: BoxDecoration(color: Color.fromARGB(100, 201, 199, 199),borderRadius: BorderRadius.all(Radius.circular(20))),alignment: Alignment.center,height: 120,width: 140,child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(children: [Icon(Icons.directions_outlined,size: 28,),SizedBox(height: 4,),Text("${weatherInfo["wind"]["deg"]}",style: TextStyle(fontSize: 20),),Text("degree due north",style: TextStyle(fontSize: 10),)],),
                                ),),
                              ],
                            )
                      ],
                    ),
                ],
              ),
    );
  }
}
