import 'package:flutter/material.dart';
import 'package:flutter_car_service/Mechanic/pages/Assignedscreen.dart'; // Ensure this import points to your AssignedTasksScreen
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Assigned Work"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildProfileSection(context),
            SizedBox(height: 20),
            _buildTasksSection(context, size),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return InkWell(
      onTap: () {
        // Uncomment to navigate to ProfileScreen
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                ),
                // Uncomment and replace with actual image URL
                // Image.network(
                //   profileData['imageurl'] ?? 'https://via.placeholder.com/40',
                //   width: 40,
                //   fit: BoxFit.cover,
                // ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Uncomment and replace with actual name
                    // Text(
                    //   profileData['name'] ?? 'No Name',
                    //   style: GoogleFonts.poppins(
                    //     color: Colors.black,
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    Text(
                      "Sr Mechanic ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.notifications_outlined,
              color: subText,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksSection(BuildContext context, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Column(
        children: [
          SizedBox(height: 25),
          _buildSummarySection(size),
          SizedBox(height: 20),
          _buildAssignedTasksSection(context, size),
        ],
      ),
    );
  }

  Widget _buildSummarySection(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryTile("Total Tasks Assigned", "5"),
        _buildSummaryTile("Completed Tasks", "3"),
        _buildSummaryTile("Pending Tasks", "2"),
      ],
    );
  }

  Widget _buildSummaryTile(String title, String value) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(fontSize: 24, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignedTasksSection(BuildContext context, Size size) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Assigned Tasks", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssignedTasksScreen()),
            );
          }),
          Container(
            height: size.height * 0.25,
            child: ListView(
              children: [
                _buildTaskCard("Oil Change", "Due: Today",
                    "assets/logo/oil_categories.png"),
                _buildTaskCard("Brake Repair", "Due: Tomorrow",
                    "assets/logo/oil_categories.png"),
                _buildTaskCard("Tire Rotation", "Due: In 2 days",
                    "assets/logo/oil_categories.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String title, String subtitle, String imgPath) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(imgPath, width: 50, height: 50),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
        ),
        onTap: () {
          // Handle task details
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAllPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.5,
          ),
        ),
        InkWell(
          onTap: onSeeAllPressed,
          child: Text(
            "See all",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

// Note: Don't forget to define the AssignedTasksScreen in your app.
