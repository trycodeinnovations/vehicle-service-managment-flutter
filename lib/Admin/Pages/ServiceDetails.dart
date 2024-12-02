import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_car_service/constants/dayGeting.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key, required this.all});
  final all;

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Service Details', style: GoogleFonts.poppins(fontSize: 24)),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : widget.all != null
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service Details',
                          style: GoogleFonts.poppins(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        _ServiceDetailCard(service: widget.all!),
                      ],
                    ),
                  )
                : Center(child: Text('No service data found.')),
      ),
    );
  }
}

class _ServiceDetailCard extends StatefulWidget {
  final service;

  const _ServiceDetailCard({required this.service});

  @override
  __ServiceDetailCardState createState() => __ServiceDetailCardState();
}

class __ServiceDetailCardState extends State<_ServiceDetailCard> {
  String? _selectedMechanic;
  List<String> mechanics = [];
  bool isLoading = false;

  // Flutter local notifications plugin initialization
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchMechanics();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _sendInProgressNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'service_request_channel',
      'Service Request Notifications',
      channelDescription: 'Notifications for service request status changes.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Request In Progress', // Title
      'Your service request has been submitted successfully and is now in progress.',
      platformChannelSpecifics,
      payload: 'service_request_inprogress',
    );
  }

  Future<void> _fetchMechanics() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('mechanics').get();
      setState(() {
        mechanics = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching mechanics: $e");
    }
  }

  Future<void> _updateServiceStatus() async {
    if (_selectedMechanic != null) {
      setState(() {
        isLoading = true;
      });

      String serviceDocumentId = widget.service.id;

      try {
        // Update the service request details in Firestore
        await FirebaseFirestore.instance
            .collection('serviceReqDetails')
            .doc(serviceDocumentId)
            .update({
          'status': 'in progress', // Update the status
          'mechanic': _selectedMechanic, // Assign the mechanic
          'payment': 'notdone', // Add the payment field and set it to 'notdone'
        });

        // Send notification to user
        await _sendInProgressNotification();

        // Show confirmation message as a quick alert
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Assigned $_selectedMechanic, updated status to "in progress" and payment to "notdone"'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating service: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a mechanic.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
                'Email',
                widget.service["email"]
                        .toString()
                        .replaceAll('@gmail.com', '') ??
                    'N/A'),
            _buildDetailRow('Status', widget.service['status'] ?? 'N/A'),
            _buildDetailRow(
              'Selected Date',
              daytime(widget.service['selectedDate'].toString()),
            ),
            SizedBox(height: 20),
            Text('Admin Actions',
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Text('Assign Mechanic:', style: GoogleFonts.poppins(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedMechanic,
              hint: Text('Select a mechanic'),
              isExpanded: true,
              items: mechanics.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMechanic = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _updateServiceStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text('Assign Mechanic', style: GoogleFonts.poppins()),
            ),
            SizedBox(height: 20),
            if (_selectedMechanic != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Assigned Mechanic: $_selectedMechanic',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(title, style: GoogleFonts.poppins(fontSize: 16))),
          Expanded(
            child: Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
