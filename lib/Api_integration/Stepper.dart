import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class RequestStatusStepper extends StatefulWidget {
  @override
  _RequestStatusStepperState createState() => _RequestStatusStepperState();
}

class _RequestStatusStepperState extends State<RequestStatusStepper> {
  List<ServiceRequest> requests = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchServiceRequests();
  }

  Future<void> fetchServiceRequests() async {
    try {
      FirebaseFirestore.instance
          .collection('serviceReqDetails')
          .snapshots()
          .listen((snapshot) {
        List<ServiceRequest> fetchedRequests = snapshot.docs.map((doc) {
          print('Document data: ${doc.data()}'); // Log document data

          String title = doc.data().containsKey('phoneNumber')
              ? doc['phoneNumber']
              : 'Untitled';
          String email =
              doc.data().containsKey('email') ? doc['email'] : 'Untitled';

          String status =
              doc.data().containsKey('status') ? doc['status'] : 'Pending';
          String cost = doc.data().containsKey('cost')
              ? doc['cost']?.toString() ?? 'cost'
              : 'cost';
          String mechanic =
              doc.data().containsKey('mechanic') ? doc['mechanic'] : 'Unknown';

          List<Map<String, dynamic>> selectedService =
              doc.data().containsKey('selectedService')
                  ? List<Map<String, dynamic>>.from(doc['selectedService'])
                  : []; // Updated to handle list of maps

          // Log the selectedService to see its content
          print('Selected service: $selectedService');

          String selectedDate = doc.data().containsKey('selectedDate')
              ? doc['selectedDate']
              : 'Not specified';
          String selectedTimeSlot = doc.data().containsKey('selectedTimeSlot')
              ? doc['selectedTimeSlot']
              : 'Not specified';

          return ServiceRequest(
            title: title,
            email: email,
            status: status,
            cost: cost,
            mechanic: mechanic,
            selectedService: selectedService,
            selectedDate: selectedDate,
            selectedTimeSlot: selectedTimeSlot,
          );
        }).toList();

        setState(() {
          requests = fetchedRequests;
          isLoading = false;
        });
      });
    } catch (e) {
      print("Error fetching service requests: $e");
      setState(() {
        isLoading = false;
        errorMessage =
            'Error fetching service requests. Please try again later.';
      });
    }
  }

  Future<void> _generatePdf(ServiceRequest request) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(16.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Field',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Details',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Contact Number',
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(request.title,
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child:
                          pw.Text('Email', style: pw.TextStyle(fontSize: 18)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(request.email,
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child:
                          pw.Text('Status', style: pw.TextStyle(fontSize: 18)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(request.status,
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Cost',
                          style: pw.TextStyle(
                            fontSize: 18,
                          )),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(request.cost,
                          style:
                              pw.TextStyle(fontSize: 18, color: PdfColors.red)),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Mechanic Name',
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(request.mechanic,
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Selected Services',
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        request.selectedService
                            .map((service) => service['title'] ?? 'Unknown')
                            .join(', '),
                        style: pw.TextStyle(fontSize: 18),
                      ),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Selected Date',
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(request.selectedDate,
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Selected TimeSlot',
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(request.selectedTimeSlot,
                          style: pw.TextStyle(fontSize: 18)),
                    ),
                  ]),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Thank you for choosing CrewsAuto!', // Thank you message
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(
                  'We appreciate your business and look forward to serving you again!',
                  style: pw.TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Request Status'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )
              : requests.isEmpty
                  ? Center(
                      child: Text(
                        'No active requests',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
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
                              title: StepperText("Request Submitted",
                                  textStyle: TextStyle(
                                      color: currentStep >= 0
                                          ? Colors.green
                                          : Colors.grey)),
                              subtitle: StepperText(
                                  "Your request has been submitted."),
                              iconWidget: _buildStepIcon(currentStep >= 0),
                            ),
                            StepperData(
                              title: StepperText("In Progress",
                                  textStyle: TextStyle(
                                      color: currentStep >= 1
                                          ? Colors.green
                                          : Colors.grey)),
                              subtitle: StepperText(
                                  "Your request is currently being processed."),
                              iconWidget: _buildStepIcon(currentStep >= 1),
                            ),
                            StepperData(
                              title: StepperText("Completed",
                                  textStyle: TextStyle(
                                      color: currentStep >= 2
                                          ? Colors.green
                                          : Colors.grey)),
                              subtitle: StepperText(
                                  "Your service request has been completed."),
                              iconWidget: _buildStepIcon(currentStep >= 2),
                            ),
                            StepperData(
                              title: StepperText("Feedback",
                                  textStyle: TextStyle(color: Colors.grey)),
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
                                    request.email,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  AnotherStepper(
                                    stepperList: steps,
                                    stepperDirection: Axis.vertical,
                                    activeIndex: currentStep,
                                    iconWidth: 30,
                                    iconHeight: 30,
                                    activeBarColor: Colors.green,
                                    inActiveBarColor: Colors.grey,
                                    barThickness: 6,
                                    verticalGap: 20,
                                  ),
                                  // Show PDF download icon if the status is completed
                                  if (request.status == 'Completed')
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: ElevatedButton.icon(
                                        onPressed: () => _generatePdf(request),
                                        icon: Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Download INVOICE',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                        ),
                                      ),
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

class ServiceRequest {
  final String title;
  final String email;
  final String status;
  final String cost;
  final String mechanic; // New field
  final List<Map<String, dynamic>> selectedService; // Updated to a list of maps
  final String selectedDate; // New field
  final String selectedTimeSlot; // New field

  ServiceRequest({
    required this.title,
    required this.email,
    required this.status,
    required this.cost,
    required this.mechanic,
    required this.selectedService,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });
}
