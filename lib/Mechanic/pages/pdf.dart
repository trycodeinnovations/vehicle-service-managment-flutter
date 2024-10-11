import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String userEmail;

  const TaskDetailsScreen({Key? key, required this.userEmail})
      : super(key: key);

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isLoading = true;
  Map<String, dynamic>? taskData;
  List<Map<String, dynamic>> serviceType = [];
  final TextEditingController _costController = TextEditingController();
  bool showSuccessAnimation = false;

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails(widget.userEmail);
  }

  Future<void> _fetchTaskDetails(String email) async {
    try {
      // Fetch task details directly from the Firebase Firestore
      DocumentSnapshot taskDoc = await FirebaseFirestore.instance
          .collection("serviceReqDetails")
          .doc(email) // Assuming email is used as the document ID
          .get();

      if (taskDoc.exists) {
        setState(() {
          taskData = taskDoc.data() as Map<String, dynamic>;
          serviceType = List<Map<String, dynamic>>.from(
              taskData!['selectedService'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          taskData = {};
          serviceType = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        taskData = {};
        serviceType = [];
        isLoading = false;
      });
    }
  }

  Future<void> _updateEstimatedCost() async {
    if (_costController.text.isNotEmpty) {
      try {
        // Update the estimated cost in the Firebase Firestore
        await FirebaseFirestore.instance
            .collection("serviceReqDetails")
            .doc(widget.userEmail) // Assuming email is used as the document ID
            .update({
          'cost': double.parse(_costController.text),
          'status': 'Completed',
        });

        _costController.clear();

        // Close the keyboard
        FocusScope.of(context).unfocus(); // Dismiss the keyboard

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

        // Refresh the details after updating
        _fetchTaskDetails(widget.userEmail);
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

  Future<void> _generatePdf() async {
    // Check if the status is "Completed" before generating the PDF
    if (taskData?['status'] == 'Completed') {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Invoice', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('User Email: ${widget.userEmail}'),
                pw.Text('Date: ${taskData?['date'] ?? 'N/A'}'),
                pw.Text('Time Slot: ${taskData?['timeSlot'] ?? 'N/A'}'),
                pw.Text('Estimated Cost: ${taskData?['cost'] ?? 'N/A'}'),
                pw.Text('Status: ${taskData?['status'] ?? 'N/A'}'),
                pw.SizedBox(height: 20),
                pw.Text('Selected Services:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ..._buildSelectedServicesPdf(serviceType),
              ],
            );
          },
        ),
      );

      // Save the PDF file
      final Uint8List bytes = await pdf.save();
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
    } else {
      // Show a message if the status is not "Completed"
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('PDF can only be generated if the status is Completed.')),
      );
    }
  }

  List<pw.Widget> _buildSelectedServicesPdf(
      List<Map<String, dynamic>> services) {
    if (services.isNotEmpty) {
      return services.map<pw.Widget>((service) {
        return pw.Text(service['title'] ?? 'Service Title');
      }).toList();
    } else {
      return [pw.Text('No services selected')];
    }
  }

  List<Widget> _buildSelectedServices(List<Map<String, dynamic>> services) {
    if (services.isNotEmpty) {
      return services.map<Widget>((service) {
        return ListTile(
          title: Text(service['title'] ?? 'Service Title'),
          subtitle: Text('Cost: ${service['cost'] ?? 'N/A'}'),
        );
      }).toList();
    } else {
      return [Text('No services selected')];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf,
          ),
        ],
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
                      Text('User Email: ${widget.userEmail}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 16),
                      Text('Date: ${taskData?['date'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16)),
                      Text('Time Slot: ${taskData?['timeSlot'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text('Estimated Cost: ${taskData?['cost'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16)),
                      Text('Status: ${taskData?['status'] ?? 'N/A'}',
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
                        onPressed: _updateEstimatedCost,
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
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Cost Updated Successfully!',
                      style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
