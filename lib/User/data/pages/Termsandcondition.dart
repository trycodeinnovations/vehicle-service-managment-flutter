import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsPage extends StatelessWidget {
  // Define your mainColor here or use your app's theme
  final Color mainColor =
      const Color(0xff172D48);

  const TermsAndConditionsPage({super.key}); // Replace with your desired color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to Our Garage!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Please read the following terms and conditions carefully before using our services.',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 20.0),
            Text(
              'Terms and Conditions:',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            _buildTerm('1. All services are provided as-is.'),
            _buildTerm(
                '2. The garage is not responsible for any damages or losses incurred during service.'),
            _buildTerm('3. Payment is due upon completion of services.'),
            _buildTerm(
                '4. Customers must pick up their vehicles within 24 hours after service completion.'),
            _buildTerm(
                '5. Any modifications to the vehicle must be approved in advance.'),
            _buildTerm(
                '6. We reserve the right to refuse service to anyone for any reason.'),
            _buildTerm(
                '7. Customers must provide accurate information regarding their vehicle for service.'),
            _buildTerm(
                '8. The garage is not liable for any items left in the vehicle.'),
            _buildTerm(
                '9. Estimates provided are subject to change based on additional repairs required.'),
            _buildTerm(
                '10. Any warranty on parts installed is subject to the manufacturer’s terms.'),
            _buildTerm(
                '11. Customers are responsible for their own transportation during the service.'),
            _buildTerm(
                '12. All services may be subject to a diagnostic fee, which may be waived upon service completion.'),
            // Add more terms as needed

            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor, // Use mainColor
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(
                  'Accept',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Close the page or navigate back
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(
                  'Decline',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTerm(String term) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check,
              size: 20, color: mainColor), // Use mainColor for the icon
          SizedBox(width: 8),
          Expanded(
            child: Text(
              term,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
