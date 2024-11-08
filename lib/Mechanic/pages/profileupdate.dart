import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:firebase_storage/firebase_storage.dart'; // For image upload
import 'package:flutter_svg/flutter_svg.dart'; // For SVG support
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore integration

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  File? _imageFile; // To store the image file after picking
  final ImagePicker _picker = ImagePicker(); // For picking images
  String? currentImageUrl; // To store the current image URL
  String? userEmail; // To store the user's email

  @override
  void initState() {
    super.initState();
    // Fetch current user's data from Firestore
    _fetchCurrentUserData();
  }

  Future<void> _fetchCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email; // Store the user's email
      // Fetch the user's data from Firestore using the email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('mechanics')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        setState(() {
          currentImageUrl = doc[
              'imageurl']; // Assuming you have an imageUrl field in your Firestore document
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
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

  Future<void> _updateProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Validate new password and confirmation password
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("New password and confirmation do not match."),
        ));
        return;
      }

      // Update the image (upload to Firebase Storage if needed)
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('mechanic_images/${user!.uid}.png');
        await ref.putFile(_imageFile!); // Upload the image
        String imageUrl = await ref.getDownloadURL(); // Get the download URL

        // Update the Firestore document with the new image URL
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('mechanics')
            .where('email', isEqualTo: userEmail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentReference docRef = querySnapshot.docs.first.reference;
          await docRef.update({
            'imageurl': imageUrl,
          });
        }
      }

      // Update the password in FirebaseAuth
      if (_newPasswordController.text.isNotEmpty) {
        await user?.updatePassword(_newPasswordController.text);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Profile updated successfully!"),
      ));

      // Pop the screen to return to profile
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update profile: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: SingleChildScrollView(
        // Added this line to make the content scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Update Image",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      radius: 57.5,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (currentImageUrl != null
                                  ? NetworkImage(currentImageUrl!)
                                  : const AssetImage(
                                      "assets/images/default_image.png"))
                              as ImageProvider<
                                  Object>, // Cast to ImageProvider<Object>
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
            ),
            SizedBox(height: 20),
            TextField(
              controller: TextEditingController(
                  text: currentlogindata[
                      "name"]), // Display name inside the TextField
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Mechanic Name",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Update Password",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter current password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter new password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm new password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
