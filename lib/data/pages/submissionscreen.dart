import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/ServicedetailsGet.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmissionScreen extends StatelessWidget {
  final List<dynamic> servicedata;
  final DateTime? selectedDate;
  final bool isPickupSelected;
  final String pickupAddress;

  SubmissionScreen({
    required this.servicedata,
    this.selectedDate,
    this.isPickupSelected = false,
    this.pickupAddress = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Submission Details",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selected Services Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Services",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...servicedata.map((service) {
                      return Text(
                        service["selectedService"][0]['title'] ??
                            'No Service Selected',
                        style: GoogleFonts.poppins(fontSize: 14),
                      );
                    }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Service Details Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Details",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Time Slot: ${servicedata.isNotEmpty ? servicedata[0]["selectedTimeSlot"] ?? 'Not Selected' : 'Not Available'}",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Delivery Type: ${servicedata.isNotEmpty ? servicedata[0]["Deliverytype"] ?? 'Not Selected' : 'Not Available'}",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Service Date: ${selectedDate != null ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}" : 'Not Selected'}",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    if (isPickupSelected)
                      Text(
                        "Pickup Address: ${pickupAddress.isNotEmpty ? pickupAddress : 'Not Provided'}",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
