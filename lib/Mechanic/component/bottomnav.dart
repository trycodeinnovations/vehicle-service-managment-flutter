import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter_car_service/Mechanic/pages/Assignedscreen.dart';
import 'package:flutter_car_service/Mechanic/pages/Homepage.dart';
import 'package:flutter_car_service/Mechanic/pages/Profilescreen.dart';
import 'package:flutter_car_service/style/color.dart';

class BotomMechanic extends StatefulWidget {
  @override
  _BotomMechanicState createState() => _BotomMechanicState();
}

class _BotomMechanicState extends State<BotomMechanic> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MechanicHomePage(), // Screen for Tasks
    AssignedTasksScreen(), // Screen for Notifications
    MechanicProfile(), // Another screen, e.g., Settings or Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CircleNavBar(
        activeIcons: [
          Icon(
            Icons.assignment,
            color: Colors.white,
          ), // Active icon for Tasks
          Icon(
            Icons.notifications,
            color: Colors.white,
          ), // Active icon for Notifications
          Icon(
            Icons.settings,
            color: Colors.white,
          ), // Active icon for another screen
        ],
        inactiveIcons: [
          Icon(
            Icons.assignment_outlined,
            color: Colors.white,
          ), // Inactive icon for Tasks
          Icon(
            Icons.notifications_outlined,
            color: Colors.white,
          ), // Inactive icon for Notifications
          Icon(
            Icons.settings_outlined,
            color: Colors.white,
          ), // Inactive icon for another screen
        ],
        color: mainColor, // Background color   of the nav bar
        activeIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        height: 60.0, // Adjust height if needed
      ),
    );
  }
}
