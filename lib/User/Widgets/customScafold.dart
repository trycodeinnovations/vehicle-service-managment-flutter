import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart'; // Make sure you import your color definitions

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        color: mainColor, // Set the background color here
        child: SafeArea(
          child: child!,
        ),
      ),
    );
  }
}
