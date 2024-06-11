import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FarmProduct {
  final String name;
  final String image;
  final String link;
  final String price;

  FarmProduct({
    required this.name,
    required this.image,
    required this.link,
    required this.price,
  });

  factory FarmProduct.fromJson(Map<String, dynamic> json) {
    return FarmProduct(
      name: json['name'],
      image: json['image'],
      link: json['link'],
      price: json['price']
    );
  }
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  ShopScreenState createState() => ShopScreenState();
}

class ShopScreenState extends State<ShopScreen> {
  late Future<List<FarmProduct>> _productsFuture;

  @override
  void initState() {
    _productsFuture = loadFarmProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shop Products")),
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
          FutureBuilder(
            future: _productsFuture,
            builder: (context, AsyncSnapshot<List<FarmProduct>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.5,
                      
                      mainAxisSpacing: 0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        final url = Uri.parse(product.link);
                        launchUrl(url);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GridTile(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12)),
                                  child: Image.asset(
                                    product.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(alignment: Alignment.centerLeft,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(0, 249, 228, 188),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12)),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      
                                    ),
                                    Text("Price: ${product.price}",style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<FarmProduct>> loadFarmProducts() async {
    String jsonString = '''
      {
        "products": [
          {
            "name": "Organic Fertilizer",
            "price": "₹99/500gm",
            "image": "assets/product_1.jpg",
            "link": "https://theaffordableorganicstore.com/product-category/manures/"
          },
          {
            "name": "Farm Tools Set",
            "price": "₹1500/1 set",
            "image": "assets/product_2.jpg",
            "link": "https://kisanshop.in/collections/agricultural-tools"
          },
          {
            "name": "Seeds Pack",
            "price": "₹350/2 Pack",
            "image": "assets/product_3.jpg",
            "link": "https://www.seedbasket.in/"
          },
          {
            "name": "Irrigation Equipment",
            "price": "₹299/1 piece",
            "image": "assets/product_4.jpg",
            "link": "https://plantlane.com/collections/drip-irrigation"
          }
        ]
      }
    ''';

    final jsonMap = json.decode(jsonString);
    final List<dynamic> productsJson = jsonMap['products'];
    return productsJson
        .map((productJson) => FarmProduct.fromJson(productJson))
        .toList();
}
}