import 'package:admin/components/drawer_list.dart';
import 'package:admin/pages/intro_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  late User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  // Sign User Out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Get.offAll(const IntroPage());
  }

  // UI Ecommerce
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: DrawerList(
        signOutCallback: signUserOut,
      ),
      // Page
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Created By',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),

            SizedBox(height: 5),

            // Sub Title
            Text(
              'Maulana Ra\'afi',
              style: TextStyle(
                fontSize: 23,
                color: Color.fromARGB(255, 87, 87, 87),
              ),
              textAlign: TextAlign.center,
            ),

            // Sub Title
            Text(
              'XI RPL U',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
