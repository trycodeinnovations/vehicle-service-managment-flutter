import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/constants/dayGeting.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceDetailsScreen extends StatefulWidget {
  ServiceDetailsScreen({super.key, required this.all});
  final all;

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Service Details', style: GoogleFonts.poppins(fontSize: 24)),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : widget.all != null
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service Details',
                          style: GoogleFonts.poppins(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        _ServiceDetailCard(service: widget.all!),
                      ],
                    ),
                  )
                : Center(child: Text('No service data found.')),
      ),
    );
  }
}

class _ServiceDetailCard extends StatefulWidget {
  final service;

  _ServiceDetailCard({required this.service});

  @override
  __ServiceDetailCardState createState() => __ServiceDetailCardState();
}

class __ServiceDetailCardState extends State<_ServiceDetailCard> {
  String? _selectedMechanic;
  List<String> mechanics = [];
  bool isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _fetchMechanics();
  }

  Future<void> _fetchMechanics() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('mechanics').get();
      setState(() {
        mechanics = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching mechanics: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
                'Email',
                widget.service["email"]
                        .toString()
                        .replaceAll('@gmail.com', '') ??
                    'N/A'),
            _buildDetailRow('Status', widget.service['status'] ?? 'N/A'),
            _buildDetailRow(
              'Selected Date',
              daytime(widget.service['selectedDate'].toString()),
            ),
            SizedBox(height: 20),
            Text('Admin Actions',
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Text('Assign Mechanic:', style: GoogleFonts.poppins(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedMechanic,
              hint: Text('Select a mechanic'),
              isExpanded: true,
              items: mechanics.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMechanic = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (_selectedMechanic != null) {
                        setState(() {
                          isLoading = true; // Set loading to true
                        });

                        String serviceDocumentId = widget.service.id;

                        try {
                          await FirebaseFirestore.instance
                              .collection('serviceReqDetails')
                              .doc(serviceDocumentId)
                              .update({
                            'status': 'in progress',
                            'mechanic': _selectedMechanic,
                          });

                          // Show confirmation message as a quick alert
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Assigned $_selectedMechanic and updated status to "in progress"'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error updating service: $e')),
                          );
                        } finally {
                          setState(() {
                            isLoading = false; // Reset loading state
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a mechanic.')),
                        );
                      }
                    },
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text('Assign Mechanic', style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            if (_selectedMechanic != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Assigned Mechanic: $_selectedMechanic',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(title, style: GoogleFonts.poppins(fontSize: 16))),
          Expanded(
            child: Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
