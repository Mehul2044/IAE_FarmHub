import 'package:flutter/material.dart';

class CropDetailScreen extends StatelessWidget {
  final String id;
  final cropData;

  const CropDetailScreen({super.key, required this.id, required this.cropData});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var crop;
    for (var item in cropData) {
      if (item['id'].toString() == id) {
        crop = item;
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text(crop['name'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              width: width * 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(crop['imageUrl']),
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(crop['name'],
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: height * 0.02),
            Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(crop['description'], textAlign: TextAlign.left)),
            SizedBox(height: height * 0.01),
          ],
        ),
     ),
);
}
}