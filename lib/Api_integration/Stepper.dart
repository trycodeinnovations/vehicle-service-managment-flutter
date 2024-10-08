import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_stepper/another_stepper.dart';

class RequestStatusStepper extends StatefulWidget {
  @override
  _RequestStatusStepperState createState() => _RequestStatusStepperState();
}

class _RequestStatusStepperState extends State<RequestStatusStepper> {
  List<ServiceRequest> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServiceRequests();
  }

  Future<void> fetchServiceRequests() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(
              'serviceReqDetails') // Adjust this to your Firestore collection name
          .get();

      List<ServiceRequest> fetchedRequests = snapshot.docs.map((doc) {
        String title = doc['email'] ?? 'Untitled';
        String status = doc['status'] ?? 'Pending';

        return ServiceRequest(title: title, status: status);
      }).toList();

      setState(() {
        requests = fetchedRequests;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching service requests: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Request Status'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];

                  // Determine the current step based on status
                  int currentStep;
                  switch (request.status) {
                    case 'Pending':
                      currentStep = 0;
                      break;
                    case 'in progress':
                      currentStep = 1;
                      break;
                    case 'Completed':
                      currentStep = 2;
                      break;
                    default:
                      currentStep = 0; // Default to Pending if unknown
                  }

                  // Define the steps
                  List<StepperData> steps = [
                    StepperData(
                      title: StepperText(
                        "Request Submitted",
                        textStyle: TextStyle(
                          color: currentStep >= 0 ? Colors.green : Colors.grey,
                        ),
                      ),
                      subtitle: StepperText("Your request has been submitted."),
                      iconWidget: _buildStepIcon(currentStep >= 0),
                    ),
                    StepperData(
                      title: StepperText(
                        "In Progress",
                        textStyle: TextStyle(
                          color: currentStep >= 1 ? Colors.green : Colors.grey,
                        ),
                      ),
                      subtitle: StepperText(
                          "Your request is currently being processed."),
                      iconWidget: _buildStepIcon(currentStep >= 1),
                    ),
                    StepperData(
                      title: StepperText(
                        "Completed",
                        textStyle: TextStyle(
                          color: currentStep >= 2 ? Colors.green : Colors.grey,
                        ),
                      ),
                      subtitle: StepperText(
                          "Your service request has been completed."),
                      iconWidget: _buildStepIcon(currentStep >= 2),
                    ),
                    StepperData(
                      title: StepperText(
                        "Feedback",
                        textStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      subtitle: StepperText(
                          "Please provide feedback on our service."),
                      iconWidget: _buildStepIcon(false),
                    ),
                  ];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          AnotherStepper(
                            stepperList: steps,
                            stepperDirection:
                                Axis.vertical, // Keep vertical orientation
                            activeIndex: currentStep,
                            iconWidth: 30, // Set smaller icon width
                            iconHeight: 30, // Set smaller icon height
                            activeBarColor: Colors.green,
                            inActiveBarColor: Colors.grey,
                            barThickness: 6, // Adjust bar thickness if desired
                            verticalGap:
                                20, // Adjust vertical gap between steps
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildStepIcon(bool isActive) {
    return Container(
      padding: const EdgeInsets.all(6), // Adjust padding for smaller icons
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.all(
            Radius.circular(20)), // Smaller radius for a tighter look
      ),
      child:
          Icon(Icons.check, color: Colors.white, size: 16), // Smaller icon size
    );
  }
}

class ServiceRequest {
  final String title;
  final String status;

  ServiceRequest({required this.title, required this.status});
}
