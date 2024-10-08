import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class OilChangeDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oil Change Details', style: GoogleFonts.poppins(color:Colors.white
        ),),
         leading: IconButton(onPressed: (){
              Navigator.pop(context);
             },
         icon: Icon(Icons.arrow_back_ios_new_rounded,),
          color: Colors.white,
          
        ),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logo/oil_categories.png',
                height: 150,
                width: 150,
                color: mainColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Oil Change',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Regular oil changes are essential for keeping your vehicle\'s engine running smoothly. This service involves draining the old engine oil, replacing it with fresh oil, and replacing the oil filter. It helps in improving engine performance, reducing engine wear, and enhancing fuel efficiency. Make sure to schedule regular oil changes based on your vehicle manufacturer\'s recommendations.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: subText,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Benefits of Oil Change:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '1. Improved Engine Performance\n'
              '2. Increased Fuel Efficiency\n'
              '3. Reduced Engine Wear\n'
              '4. Enhanced Longevity of Engine Parts\n'
              '5. Lowered Emissions',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: subText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
