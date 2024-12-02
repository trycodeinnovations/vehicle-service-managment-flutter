import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';
import 'package:flutter_car_service/Mechanic/pages/profileupdate.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicProfile extends StatelessWidget {
  const MechanicProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(),
              SizedBox(height: 20),
              _buildContactInfo(),
              SizedBox(height: 20),
              _buildAboutSection(),
              SizedBox(height: 20),
              _buildSkillsSection(),
              SizedBox(height: 20),

              _buildUpdateButton(context), // Add the Update button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                currentlogindata['imageUrl'] ?? 'img',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentlogindata[
                        "name" ?? "no name"], // Replace with mechanic's name
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Senior Mechanic",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
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

  Widget _buildContactInfo() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact Information",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(currentlogindata["phone"]),
            Text(currentlogindata["email" ?? "email"]),
            Text("Location: New York, USA"), // Add location
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About Me",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "I am a skilled mechanic with over 5 years of experience in the automotive industry. "
              "I specialize in engine repairs, brake systems, and overall vehicle maintenance.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Skills",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text("• Engine Repair"),
            Text("• Brake Systems"),
            Text("• Suspension Systems"),
            Text("• Electrical Systems"),
            Text("• Diagnostics"),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateProfileScreen(),
          ),
        );
      },
      child: Text(
        "Update Profile",
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w600, color: mainColor),
      ),
    );
  }
}
