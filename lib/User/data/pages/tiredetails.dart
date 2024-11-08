import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class TireDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tire Replacement Details',
            style: GoogleFonts.poppins(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          color: Colors.white,
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo/tire_categories.png',
                  height: 150,
                  width: 150,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tire Replacement',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Tire replacement is a crucial service for maintaining the safety and performance of your vehicle. This service involves removing old, worn-out tires and replacing them with new ones. Properly maintained tires ensure better traction, handling, and overall driving safety. Regular tire checks and replacements help prevent issues such as blowouts and reduce the risk of accidents. Ensure your tires are in good condition by having them inspected and replaced as needed.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: subText,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Benefits of Tire Replacement:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Improved Vehicle Safety\n'
                '2. Better Traction and Handling\n'
                '3. Enhanced Driving Comfort\n'
                '4. Reduced Risk of Tire Blowouts\n'
                '5. Increased Tire Longevity',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: subText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
