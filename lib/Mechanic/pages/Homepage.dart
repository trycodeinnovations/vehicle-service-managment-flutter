import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';
import 'package:flutter_car_service/Mechanic/pages/Assignedscreen.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class MechanicHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          // title: Text("Assigned Work"),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        currentlogindata['imageUrl'] ?? 'img',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentlogindata['name'] ?? 'No Name',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Sr Mechanic",
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
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: subText, // Set the color for the logout icon
                    size: 25,
                  ),
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Remove the ElevatedButton for Logout, as we are using the icon instead
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: "Logout",
      text: "Are you sure you want to logout?",
      confirmBtnText: "Yes",
      cancelBtnText: "No",
      onConfirmBtnTap: () {
        // Perform the logout action here
        // For example, clear user session or navigate to the login screen
        Navigator.of(context)
            .pushReplacementNamed('/signin'); // Adjust navigation as needed
      },
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
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("serviceReqDetails")
                .where("status", isEqualTo: "in progress")
                .where("mechanic", isEqualTo: currentlogindata["name"])
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No assigned tasks.'));
              }

              return Container(
                height: size.height * 0.25,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var task = snapshot.data!.docs[index];
                    return _buildTaskCard(
                      task['email'] ?? 'N/A',
                      task['selectedDate']?.toString().split(' ')[0] ?? 'N/A',
                      task['email'], // Use email to fetch user image
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String email, String date, String userEmail) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection("users").doc(userEmail).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error fetching user image.'));
        }

        var userData = snapshot.data;
        String imgPath = userData != null && userData.exists
            ? userData['imageurl'] ??
                'default_image_url' // Replace with your default image URL
            : 'default_image_url'; // Fallback image if user not found

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imgPath),
            ),
            title: Text(email),
            subtitle: Text('Date: $date'),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {
              // Handle task details navigation
            },
          ),
        );
      },
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
