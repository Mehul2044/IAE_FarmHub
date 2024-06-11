import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GovernmentScheme {
  final String name;
  final String image;
  final String description;
  final String link;

  GovernmentScheme({
    required this.name,
    required this.image,
    required this.description,
    required this.link,
  });

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
        name: json['name'],
        image: json['image'],
        description: json['description'],
        link: json['link']);
  }
}

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  late Future<List<GovernmentScheme>> _schemesFuture;

  @override
  void initState() {
    _schemesFuture = loadGovernmentSchemes();
    super.initState();
  }

  void _showDescriptionModal(BuildContext context, GovernmentScheme scheme) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                scheme.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(scheme.description),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  final url = Uri.parse(scheme.link);
                  launchUrl(url);
                },
                child: Text(
                  scheme.link,
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Government Schemes")),
      body: FutureBuilder(
        future: _schemesFuture,
        builder: (context, AsyncSnapshot<List<GovernmentScheme>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.75,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final scheme = snapshot.data![index];
                  return GestureDetector(
                    onTap: () => _showDescriptionModal(context, scheme),
                    child: GridTile(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              child: Image.asset(
                                scheme.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 227, 227, 227),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              scheme.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<GovernmentScheme>> loadGovernmentSchemes() async {
    String jsonString = '''
      {
        "schemes": [
          {
            "name": "Pradhan Mantri Kisan Samman Nidhi",
            "image": "assets/yojana_1.jpg",
            "description": "PM-KISAN is a central sector scheme with 100% funding from the Government of India. It provides income support of ₹6000 per year to all farmer families across the country, payable in three equal installments of ₹2000 each.",
            "link": "https://pmkisan.gov.in/"
          },
          {
            "name": "PM Kisan Maan Dhan Yojana",
            "image": "assets/yojana_2.jpg",
            "description": "PM Kisan Maan Dhan Yojana is a voluntary and contributory pension scheme for small and marginal farmers in the age group of 18 to 40 years. It aims to provide a minimum pension of ₹3000 per month to beneficiaries upon attaining the age of 60 years.",
            "link": "https://www.myscheme.gov.in/schemes/pmkmy"
          },
          {
            "name": "Pradhan Mantri Fasal Bima Yojana (PMFBY)",
            "image": "assets/yojana_3.jpg",
            "description": "PMFBY is an insurance scheme that provides financial support to farmers in case of crop failure due to natural calamities, pests, or diseases. It covers pre-sowing to post-harvest losses and aims to stabilize farmers' income.",
            "link": "https://pmfby.gov.in/"
          },
          {
            "name": "Kisan Credit Card (KCC) Scheme",
            "image": "assets/yojana_4.jpg",
            "description": "Kisan Credit Card (KCC) Scheme is a credit delivery mechanism to provide timely and adequate credit support to farmers for their cultivation needs. It aims to ensure easy access to credit for farmers, enabling them to meet their agricultural expenses such as purchase of seeds, fertilizers, pesticides, and other inputs.",
            "link": "https://www.myscheme.gov.in/schemes/kcc"
          }
        ]
      }
    ''';

    final jsonMap = json.decode(jsonString);
    final List<dynamic> schemesJson = jsonMap['schemes'];
    return schemesJson
        .map((schemeJson) => GovernmentScheme.fromJson(schemeJson))
        .toList();
}
}