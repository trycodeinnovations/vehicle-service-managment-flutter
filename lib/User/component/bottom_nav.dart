import 'package:flutter/material.dart';
import 'package:flutter_car_service/User/data/pages/ProfileScreen.dart';
import 'package:flutter_car_service/User/data/pages/home_pages.dart';
import 'package:flutter_car_service/User/data/pages/service_form.dart';

import 'package:flutter_car_service/style/color.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int pageIndex = 0;

  List<Widget> pages = [
    HomePage(),
    ServiceFormPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: pages[pageIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 5, 20, 20),
        child: buildMyNavBar(context),
      ),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.only(left: 6, right: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: pageIndex == 0 ? Colors.white : Colors.transparent,
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: Icon(
                Icons.home_outlined,
                color: pageIndex == 0 ? mainColor : Colors.white,
                size: 30,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.only(left: 6, right: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: pageIndex == 1 ? Colors.white : Colors.transparent,
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              enableFeedback: false,
              icon: Icon(
                Icons.add_box_outlined,
                color: pageIndex == 1 ? mainColor : Colors.white,
                size: 30,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.only(left: 6, right: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: pageIndex == 2 ? Colors.white : Colors.transparent,
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              enableFeedback: false,
              icon: Icon(
                Icons.account_box_outlined,
                color: pageIndex == 2 ? mainColor : Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
