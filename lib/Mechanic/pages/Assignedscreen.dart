import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';
import 'package:flutter_car_service/Mechanic/pages/FullTaskDetails.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AssignedTasksScreen extends StatefulWidget {
  @override
  _AssignedTasksScreenState createState() => _AssignedTasksScreenState();
}

class _AssignedTasksScreenState extends State<AssignedTasksScreen> {
  List<DocumentSnapshot> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchAssignedTasks();
  }

  Future<void> _fetchAssignedTasks() async {
    try {
      String? name = currentlogindata["name"];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("serviceReqDetails")
          .where("status", isEqualTo: "in progress")
          .where("mechanic", isEqualTo: name)
          .get();

      setState(() {
        tasks = querySnapshot.docs;
      });
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  Future<Map<String, dynamic>> _getUserData(String email) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(email) // Assuming email is the document ID
          .get();
      return userDoc.data() as Map<String, dynamic>;
    } catch (e) {
      print("Error fetching user data: $e");
      return {
        'imageurl': 'default_image_url',
        'name': 'Unknown User'
      }; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assigned Tasks"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: tasks.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  var task = tasks[index];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: _getUserData(task['email'] ?? 'N/A'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error fetching user data.'));
                      }

                      var userData = snapshot.data ?? {};
                      String userImage =
                          userData['imageurl'] ?? 'default_image_url';
                      String userName = userData['name'] ?? 'Unknown User';

                      return _buildTaskCard(
                        userImage,
                        userName,
                        task['email'] ?? 'N/A',
                        task['selectedDate']?.toString().split(' ')[0] ?? 'N/A',
                        task['selectedTimeSlot']?.toString() ?? 'N/A',
                        task['phoneNumber'] ?? 'N/A',
                        task['userissue'] ?? 'N/A',
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _buildTaskCard(String userImage, String userName, String email,
      String date, String timeSlot, String phoneNumber, String userissue) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12), // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16, // Smaller avatar size
                  backgroundImage: NetworkImage(userImage),
                ),
                SizedBox(width: 8), // Space between image and text
                Expanded(
                  child: Text(
                    userName, // Display user name
                    style: TextStyle(
                      fontSize: 14, // Smaller font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              'Email: $email',
              style: TextStyle(
                fontSize: 14, // Smaller font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Date: $date',
              style: TextStyle(
                fontSize: 12, // Smaller font size
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Time Slot: $timeSlot',
              style: TextStyle(
                fontSize: 12, // Smaller font size
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 6),
            Text(
              'User issue: $userissue',
              style: TextStyle(
                fontSize: 12, // Smaller font size
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(Bootstrap.whatsapp,
                      color: Colors.green), // WhatsApp icon
                  onPressed: () {
                    _launchWhatsApp(phoneNumber);
                  },
                ),
                Text(
                  ": $phoneNumber",
                  style: TextStyle(fontSize: 12), // Smaller font size
                ),
              ],
            ),
            SizedBox(height: 6),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskDetailsScreen(
                                  userImage: userImage,
                                  userName: userName,
                                  email: email,
                                  date: date,
                                  timeSlot: timeSlot,
                                  phoneNumber: phoneNumber,
                                  userissue: userissue,)));
                    },
                    icon: Icon(Icons.arrow_forward_ios, size: 15))),
          ],
        ),
      ),
    );
  }

  void _launchWhatsApp(String phoneNumber) async {
    // Ensure phone number is formatted with +91 if not already included
    if (!phoneNumber.startsWith('+')) {
      phoneNumber =
          '+91$phoneNumber'; // Default to India if no country code is present
    }

    final String url =
        "https://wa.me/${phoneNumber.replaceAll(' ', '')}"; // Create WhatsApp URL
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
