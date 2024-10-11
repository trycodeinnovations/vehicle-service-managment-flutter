import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicProfile extends StatelessWidget {
  const MechanicProfile({Key? key}) : super(key: key);

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
              _buildServiceHistorySection(),
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
              radius: 40, // Adjust the size as needed
              backgroundImage: NetworkImage(
                  "https://via.placeholder.com/150"), // Replace with mechanic's image URL
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "John Doe", // Replace with mechanic's name
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Certified Mechanic",
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
            Text("Phone: +1234567890"),
            Text("Email: mechanic@example.com"),
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

  Widget _buildServiceHistorySection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Service History",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text("• Oil Change - 01/10/2024"),
            Text("• Brake Replacement - 15/09/2024"),
            Text("• Engine Diagnostics - 20/08/2024"),
            // Add more service history as needed
          ],
        ),
      ),
    );
  }
}
