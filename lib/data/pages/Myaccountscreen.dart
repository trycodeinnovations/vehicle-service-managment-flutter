import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_car_service/style/color.dart';

class MyAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Account',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service History',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: _buildServiceHistoryList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildServiceHistoryList() {
    // This is sample data. Replace with actual service history data from your model.
    final List<Map<String, String>> serviceHistory = [
      {
        'service': 'Oil Change',
        'date': '2024-08-15',
        'details': 'Changed engine oil and filter.',
      },
      {
        'service': 'Tire Replacement',
        'date': '2024-07-20',
        'details': 'Replaced all four tires.',
      },
      // Add more entries as needed
    ];

    return serviceHistory.map((entry) {
      return Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            entry['service']!,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Date: ${entry['date']}\nDetails: ${entry['details']}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: subText,
            ),
          ),
        ),
      );
    }).toList();
  }
}
