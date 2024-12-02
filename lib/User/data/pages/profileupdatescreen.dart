import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/main.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false; // Variable to track loading state

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  } // Notification function for Profile Update

  Future<void> _showProfileUpdatedNotification(BuildContext context) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'profile_channel', // Channel ID
      'Profile Notifications', // Channel name
      channelDescription: 'Notifications when profile is updated.',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Profile Updated', // Title
      'Your profile has been updated successfully!', // Body
      platformChannelSpecifics,
      payload: 'profile_updated', // Optional payload
    );
  }

  // Load the current user profile data
  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.email).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _imageUrl = data['imageurl'] ?? '';
        });
      }
    }
  }

  // Pick an image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // Upload image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_imageFile != null) {
      try {
        Reference ref =
            _storage.ref().child('user_images/${_auth.currentUser!.uid}.jpg');
        await ref.putFile(_imageFile!);
        String downloadUrl = await ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        print("Error uploading image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image. Please try again.')),
        );
      }
    }
    return null;
  }

  // Save profile data to Firestore and update FirebaseAuth user email
  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    User? user = _auth.currentUser;
    if (user != null) {
      try {
        String? imageUrl;
        if (_imageFile != null) {
          imageUrl = await _uploadImage();
        } else {
          imageUrl = _imageUrl;
        }

        // Check if email is changed
        if (_emailController.text != user.email) {
          // Send verification email if email is changed
          await user.updateEmail(_emailController.text);
          await user.sendEmailVerification();

          // Inform the user to verify email
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Verification email sent! Please check your inbox to verify your email.'),
            ),
          );

          // Wait for email verification
          await _waitForEmailVerification(user);
        } else {
          // If email is not changed, directly update name and image
          await _updateProfile(user, imageUrl);
          _showProfileUpdatedNotification(context);
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        print("Firebase Auth Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update email. Please check the format.')),
        );
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile. Please try again.')),
        );
      }
    }

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  // Wait for email verification
  Future<void> _waitForEmailVerification(User user) async {
    bool emailVerified = user.emailVerified;

    // Poll for email verification status
    while (!emailVerified) {
      await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
      await user.reload(); // Reload user data
      emailVerified = user.emailVerified;
    }

    // Once email is verified, update profile details
    await _updateProfile(user, _imageUrl);
    Navigator.pop(context);
  }

  // Helper method to update name and image
  Future<void> _updateProfile(User user, String? imageUrl) async {
    await _firestore.collection('users').doc(user.email).update({
      'name': _nameController.text,
      'email': _emailController.text,
      'imageurl': imageUrl,
    });

    // Also update the FirebaseAuth user's displayName
    await user.updateProfile(displayName: _nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: mainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              width: 140,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : _imageUrl != null && _imageUrl!.isNotEmpty
                            ? NetworkImage(_imageUrl!)
                            : AssetImage('assets/images/user.png')
                                as ImageProvider,
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
            Text(
              'Name',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your name',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Email',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Update Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
