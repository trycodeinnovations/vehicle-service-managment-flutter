import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import the local notification package

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile; // Variable to store the selected image
  String? _imageUrl; // Variable to store the image URL

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Initialize local notifications

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // Initialize notifications when the screen is loaded
    _loadUserProfile(); // Load current user data on initialization
  }

  // Initialize the notification settings for Android and iOS
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'app_icon'); // Ensure you have an app icon

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Function to show local notification
  Future<void> _showNotification(String title, String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'profile_update_channel', // Channel ID
      'Profile Update', // Channel name
      channelDescription: 'Notifications for profile update',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      message,
      platformChannelSpecifics,
      payload: 'profile_updated',
    );
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser; // Get the current user
    if (user != null) {
      // Use user.email to retrieve the document from Firestore
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.email).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _imageUrl = data['imageurl'] ?? ''; // Fetch image URL
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path); // Set the selected image
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile != null) {
      try {
        // Create a reference to the location you want to upload to in Firebase Storage
        Reference ref =
            _storage.ref().child('user_images/${_auth.currentUser!.uid}.jpg');
        await ref.putFile(_imageFile!); // Upload the file

        // Get the download URL
        String downloadUrl = await ref.getDownloadURL();
        return downloadUrl; // Return the download URL
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return null; // Return null if no image was selected
  }

  Future<void> _saveProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        String? imageUrl;
        // Upload image if a new one is selected
        if (_imageFile != null) {
          imageUrl = await _uploadImage(); // Get the new image URL
        } else {
          imageUrl = _imageUrl; // Use existing image URL if no new image
        }

        await _firestore.collection('users').doc(user.email).update({
          'name': _nameController.text,
          'email': _emailController.text,
          'imageurl': imageUrl, // Update image URL
        });

        // Update user email in Firebase Authentication
        await user.updateEmail(_emailController.text);

        // Optionally update the display name
        await user.updateProfile(displayName: _nameController.text);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );

        // Show the local notification
        _showNotification('Profile Updated',
            'Your profile details have been updated successfully!');

        Navigator.pop(context); // Navigate back after saving
      } on FirebaseAuthException catch (e) {
        // Handle errors related to authentication
        print("Firebase Auth Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update email. Please check the format.')),
        );
      } catch (e) {
        // Handle general errors
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update profile. Please try again.')),
        );
      }
    }
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
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140, // Increased height for the circular avatar
              width: 140, // Increased width for the circular avatar
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    radius: 70, // Increase the radius for the avatar
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
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Email',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
