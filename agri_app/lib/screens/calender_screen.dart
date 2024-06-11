import 'package:agri_app/provider/userdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CropHarvestingDate {
  final String cropName;
  final int daysToHarvest;
  final String manure;
  final String irrigation;
  final String storage;
  final String link;

  CropHarvestingDate(
      {required this.cropName,
      required this.daysToHarvest,
      required this.manure,
      required this.irrigation,
      required this.storage,
      required this.link});
}

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({super.key});

  String formattedDate(DateTime date) {
    final formatter = DateFormat('d MMMM, EEEE');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserDataProvider>(context, listen: false);

    final List<CropHarvestingDate> harvestingDates = [
      CropHarvestingDate(
          cropName: 'Maize',
          daysToHarvest: 90,
          manure: 'Once at the start of cropping season',
          irrigation: 'Every 10 days',
          storage:
              'After harvest, Maize grains are stored in well-ventilated grain silos to protect them from pests and moisture. Properly dried and stored Maize can be preserved for an extended period.',
          link: "assets/maize.jpeg"),
      CropHarvestingDate(
          cropName: 'Rice',
          daysToHarvest: 120,
          manure: 'Twice in the cropping season',
          irrigation: 'Maintain continuous flooding',
          storage:
              'Rice grains are typically stored in paddy bins, which are specially designed containers with airtight lids to protect the grains from moisture and pests. Properly stored Rice can be preserved for long periods without quality deterioration.',
          link: "assets/rice.jpg"),
      CropHarvestingDate(
          cropName: 'Wheat',
          daysToHarvest: 100,
          manure: 'Before planting the crop',
          irrigation: 'Every 7-10 days',
          storage:
              'After harvest, Wheat grains are stored in well-ventilated grain silos to maintain their quality and prevent spoilage. The silos protect the grains from moisture, pests, and fungal growth, ensuring that the stored Wheat remains suitable for consumption and market sale.',
          link: "assets/wheat.jpg"),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Crop Calender")),
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
            children: [
              Image.asset("assets/farmercrop.jpg",height: 120,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Total Land Area: ${userProvider.landArea} Hectare",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  "Total Crops You Grow ${userProvider.cropDetail.length} ",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final cropName = userProvider.cropDetail.keys.toList()[index];
                    final sowingDate = userProvider.cropDetail[cropName];
                    final harvestingDate = _calculateHarvestingDate(
                        cropName, DateTime.parse(sowingDate!), harvestingDates);
                    final imageLink = harvestingDates.firstWhere((element) => element.cropName == cropName).link;
                    final manure = harvestingDates.firstWhere((element) => element.cropName == cropName).manure;
                    final storage = harvestingDates.firstWhere((element) => element.cropName == cropName).storage;
                    final irrigation = harvestingDates.firstWhere((element) => element.cropName == cropName).irrigation;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(color: Colors.white,
                          child: ListTile(
                            title: Text(
                              "Crop: $cropName",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(imageLink,),
                                SizedBox(height: 20,),
                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(decoration: BoxDecoration(color: Color.fromARGB(255, 228, 228, 228),borderRadius: BorderRadius.circular(10)),width: 130,height: 60,alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "Sowing Date: ${formattedDate(DateTime.parse(sowingDate))}\n",style: TextStyle(fontWeight: FontWeight.w700 ),textAlign: TextAlign.center),
                                      ),
                                    ),SizedBox(width: 10,),
                                    
                                        Container(
                                         decoration: BoxDecoration(color: Color.fromARGB(255, 228, 228, 228),borderRadius: BorderRadius.circular(10)),width: 130,height: 60,alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                                            "Harvesting Date: ${formattedDate(DateTime.parse(harvestingDate))}\n",style: TextStyle(fontWeight: FontWeight.w700 ),textAlign: TextAlign.center),
                                          ),
                                        ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(decoration: BoxDecoration(color: Color.fromARGB(255, 228, 228, 228),borderRadius: BorderRadius.circular(10)),width: 130,height: 60,alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "Manure: $manure\n",style: TextStyle(fontWeight: FontWeight.w700 ),textAlign: TextAlign.center),
                                      ),
                                    ),SizedBox(width: 10,),
                                    
                                        Container(
                                         decoration: BoxDecoration(color: Color.fromARGB(255, 228, 228, 228),borderRadius: BorderRadius.circular(10)),width: 130,height: 60,alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Irrigation: $irrigation\n",style: TextStyle(fontWeight: FontWeight.w700 ),textAlign: TextAlign.center,),
                                          ),
                                        ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                
                                Text("Storage: $storage\n"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: userProvider.cropDetail.length,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateHarvestingDate(String cropName, DateTime? sowingDate,
      List<CropHarvestingDate> harvestingDates) {
    final CropHarvestingDate cropHarvestingDate = harvestingDates.firstWhere(
      (harvestingDate) => harvestingDate.cropName == cropName,
      orElse: () => CropHarvestingDate(
          cropName: '',
          daysToHarvest: 0,
          manure: "",
          irrigation: "",
          storage: "",
          link: ""),
    );

    if (cropHarvestingDate.cropName.isNotEmpty && sowingDate != null) {
      final harvestingDate =
          sowingDate.add(Duration(days: cropHarvestingDate.daysToHarvest));
      return harvestingDate.toString();
    } else {
      return 'Unknown';
}
}
}