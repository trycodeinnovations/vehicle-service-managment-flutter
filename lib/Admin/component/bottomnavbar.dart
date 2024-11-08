import 'package:flutter/material.dart';
import 'package:flutter_car_service/Admin/Pages/Adminhomepage.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:flutter_car_service/User/data/pages/ProfileScreen.dart';
import 'package:flutter_car_service/User/data/pages/home_pages.dart';
import 'package:flutter_car_service/User/data/pages/service_form.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  // Define the list of pages that the bottom navigation will switch between
  final List<Widget> _pages = [
    AdminDashboard(
      title: "title",
      mainColor: mainColor,
    ), // Your ProfileScreen widget
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
            20.0, 5, 20, 20), // Adjust to raise the bar slightly
        child: _buildBottomNavBar(),
      ),
    );
  }

  // This method builds the Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home Page Icon
          _buildNavItem(Icons.home_outlined, 0),
          // Service Form Icon
          _buildNavItem(Icons.add_box_outlined, 1),
          // Profile Page Icon
          _buildNavItem(Icons.account_box_outlined, 2),
        ],
      ),
    );
  }

  // Helper method to create navigation items
  Widget _buildNavItem(IconData icon, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.only(left: 6, right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _currentIndex == index
            ? Colors.white
            : Colors.transparent, // Highlight selected item
      ),
      child: IconButton(
        onPressed: () {
          setState(() {
            _currentIndex = index; // Switch to the tapped page
          });
        },
        icon: Icon(
          icon,
          color: _currentIndex == index
              ? mainColor
              : Colors.white, // Active icon color
          size: 30,
        ),
      ),
    );
  }
}
