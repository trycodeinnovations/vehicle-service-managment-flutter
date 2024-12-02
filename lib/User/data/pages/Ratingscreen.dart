import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class AppRatingPage extends StatefulWidget {
  const AppRatingPage({super.key});

  @override
  _AppRatingPageState createState() => _AppRatingPageState();
}

class _AppRatingPageState extends State<AppRatingPage> {
  double _rating = 0.0; // For star rating
  final _feedbackController = TextEditingController(); // For feedback text

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
      body: SingleChildScrollView(
        // Add this line
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
            Text(
              'Rate your experience:',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0; // Set the rating
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 16),
            Text(
              'Leave us a message:',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your feedback here...',
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final feedback = _feedbackController.text;
                  _handleFeedback(feedback);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                ),
                child: Text(
                  'Submit Feedback',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFeedback(String feedback) {
    print('User feedback: $_rating stars, Feedback: $feedback');

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

    // Optionally, navigate back or reset the form
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed("/bottom");
    });
  }
}
