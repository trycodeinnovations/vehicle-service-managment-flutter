import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleFullServiceDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle Full Service Details',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo/car_categories.png',
                  height: 150,
                  width: 150,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Vehicle Full Service',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'A full vehicle service is a comprehensive maintenance check-up that ensures your vehicle is running at its best. This service typically includes an inspection of all major systems and components, such as the engine, transmission, brakes, suspension, and electrical systems. Additionally, it involves changing the engine oil and filter, checking fluid levels, replacing worn-out parts, and ensuring that all safety features are functioning properly. Regular full services help maintain your vehicle’s performance, enhance safety, and prolong its lifespan.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: subText,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Benefits of Full Vehicle Service:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Enhanced Vehicle Performance\n'
                '2. Increased Safety\n'
                '3. Early Detection of Potential Issues\n'
                '4. Improved Fuel Efficiency\n'
                '5. Extended Vehicle Lifespan\n'
                '6. Reduced Risk of Breakdowns',
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
