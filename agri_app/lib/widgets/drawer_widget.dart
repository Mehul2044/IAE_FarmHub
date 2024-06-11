import 'package:agri_app/config/constants.dart';
import 'package:agri_app/screens/calender_screen.dart';
import 'package:agri_app/screens/form_screen.dart';
import 'package:agri_app/screens/schemes_screen.dart';
import 'package:agri_app/screens/shop_screen.dart';
import 'package:agri_app/screens/talking_bot.dart';
import 'package:agri_app/screens/todo_screen.dart';
import 'package:agri_app/screens/weather.dart';
import 'package:flutter/material.dart';
import 'package:agri_app/screens/test.dart';
import 'package:agri_app/screens/helper_bot.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    Widget listItem(String text, IconData icon, VoidCallback tapHandler) {
      return SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          style: TextButton.styleFrom(alignment: Alignment.centerLeft,iconColor: Color.fromARGB(255, 77, 77, 77)),
            onPressed: tapHandler,
            icon: Icon(icon),
            label: Text(text,style: TextStyle(color: Color.fromARGB(255, 119, 119, 119)),)),
      );
    }

    return Drawer(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                height: height * 0.13,
                alignment: Alignment.bottomCenter,
                child: Image.asset(Constants.logonew, height: height * 0.15),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.05),
                listItem(
                    "Calender",
                    Icons.calendar_month,
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const CalenderScreen()))),
                const Divider(color: Colors.grey,),
                listItem(
                    "Weather Info",
                    Icons.cloud,
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Weather()))),
                const Divider(color: Colors.grey,),
                listItem(
                    "Disease detection",
                    Icons.coronavirus,
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePageTest()))),
                const Divider(color: Colors.grey,),
                listItem(
                    "Kisan Mitra",
                    Icons.keyboard_alt_outlined,
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Chatbot()))),
                        const Divider(color: Colors.grey,),
                        listItem(
                    "Government Schemes",
                    Icons.schema,
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const SchemesScreen()))),
                        const Divider(color: Colors.grey,),
                        listItem(
                    "Shop",
                    Icons.shopping_cart,
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ShopScreen()))),
                         const Divider(color: Colors.grey,),
                listItem(
                    "Kisan Mitra",
                    Icons.mic,
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Talkbot()))),
const Divider(color: Colors.grey,),
                        listItem(
                    "ToDo-List",
                    Icons.list,
                    () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ToDoScreen())))
                    


              ],
            ),
          ],
        ),
      ),
    );
  }
}
