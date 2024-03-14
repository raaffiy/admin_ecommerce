import 'package:flutter/material.dart';
import 'package:admin/pages/home_page.dart';

class SuccessCart extends StatelessWidget {
  const SuccessCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              // icon
              Image.asset("assets/success.png", height: 150),

              const SizedBox(height: 20),

              // txt 1
              const Text(
                "Success!",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // txt 2
              const Text(
                "Your Product Has Been Successfully Added !!",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),

              const SizedBox(height: 20),

              // Button back to home
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 104, 143, 106),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: const Center(
                    child: Text(
                      'Back To Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
