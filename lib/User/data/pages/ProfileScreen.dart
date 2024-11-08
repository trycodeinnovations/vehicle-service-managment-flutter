import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';
import 'package:flutter_car_service/Api_integration/ProfileGet.dart';
import 'package:flutter_car_service/Api_integration/Stepper.dart';
import 'package:flutter_car_service/User/data/pages/HelpScreen.dart';
import 'package:flutter_car_service/User/data/pages/profileupdatescreen.dart';
import 'package:flutter_car_service/User/data/pages/Navigation.dart';
import 'package:flutter_car_service/User/data/pages/Ratingscreen.dart';
import 'package:flutter_car_service/User/data/pages/Review.dart';
import 'package:flutter_car_service/User/data/pages/paymentscreen.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile; // To store the new image file
  bool _isLoading = false; // Track loading state

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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

  // Function to handle image update

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: blackAccent,
          onPressed: () {},
        ),
        title: Text('Profile', style: TextStyle(color: mainColor)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : currentlogindata["imageurl"] != null &&
                                currentlogindata["imageurl"].isNotEmpty
                            ? NetworkImage(currentlogindata["imageurl"])
                            : AssetImage('assets/images/user.png')
                                as ImageProvider,
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
                MaterialPageRoute(builder: (context) => AppRatingPage()),
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

            // Update button
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                color: mainColor,
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 50,
                  child: InkWell(
                    splashColor: subText,
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileUpdateScreen()),
                      );
                    },
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                "Update",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
            iconPath.endsWith('.svg')
                ? SvgPicture.asset(
                    iconPath,
                    width: 22,
                    colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                  )
                : Image.asset(
                    iconPath,
                    width: 22,
                    color: mainColor,
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
            Icon(Icons.arrow_forward_ios_rounded, color: mainColor, size: 20),
          ],
        ),
      ),
    );
  }
}
