import 'package:admin/components/drawer_list.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  // UI Ecommerce
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: const DrawerList(),
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
