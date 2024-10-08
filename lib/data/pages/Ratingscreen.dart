import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class AppRatingPage extends StatefulWidget {
  @override
  _AppRatingPageState createState() => _AppRatingPageState();
}

class _AppRatingPageState extends State<AppRatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rate the App',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/logo/main_logo.png',
                height: 150,
                width: 150,
                color: mainColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'How would you rate our app?',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Please take a moment to rate the app. Your feedback helps us improve!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: subText,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showCustomEmojiFeedbackDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
              ),
              child: Text(
                'Rate Now',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomEmojiFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Rate this app',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please select an emoji to rate our app.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Text('😠', style: TextStyle(fontSize: 30)),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _handleFeedback('Very Bad');
                        },
                      ),
                      Text(
                        'Very Bad',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Text('😐', style: TextStyle(fontSize: 30)),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _handleFeedback('Neutral');
                        },
                      ),
                      Text(
                        'Neutral',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Text('😍', style: TextStyle(fontSize: 30)),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _handleFeedback('Excellent');
                        },
                      ),
                      Text(
                        'Excellent',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleFeedback(String feedback) {
    print('User feedback: $feedback');

    // Show thank you message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thank you for your feedback!',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        backgroundColor: mainColor,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to the homepage
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed("/bottom");
    });
  }
}
