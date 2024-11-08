import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class SoundSystemDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sound System Details',
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
                  'assets/logo/sound_categories.png',
                  height: 150,
                  width: 150,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Sound System',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'A high-quality sound system can significantly enhance your driving experience. This service includes the installation or upgrade of audio components such as speakers, amplifiers, and head units. Properly installed sound systems provide clear and crisp sound, improved bass response, and a more enjoyable driving experience. Whether you prefer to listen to music or enjoy audio from various sources, a great sound system can make every journey more enjoyable.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: subText,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Benefits of Upgrading Your Sound System:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Enhanced Audio Quality\n'
                '2. Improved Listening Experience\n'
                '3. Better Bass Response\n'
                '4. Greater Audio Clarity\n'
                '5. Customizable Sound Settings',
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
