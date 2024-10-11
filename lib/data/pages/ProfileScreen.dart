import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/ProfileGet.dart';
import 'package:flutter_car_service/Api_integration/Stepper.dart';
import 'package:flutter_car_service/Mechanic/pages/pdf.dart';
import 'package:flutter_car_service/data/pages/HelpScreen.dart';
import 'package:flutter_car_service/data/pages/Myaccountscreen.dart';
import 'package:flutter_car_service/data/pages/Navigation.dart';
import 'package:flutter_car_service/data/pages/Ratingscreen.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;

  Future<void> _pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _showLogoutConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_ios_rounded,
          size: 20,
          color: mainColor,
        ),
        title: Text('Profile', style: TextStyle(color: mainColor)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                CircleAvatar(
                    // backgroundImage: _imageFile != null
                    //     ? FileImage(_imageFile!)
                    //     : AssetImage(profiledata['imageurl'] ??
                    //         'assets/images/default_profile.png'), // Default image path
                    ),
                Positioned(
                  right: -12,
                  bottom: 0,
                  child: SizedBox(
                    height: 46,
                    width: 46,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: const Color(0xFFF5F6F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: _pickImage,
                      child: SvgPicture.asset(
                        "assets/images/Camera-add.svg",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileButton("Service Tracker", "assets/images/tracking.png",
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestStatusStepper(),
              ),
            );
          }),
          const SizedBox(height: 20),
          _buildProfileButton(
              "Locate Us", "assets/images/location-sign-svgrepo-com.svg", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Navigation(),
              ),
            );
          }),
          const SizedBox(height: 20),
          _buildProfileButton("Rate Us", "assets/images/rate.png", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(
                  userEmail: '',
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          _buildProfileButton("Help Center", "assets/images/Help.svg", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelpScreen(),
              ),
            );
          }),
          const SizedBox(height: 20),
          _buildProfileButton(
              "Logout", "assets/images/Logout.svg", _showLogoutConfirmation),
        ],
      ),
    );
  }

  Widget _buildProfileButton(
      String title, String iconPath, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: const Color(0xFFF5F6F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            // Use Image.asset for PNG and SvgPicture.asset for SVG
            iconPath.endsWith('.svg')
                ? SvgPicture.asset(
                    iconPath,
                    width: 22,
                    colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                  )
                : Image.asset(
                    iconPath,
                    width: 22,
                    color: mainColor, // Adjust color as needed
                  ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: mainColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: mainColor,
            ),
          ],
        ),
      ),
    );
  }
}
