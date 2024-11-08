import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import the local notifications package
import 'package:flutter_car_service/style/color.dart'; // Make sure you have the color definition

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  TextEditingController _issueController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Initialize the notification plugin
    _initializeNotifications();
  }

  // Initialize notifications
  Future<void> _initializeNotifications() async {
    var androidInitialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialization);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: mainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/support.png',
                  height: 150,
                  width: 150,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 35),
              Text(
                'How can we assist you?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Here are some common questions and answers. If you need further assistance, please contact our support team.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: subText,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Common Questions:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildHelpItem('How do I schedule a service?',
                  'You can schedule a service by going to the "Schedule Service" section in the app.'),
              _buildHelpItem('How do I track my service status?',
                  'You can track your service status in the "Service History" section.'),
              _buildHelpItem('How do I contact support?',
                  'You can contact support through the "Contact Us" page or by email at support@gmail.com.'),
              SizedBox(height: 20),
              // TextField for issue description
              TextField(
                controller: _issueController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe your issue...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String issueDescription = _issueController.text;
                  if (issueDescription.isNotEmpty) {
                    createSupportTicket(issueDescription);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please describe the issue.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                ),
                child: Text(
                  'Submit Ticket',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            answer,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: subText,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createSupportTicket(String issueDescription) async {
    try {
      // Reference to the Firestore collection 'support_tickets'
      CollectionReference tickets =
          FirebaseFirestore.instance.collection('support_tickets');

      // Add the new support ticket to Firestore
      await tickets.add({
        'description': issueDescription,
        'status': 'open', // Could be 'open', 'in-progress', 'resolved'
        'created_at': FieldValue.serverTimestamp(),
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket submitted successfully!')),
      );
      _issueController.clear(); // Clear the text field

      // Trigger a local notification
      _showNotification();
    } catch (e) {
      // Handle error (e.g., Firestore issue)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  // Function to show the local notification
  Future<void> _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'support_channel', // Channel ID
      'Support Notifications', // Channel name
      channelDescription: 'Channel for support ticket notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Issue Submitted', // Title
      'Your issue has been submitted. You will receive a response soon.', // Message
      generalNotificationDetails,
    );
  }
}
