import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class UserDataProvider with ChangeNotifier {
  late String name;
  late Map<String, String> cropDetail;
  late double landArea;

  bool isLoading = false;

  Future<bool> loadData() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      DatabaseReference ref = FirebaseDatabase.instance.ref(user.uid);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        name = data['name'] ?? '';
        cropDetail = Map<String, String>.from(data['cropDetail'] ?? {});
        landArea = (data['landArea'] ?? 0).toDouble();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error: $e");
      return false;
    }
  }

  Future<void> setData(
      String name, Map<String, String> cropDetail, double landArea) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      DatabaseReference ref = FirebaseDatabase.instance.ref(user.uid);

      // Update local state
      this.name = name;
      this.cropDetail = cropDetail;
      this.landArea = landArea;
      notifyListeners(); // Notify listeners about the state change

      // Set data in Firebase Realtime Database
      await ref.set({
        'name': name,
        'cropDetail': cropDetail,
        'landArea': landArea,
      });
    } catch (e) {
      // Handle error
      print('Error setting data: $e');
    }
  }
}

