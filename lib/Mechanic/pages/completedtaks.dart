// CompletedTasksScreen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';

class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("serviceReqDetails")
              .where("status", isEqualTo: "Completed")
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
              return Center(child: Text('No completed tasks.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var task = snapshot.data!.docs[index];
                return _buildTaskCard(
                  task['email'] ?? 'N/A',
                  task['selectedDate']?.toString().split(' ')[0] ?? 'N/A',
                  task['email'], // Use email to fetch user image
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard(String name, String date, String userEmail) {
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
            ? userData['imageurl'] ?? 'default_image_url'
            : 'default_image_url';

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imgPath),
            ),
            title: Text(name),
            subtitle: Text('Date: $date'),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {
              // You can add a navigation to a detailed view if needed
            },
          ),
        );
      },
    );
  }
}
