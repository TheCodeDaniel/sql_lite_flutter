import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled/pages/edit.dart';
import 'package:untitled/pages/home.dart';

class PageRouter extends StatefulWidget {
  const PageRouter({super.key});

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = const [
    HomePage(),
    EditPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: Container(
          padding: Platform.isIOS ? const EdgeInsets.only(bottom: 20) : null,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 15,
            ),
            child: GNav(
              tabMargin: const EdgeInsets.only(bottom: 0),
              // activeColor: mainColor,
              textStyle: const TextStyle(
                color: Colors.white,
              ),
              // backgroundColor: Colors.white,
              tabBackgroundColor: const Color.fromARGB(10, 33, 37, 41),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              gap: 8,
              selectedIndex: selectedIndex,
              onTabChange: navigateBottomBar,
              tabs: const [
                GButton(
                  backgroundColor: Colors.deepPurple,
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  backgroundColor: Colors.deepPurple,
                  icon: Icons.edit,
                  text: "Edit",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
