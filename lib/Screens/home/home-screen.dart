import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:rebook_app/Screens/home/tabs/home_tab.dart';
import 'package:rebook_app/Screens/home/tabs/profile_tab.dart';
import 'package:rebook_app/Screens/test.dart';
import 'package:rebook_app/photos/images.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: SizedBox(),
          title: Row(
            children: [
              Image.asset(
                Photos.logo,
                scale: 12,
              ),
              SizedBox(width: 10),
              Text(
                'ReBook',
                style: GoogleFonts.domine(
                  fontSize: 25,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: screens[selectedIndex],
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Color(0xff02457A),
          initialActiveIndex: selectedIndex,
          color: Colors.white,
          height: 65,
          style: TabStyle.reactCircle,
          items: [
            TabItem(icon: Icons.search),
            TabItem(icon: Icons.history),
            TabItem(icon: Icons.home),
            TabItem(icon: Icons.shopping_cart_outlined),
            TabItem(icon: Icons.person),
          ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  List<Widget> screens = [
    Test1(),
    Test2(),
    HomeTab(),
    Test3(),
    ProfileTab(),
  ];
}
