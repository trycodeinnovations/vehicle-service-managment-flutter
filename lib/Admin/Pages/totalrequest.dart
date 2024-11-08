import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _getRequestsByStatus(String status) async {
    // Fetch requests from Firebase Firestore based on their status
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('serviceReqDetails')
        .where('status', isEqualTo: status)
        .get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<String?> _getCustomerName(String email) async {
    // Fetch customer name from users collection using customerId
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    if (snapshot.exists) {
      final data = snapshot.data(); // Get the data as dynamic
      if (data is Map<String, dynamic>) {
        return data['name'] as String?; // Adjust field name as necessary
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs: Pending, In Progress, Completed
      child: Scaffold(
        appBar: AppBar(
          title: Text('Service Requests'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRequestsList('Pending'),
            _buildRequestsList('In Progress'),
            _buildRequestsList('Completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList(String status) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getRequestsByStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading $status requests.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No $status requests found.'));
        }

        List<Map<String, dynamic>> requests = snapshot.data!;
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            String formattedDate;

            // Format the date from the Firestore Timestamp
            if (request['selectedDate'] is Timestamp) {
              formattedDate = DateFormat('yyyy-MM-dd')
                  .format((request['selectedDate'] as Timestamp).toDate());
            } else if (request['selectedDate'] is String) {
              DateTime parsedDate = DateTime.parse(request['selectedDate']);
              formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
            } else {
              formattedDate = 'Invalid date';
            }

            // Extract service names from the list of maps
            List<String> serviceNames = [];
            if (request['selectedService'] is List<dynamic>) {
              for (var service in request['selectedService']) {
                if (service is Map<String, dynamic> &&
                    service.containsKey('title')) {
                  serviceNames
                      .add(service['title']); // Extract the service name
                }
              }
            }

            // Fetch the customer name using the customer ID
            return FutureBuilder<String?>(
              future: _getCustomerName(
                  request['email'] as String), // Ensure this is a String
              builder: (context, customerSnapshot) {
                if (customerSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return ListTile(
                    title: Text(serviceNames.isNotEmpty
                        ? serviceNames.join(
                            ', ') // Join service names into a single string
                        : 'Unknown Service'),
                    subtitle:
                        Text('Customer: Loading...\nDate: $formattedDate'),
                    leading: CircleAvatar(
                      child: Icon(Icons.receipt),
                    ),
                  );
                } else if (customerSnapshot.hasError) {
                  return ListTile(
                    title: Text(serviceNames.isNotEmpty
                        ? serviceNames.join(', ')
                        : 'Unknown Service'),
                    subtitle: Text(
                        'Customer: Error loading name\nDate: $formattedDate'),
                    leading: CircleAvatar(
                      child: Icon(Icons.receipt),
                    ),
                  );
                } else if (!customerSnapshot.hasData ||
                    customerSnapshot.data == null) {
                  return ListTile(
                    title: Text(serviceNames.isNotEmpty
                        ? serviceNames.join(', ')
                        : 'Unknown Service'),
                    subtitle: Text('Customer: Not found\nDate: $formattedDate'),
                    leading: CircleAvatar(
                      child: Icon(Icons.receipt),
                    ),
                  );
                }

                String customerName = customerSnapshot.data ?? 'Unknown';
                return ListTile(
                  title: Text(serviceNames.isNotEmpty
                      ? serviceNames.join(', ')
                      : 'Unknown Service'),
                  subtitle:
                      Text('Customer: $customerName\nDate: $formattedDate'),
                  leading: CircleAvatar(
                    child: Icon(Icons.receipt),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
