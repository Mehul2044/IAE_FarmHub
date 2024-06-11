import 'package:agri_app/provider/userdata_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/auth_screen.dart';
import '../screens/form_screen.dart';
import '../screens/home_screen.dart';

class HomeConfig extends StatelessWidget {
  const HomeConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
              future: Provider.of<UserDataProvider>(context, listen: false).loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                else {
                  bool isDataAvailable = snapshot.data!;
                  if (!isDataAvailable) {
                    return const FormScreen();
                  }
                  return const HomeScreen();
                }
              });
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
