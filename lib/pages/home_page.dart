import 'package:admin/components/bottom_nav_bar.dart';
import 'package:admin/components/drawer_list.dart';
import 'package:admin/pages/create_page.dart';
import 'package:admin/pages/intro_page.dart';
import 'package:admin/pages/shop_page.dart';
import 'package:admin/pages/transaksi_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Get.offAll(const IntroPage());
  }

  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const ShopPage(),
    const CreatePage(),
    const TransaksiPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: DrawerList(
        signOutCallback: signUserOut,
      ),
      body: _pages[_selectedIndex],
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }
}
