import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/User/data/pages/tickedscreen.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  TextEditingController _issueController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool hasSubmittedTicket = false;
  String? ticketId;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _checkUserTicket();
  }

  // Initialize notifications
  Future<void> _initializeNotifications() async {
    var androidInitialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialization);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Check if the current user has an open ticket
  Future<void> _checkUserTicket() async {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'unknown';

    // Query Firestore for an open ticket for the current user
    var query = await FirebaseFirestore.instance
        .collection('support_tickets')
        .where('email', isEqualTo: userEmail)
        .where('status', isEqualTo: 'open')
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      setState(() {
        hasSubmittedTicket = true;
        ticketId = query.docs.first.id; // Store the ticket ID
      });
    }
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
              if (!hasSubmittedTicket)
                Column(
                  children: [
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
                            SnackBar(
                                content: Text('Please describe the issue.')),
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
                )
              else
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the TicketDetailsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TicketDetailsScreen(ticketId: ticketId!),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                  ),
                  child: Text(
                    'View Ticket',
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
      String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'unknown';
      CollectionReference tickets =
          FirebaseFirestore.instance.collection('support_tickets');
      var ticketRef = await tickets.add({
        'description': issueDescription,
        'status': 'open',
        'created_at': FieldValue.serverTimestamp(),
        'email': userEmail,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket submitted successfully!')),
      );
      _issueController.clear();

      _showNotification();

      setState(() {
        hasSubmittedTicket = true;
        ticketId = ticketRef.id;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketDetailsScreen(ticketId: ticketId!),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'support_channel',
      'Support Channel',
      channelDescription: 'Channel for support ticket notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Ticket Submitted',
      'Your support ticket has been submitted successfully.',
      notificationDetails,
    );
  }
}
