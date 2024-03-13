import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      // Page
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Shop Page',
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
