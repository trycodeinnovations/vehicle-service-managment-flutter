import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_car_service/Admin/Pages/ServiceDetails.dart';
import 'package:flutter_car_service/Api_integration/AdminServiceFet.dart';
import 'package:flutter_car_service/Api_integration/TotalMechanicApi.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class ServiceRequestScreen extends StatefulWidget {
  @override
  _ServiceRequestScreenState createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Requests',
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildCustomSlidingSegmentedControl(),
          Expanded(
            child: _buildServiceList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSlidingSegmentedControl() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: CustomSlidingSegmentedControl<int>(
        children: {
          0: Text('Pending',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          1: Text('In Progress',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          2: Text('Completed',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        },
        onValueChanged: (value) {
          setState(() {
            _selectedIndex = value!;
          });
        },
        initialValue: _selectedIndex,
        innerPadding: EdgeInsets.all(5.0),
      ),
    );
  }

  Widget _buildServiceList() {
    return StreamBuilder(
      stream: _getServiceRequestsStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No service requests found.'));
        }

        List<DocumentSnapshot> requests = snapshot.data!.docs;

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            var request = requests[index];
            List<Map<String, dynamic>> serviceType =
                List<Map<String, dynamic>>.from(request['selectedService']);
            var status = request['status'];

            return GestureDetector(
              onTap: () {
                if (status == 'Pending') {
                  // Navigate to service details page
                }
              },
              child: Dismissible(
                key: Key(request.id),
                background: _buildSwipeBackground(),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await _showDeleteConfirmation(context) ?? false;
                },
                onDismissed: (direction) {
                  // Deletes the request from Firestore
                  request.reference.delete();
                  _showToast(context, 'Request deleted');
                },
                child: _buildServiceRequestCard(serviceType, status, request),
              ),
            );
          },
        );
      },
    );
  }

  Stream<QuerySnapshot> _getServiceRequestsStream() {
    CollectionReference serviceRequests =
        FirebaseFirestore.instance.collection('serviceReqDetails');
    if (_selectedIndex == 0) {
      // Pending
      return serviceRequests.where('status', isEqualTo: 'Pending').snapshots();
    } else if (_selectedIndex == 1) {
      // In Progress
      return serviceRequests
          .where('status', isEqualTo: 'in progress')
          .snapshots();
    } else {
      // Completed
      return serviceRequests
          .where('status', isEqualTo: 'Completed')
          .snapshots();
    }
  }

  Widget _buildSwipeBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.delete, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Text('Swipe to delete', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Request'),
        content: Text('Are you sure you want to delete this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildServiceRequestCard(
      List<Map<String, dynamic>> serviceType, String status, alldata) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'Pending':
        statusColor = Colors.red;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'In Progress':
        statusColor = Colors.blue.shade400;
        statusIcon = Icons.build;
        break;
      case 'Completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.error_outline;
    }

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              leading: Icon(statusIcon, color: statusColor, size: 20.0),
              title: Text(
                status,
                style:
                    TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
              children: [
                InkWell(
                  onTap: () {
                    AdminServiceDataGet();
                    TotalMechanics();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ServiceDetailsScreen(all: alldata),
                        ));
                  },
                  child: Container(
                    height: 40,
                    child: ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        title: Text(serviceType[index]['title']),
                      ),
                      itemCount: serviceType.length,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
