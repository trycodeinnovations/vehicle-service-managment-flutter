import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FinishedRequestsScreen extends StatelessWidget {
  const FinishedRequestsScreen({super.key});

  Future<List<Map<String, dynamic>>> _getFinishedRequests() async {
    // Fetch finished requests from Firebase Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('serviceReqDetails')
        .where('status', isEqualTo: 'Completed')
        .get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<Map<String, dynamic>?> _getUserDataByEmail(String email) async {
    // Fetch user data from the users collection using the email
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1) // Limit to one document
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs[0].data() as Map<String, dynamic>;
    }
    return null; // Return null if the user does not exist
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Requests'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getFinishedRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading requests'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No completed requests found.'));
          }

          // Display the list of completed requests
          List<Map<String, dynamic>> requests = snapshot.data!;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              String formattedDate;

              // Check the type of selectedDate and format accordingly
              if (request['selectedDate'] is Timestamp) {
                formattedDate = DateFormat('yyyy-MM-dd')
                    .format((request['selectedDate'] as Timestamp).toDate());
              } else if (request['selectedDate'] is String) {
                DateTime parsedDate = DateTime.parse(request['selectedDate']);
                formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
              } else {
                formattedDate = 'Invalid date';
              }

              // Fetch user data using the email from the request
              String email = request[
                  'email']; // Adjust the key according to your data structure
              return FutureBuilder<Map<String, dynamic>?>(
                future: _getUserDataByEmail(email),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Service: Loading...'),
                      subtitle: Text('Customer: ${request['name']}'),
                      trailing: Text('Date: $formattedDate'),
                      leading: CircularProgressIndicator(),
                    );
                  } else if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Service: Error'),
                      subtitle: Text('Customer: ${request['name']}'),
                      trailing: Text('Date: $formattedDate'),
                      leading: Icon(Icons.error), // Indicate an error
                    );
                  }

                  // Retrieve user data
                  final userData = userSnapshot.data;

                  // Extract the list of selected services
                  List<dynamic> selectedServices = request['selectedService'] ??
                      []; // Ensure it defaults to empty

                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the list of selected services
                        Text('Services:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        for (var service in selectedServices)
                          Text(
                            ' - ${service['title']}', // Adjust the key as per your data structure
                            style: TextStyle(fontSize: 14),
                          ),
                      ],
                    ),
                    subtitle: Text(
                        'Customer: ${userData?['name'] ?? request['name']}'),
                    trailing: Text('Date: $formattedDate'),
                    leading: userData != null && userData['imageurl'] != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(userData['imageurl']),
                          )
                        : CircleAvatar(
                            child:
                                Icon(Icons.person), // Default icon if no image
                          ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
