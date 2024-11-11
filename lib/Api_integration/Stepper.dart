import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:flutter_car_service/User/data/pages/paymentscreen.dart';
import 'package:flutter_car_service/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
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

  Future<void> showCompletedNotification(ServiceRequest request) async {
    const androidDetails = AndroidNotificationDetails(
      'service_request_channel', // channel ID
      'Service Request Updates', // channel name
      channelDescription: 'Notifications about service request status',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // notification ID
      'Service Request Completed',
      'Your service request for ${request.title} has been completed.',
      notificationDetails,
      payload: 'service_request_completed',
    );
  }

  Future<void> showCompletedNotificationn(ServiceRequest request) async {
    const androidDetails = AndroidNotificationDetails(
      'service_request_channel', // channel ID
      'Service Request Updates', // channel name
      channelDescription: 'Notifications about service request status',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // notification ID
      'Service Request Completed',
      'Your service request for ${request.title} has been completed.',
      notificationDetails,
      payload: 'service_request_completed',
    );
  }

  Future<void> fetchServiceRequests() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'User not logged in';
        });
        return;
      }

      FirebaseFirestore.instance
          .collection('serviceReqDetails')
          .where('email', isEqualTo: userEmail)
          .snapshots()
          .listen((snapshot) {
        List<ServiceRequest> fetchedRequests = snapshot.docs.map((doc) {
          String title = doc.data().containsKey('phoneNumber')
              ? doc['phoneNumber']
              : 'Untitled';
          String email =
              doc.data().containsKey('email') ? doc['email'] : 'Untitled';
          String status =
              doc.data().containsKey('status') ? doc['status'] : 'Pending';
          double cost = doc.data().containsKey('cost')
              ? (doc['cost'] is double
                  ? doc['cost']
                  : double.tryParse(doc['cost'].toString()) ?? 0.0)
              : 0.0;
          String mechanic =
              doc.data().containsKey('mechanic') ? doc['mechanic'] : 'Unknown';
          List<Map<String, dynamic>> selectedService =
              doc.data().containsKey('selectedService')
                  ? List<Map<String, dynamic>>.from(doc['selectedService'])
                  : [];
          String selectedDate = doc.data().containsKey('selectedDate')
              ? doc['selectedDate']
              : 'Not specified';
          String selectedTimeSlot = doc.data().containsKey('selectedTimeSlot')
              ? doc['selectedTimeSlot']
              : 'Not specified';
          String paymentStatus =
              doc.data().containsKey('payment') ? doc['payment'] : 'Pending';

          return ServiceRequest(
            title: title,
            email: email,
            status: status,
            cost: cost,
            mechanic: mechanic,
            selectedService: selectedService,
            selectedDate: selectedDate,
            selectedTimeSlot: selectedTimeSlot,
            paymentStatus: paymentStatus,
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
    final formatter = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 2);

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
                      child: pw.Text(
                        formatter.format(
                            request.cost), // Format the cost as currency
                        style: pw.TextStyle(fontSize: 18, color: PdfColors.red),
                      ),
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
                  child: Text(errorMessage,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)))
              : requests.isEmpty
                  ? Center(
                      child: Text('No active requests',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final request = requests[index];

                          int currentStep;
                          if (request.paymentStatus == 'paymentdone') {
                            currentStep = 3; // Payment completed step
                          } else {
                            switch (request.status) {
                              case 'Pending':
                                currentStep = 0;
                                if (currentStep == 0) {
                                  // _showRequestSubmittedNotification(); // Trigger notification for "Request Submitted"
                                }
                                break;
                              case 'in progress':
                                currentStep = 1;
                                break;
                              case 'Completed':
                                currentStep = 2;
                                if (currentStep == 0) {
                                  showCompletedNotificationn(
                                      request); // Trigger notification for "Request Submitted"
                                }
                                break;
                              default:
                                currentStep = 0;
                            }
                          }

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
                              title: StepperText("Payment",
                                  textStyle: TextStyle(
                                      color: currentStep == 3
                                          ? Colors.green
                                          : Colors.grey)),
                              subtitle: StepperText(currentStep == 3
                                  ? "Payment has been completed!"
                                  : "Please proceed with the payment."),
                              iconWidget: _buildStepIcon(currentStep == 3),
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
                                  if (request.status == 'Completed')
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: ElevatedButton.icon(
                                        onPressed: () => _generatePdf(request),
                                        icon: Icon(Icons.picture_as_pdf,
                                            color: Colors.white),
                                        label: Text('Download INVOICE',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black),
                                      ),
                                    ),
                                  if (request.status == 'Completed')
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Display 'Payment Successful' after payment is done
                                          Visibility(
                                            visible: request.paymentStatus !=
                                                'paymentdone', // Show this text only if payment is not done
                                            child: Text(
                                              'Please make the payment',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          // Display 'Payment Successful' after the payment is completed
                                          if (request.paymentStatus ==
                                              'paymentdone')
                                            Text(
                                              'Payment Successful',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          SizedBox(
                                              height:
                                                  10), // Add some space between the texts

                                          // Hide the "Click me" link when the payment is successful
                                          if (request.paymentStatus !=
                                              'paymentdone')
                                            GestureDetector(
                                              onTap: () {
                                                // Pass the request cost to the PaymentMethodScreen
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentMethodScreen(
                                                            cost: request.cost),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Click me',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                        ],
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
    return Icon(
      isActive ? Icons.check_circle : Icons.radio_button_unchecked,
      color: isActive ? Colors.green : Colors.grey,
    );
  }
}

class ServiceRequest {
  final String title;
  final String email;
  final String status;
  final double cost; // Changed to double
  final String mechanic;
  final List<Map<String, dynamic>> selectedService;
  final String selectedDate;
  final String selectedTimeSlot;
  final String paymentStatus;

  ServiceRequest({
    required this.title,
    required this.email,
    required this.status,
    required this.cost,
    required this.mechanic,
    required this.selectedService,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.paymentStatus,
  });
}
