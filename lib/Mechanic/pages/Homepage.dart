import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';
import 'package:flutter_car_service/Mechanic/pages/Assignedscreen.dart';
import 'package:flutter_car_service/Mechanic/pages/completedtaks.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class MechanicHomePage extends StatefulWidget {
  @override
  _MechanicHomePageState createState() => _MechanicHomePageState();
}

class _MechanicHomePageState extends State<MechanicHomePage> {
  int totalTasksAssigned = 0;
  int completedTasks = 0;
  int pendingTasks = 0;

  @override
  void initState() {
    super.initState();
    _fetchTaskCounts();
  }

  Future<void> _fetchTaskCounts() async {
    // Get total tasks assigned
    QuerySnapshot assignedTasksSnapshot = await FirebaseFirestore.instance
        .collection("serviceReqDetails")
        .where("mechanic", isEqualTo: currentlogindata["name"])
        .get();

    setState(() {
      totalTasksAssigned = assignedTasksSnapshot.docs.length;
    });

    // Get completed tasks
    QuerySnapshot completedTasksSnapshot = await FirebaseFirestore.instance
        .collection("serviceReqDetails")
        .where("status", isEqualTo: "Completed")
        .where("mechanic", isEqualTo: currentlogindata["name"])
        .get();

    setState(() {
      completedTasks = completedTasksSnapshot.docs.length;
    });

    // Calculate pending tasks
    setState(() {
      pendingTasks = totalTasksAssigned - completedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
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
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to profile settings (if needed)
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
                    color: subText,
                    size: 25,
                  ),
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
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
        Navigator.of(context).pushReplacementNamed('/signin');
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
          SizedBox(height: 20),
          _buildCompletedTasksSection(context, size), // Completed tasks section
        ],
      ),
    );
  }

  Widget _buildSummarySection(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryTile(
            "Total Tasks Assigned", totalTasksAssigned.toString()),
        _buildSummaryTile("Completed Tasks", completedTasks.toString()),
        _buildSummaryTile("Pending Tasks", pendingTasks.toString()),
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

  Widget _buildCompletedTasksSection(BuildContext context, Size size) {
    return InkWell(
      onTap: () {
        // Navigate to the CompletedTasksScreen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompletedTasksScreen()),
        );
      },
      child: Container(
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
            _buildSectionHeader("Completed Tasks", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompletedTasksScreen()),
              );
            }),
            // You can add a FutureBuilder or other widget to display completed tasks here if needed
            SizedBox(height: 10),
            Text(
              "Tap to view completed tasks",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String name, String date, String email) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("users").doc(email).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final userImage = snapshot.data?['imageurl'] ?? 'default_image_url';

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ),
            title: Text(name),
            subtitle: Text("Assigned on: $date"),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, Function onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () => onTap(),
          child: Text(
            "See All",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
