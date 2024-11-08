import 'package:flutter/material.dart';
import 'package:flutter_car_service/Admin/Pages/Adminhomepage.dart';
import 'package:flutter_car_service/Mechanic/component/bottomnav.dart';
import 'package:flutter_car_service/User/component/bottom_nav.dart';

import 'package:flutter_car_service/User/data/pages/get_started.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Set up animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start animation
    _animationController.forward();

    // Navigate to the GetStarted screen after a delay
    Future.delayed(const Duration(seconds: 5), () async {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? userRole = prefs.getString('userType');
      // if (userRole == 'admin') {
      //   // Navigate to the Admin Home Page

      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //         builder: (context) => AdminDashboard(
      //               title: "",
      //               mainColor: mainColor,
      //             )), // Replace with your actual admin home page
      //   );
      // } else if (userRole == 'mechanics') {
      //   // Navigate to the Mechanic Home Page
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             BotomMechanic()), // Replace with your actual mechanic home page
      //   );
      // } else if (userRole == 'users') {
      //   // Navigate to the Mechanic Home Page
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => BottomNav()),
      //     // Replace with your actual mechanic home page
      //   );
      // } else {
      // If not logged in or role is not recognized, navigate to the GetStarted page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => GetStarted()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  // Optionally add a background image if needed
                  ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeInAnimation,
                      child: Image.asset(
                        'assets/logo/main_logo.png',
                        scale: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: Text(
                      "Premium auto \nrepair shop.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
