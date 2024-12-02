import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String ticketId;
  final Color mainColorr = mainColor; // Set your primary color here

  TicketDetailsScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(
          //   'Ticket Details',
          //   style: TextStyle(color: Colors.white),
          // ),
          // backgroundColor: mainColorr,
          ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('support_tickets')
            .doc(ticketId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Ticket not found.'));
          }

          var ticketData = snapshot.data!.data() as Map<String, dynamic>;
          bool isClosed = ticketData['status'] == 'closed';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildInfoSection(
                    'Issue Description:', ticketData['description'],
                    isBordered: true),
                _buildInfoSection('Status:', ticketData['status'],
                    isBold: true),
                _buildInfoSection(
                    'Created At:', ticketData['created_at'].toDate().toString(),
                    fontSize: 14),
                SizedBox(height: 20),
                if (isClosed) ...[
                  _buildInfoSection('Admin Reply:',
                      ticketData['admin_reply'] ?? 'No reply yet',
                      isBold: false),
                  SizedBox(height: 20),
                ],
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/bottom');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColorr,
                  ),
                  child: Text(
                    'Go to Home',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, String value,
      {bool isBold = false, double fontSize = 16, bool isBordered = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          isBordered
              ? Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
        ],
      ),
    );
  }
}
