import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_car_service/style/color.dart'; // Make sure you have the color definition
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart'; // Import Clipboard here

class HelpScreen extends StatelessWidget {
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
                  'You can contact support through the "Contact Us" page or by email at support@example.com.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _contactSupport(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                ),
                child: Text(
                  'Contact Support',
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

  void _contactSupport(BuildContext context) async {
    const email =
        'vaishnavjayaprakash37@gmail.com'; // Replace with your support email
    const phoneNumber = '+1234567890'; // Replace with your support phone number

    final phoneUrl = Uri.parse('tel:$phoneNumber');
    final emailUrl = Uri.parse('mailto:$email?subject=Support Request');

    // Check for phone call permission
    if (await Permission.phone.request().isGranted) {
      // Try to launch the phone URL (dialer)
      if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl);
      } else {
        print('Could not launch phone URL, trying email...');
        // If phone call fails, try launching the email client
        if (await canLaunchUrl(emailUrl)) {
          await launchUrl(emailUrl);
        } else {
          print('Could not launch email URL');
          _showContactDialog(context, phoneNumber, email);
        }
      }
    } else {
      print('Phone permission not granted');
      _showContactDialog(context, phoneNumber, email);
    }
  }

  void _showContactDialog(
      BuildContext context, String phoneNumber, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Phone: $phoneNumber'),
              SizedBox(height: 10),
              Text('Email: $email'),
              SizedBox(height: 10),
              Text(
                  'Please manually copy the contact details if the app could not launch your phone or email client.'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Copy Phone'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: phoneNumber));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Phone number copied to clipboard')));
              },
            ),
            TextButton(
              child: Text('Copy Email'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: email));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email copied to clipboard')));
              },
            ),
          ],
        );
      },
    );
  }
}
