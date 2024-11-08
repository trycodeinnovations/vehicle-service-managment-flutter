import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String userImage;
  final String userName;
  final String email;
  final String date;
  final String timeSlot;
  final String phoneNumber;
  final String userissue;
  const TaskDetailsScreen({
    Key? key,
    required this.userImage,
    required this.userName,
    required this.email,
    required this.date,
    required this.timeSlot,
    required this.phoneNumber,
    required this.userissue,
  }) : super(key: key);

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isLoading = true;
  Map<String, dynamic>? additionalData;
  List<Map<String, dynamic>> serviceType = [];
  final TextEditingController _costController = TextEditingController();

  bool showSuccessAnimation = false;

  @override
  void initState() {
    super.initState();
    _fetchDetails(widget.email);
  }

  Future<void> _fetchDetails(String email) async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection("serviceReqDetails")
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userQuery.docs.first;

        setState(() {
          additionalData = userDoc.data() as Map<String, dynamic>;
          serviceType = List<Map<String, dynamic>>.from(
              additionalData!['selectedService'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          additionalData = {
            'selectedDeliveryType': 'N/A',
            'isPickupSelected': false
          };
          serviceType = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        additionalData = {
          'selectedDeliveryType': 'Error',
          'isPickupSelected': false
        };
        serviceType = [];
        isLoading = false;
      });
    }
  }

  Future<void> _updateEstimatedCost() async {
    if (_costController.text.isNotEmpty) {
      try {
        QuerySnapshot userQuery = await FirebaseFirestore.instance
            .collection("serviceReqDetails")
            .where('email', isEqualTo: widget.email)
            .get();

        if (userQuery.docs.isNotEmpty) {
          DocumentSnapshot userDoc = userQuery.docs.first;

          await FirebaseFirestore.instance
              .collection("serviceReqDetails")
              .doc(userDoc.id)
              .update({
            'cost': double.parse(_costController.text),
            'status': 'Completed',
            'payment': 'notdone', // Add the new field with the value 'notdone'
          });

          _costController.clear();

          // Close the keyboard
          FocusScope.of(context).unfocus();

          // Show success animation
          setState(() {
            showSuccessAnimation = true;
          });

          // Hide the success animation after 2 seconds
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              showSuccessAnimation = false;
            });
          });

          // Optionally refresh the details after updating
          _fetchDetails(widget.email);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating estimated cost: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a cost.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
      ),
      body: Stack(
        children: [
          // Main content wrapped in SingleChildScrollView
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(widget.userImage),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.email),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('Date: ${widget.date}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text('Time Slot: ${widget.timeSlot}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text('Additional issue: ${widget.userissue}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Bootstrap.whatsapp, color: Colors.green),
                          SizedBox(width: 8),
                          Text(widget.phoneNumber,
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                          'Delivery Type: ${additionalData?['selectedDeliveryType'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text(
                          'Pickup Selected: ${additionalData?['isPickupSelected'] == true ? 'Yes' : 'No'}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text('Selected Services:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      ..._buildSelectedServices(serviceType),
                      SizedBox(height: 20),
                      Text('Enter Estimated Cost:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: _costController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Estimated Cost',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          _updateEstimatedCost();
                          await Navigator.pushReplacementNamed(
                              context, "/mechanicbottomnav");
                        },
                        child: Text('Update Cost'),
                      ),
                    ],
                  ),
          ),

          // Full screen success animation
          if (showSuccessAnimation) ...[
            Container(
              color: Colors.black54, // Overlay color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 100),
                    SizedBox(height: 20),
                    Text(
                      'Success!',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildSelectedServices(List<Map<String, dynamic>> services) {
    if (services.isNotEmpty) {
      return services.map<Widget>((service) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            service['title'] ?? 'Service Title',
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList();
    } else {
      return [Text('No services selected', style: TextStyle(fontSize: 16))];
    }
  }
}
