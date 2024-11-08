import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart';

class ServiceRequestDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> servicedata;

  const ServiceRequestDetailsBottomSheet({
    Key? key,
    required this.servicedata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(16.0), // Padding for the bottom sheet
      child: Column(
        mainAxisSize: MainAxisSize.min, // Make the column take minimum height
        children: [
          Text(
            'Service Request Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 16),
          _buildRow('Phone Number',
              servicedata['phoneNumber'] ?? 'Not provided', screenWidth),
          _buildRow(
              'Email', servicedata['email'] ?? 'Not provided', screenWidth),
          _buildRow(
              'Status', servicedata['status'] ?? 'Not specified', screenWidth),
          _buildRow(
              'Cost', servicedata['cost'] ?? 'Not specified', screenWidth),
          _buildRow('Mechanic Name', servicedata['mechanic'] ?? 'Unknown',
              screenWidth),
          _buildRow('Selected Date',
              servicedata['selectedDate'] ?? 'Not specified', screenWidth),
          _buildRow('Selected Time Slot',
              servicedata['selectedTimeSlot'] ?? 'Not specified', screenWidth),
          _buildRow(
              'Selected Services',
              (servicedata['selectedService']
                      ?.map((service) => service['title'])
                      .join(', ') ??
                  'None'),
              screenWidth),
        ],
      ),
    );
  }

  // Helper method to build rows for displaying details
  Widget _buildRow(String label, String value, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.4, // Fixed width for label
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.02), // Space between name and colon
        Text(
          ':', // Colon after label
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: screenWidth * 0.04), // Space between colon and value
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// Method to show the bottom sheet
void showServiceRequestDetailsBottomSheet(
    BuildContext context, Map<String, dynamic> servicedata) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow scrolling if the content is too long
    builder: (context) {
      return ServiceRequestDetailsBottomSheet(servicedata: servicedata);
    },
  );
}
