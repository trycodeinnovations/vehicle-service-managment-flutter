import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Coordinates for the garage
    final double garageLatitude =
        11.225477612931618; // Replace with your garage's latitude
    final double garageLongitude =
        75.83545205697732; // Replace with your garage's longitude

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Locate Our Garage',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Display the garage SVG image
              Container(
                width: 150, // Adjust width to make it smaller
                height: 150, // Adjust height to make it smaller
                child: SvgPicture.asset(
                    "assets/images/location-sign-svgrepo-com.svg", // Replace with your SVG image path
                    fit: BoxFit.contain,
                    color: Colors.red // Use contain to maintain aspect ratio
                    ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  openGarageInMaps(garageLatitude, garageLongitude);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Change button color to red
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text("Get Directions"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openGarageInMaps(double latitude, double longitude) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url'); // Print the URL for debugging
      throw 'Could not launch $url';
    }
  }
}
