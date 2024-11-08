import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_car_service/Api_integration/Stepper.dart';
import 'package:flutter_car_service/User/data/pages/Addcard.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double cost; // Add the cost parameter to the constructor

  PaymentMethodScreen({required this.cost}); // Constructor to receive the cost

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? _userEmail;
  String? _selectedPaymentMethod;
  bool _cardAdded = false; // Track if a card has been added
  DocumentReference? _serviceDocument; // Store the service document reference

  final List<Map<String, dynamic>> _paymentOptions = [
    {'title': 'Google Pay', 'icon': Bootstrap.google_play},
    {'title': 'PayPal', 'icon': Bootstrap.paypal},
    {'title': 'Cash on delivery', 'icon': Bootstrap.cash_coin},
    {'title': 'Apple Pay', 'icon': Bootstrap.apple},
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchCompletedServiceCost();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);
  }

  // Notification callback to handle notification tap
  Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      debugPrint('Notification tapped with payload: $payload');
      // You can add custom behavior here (e.g., navigate to a different screen)
    }
  }

  Future<void> _fetchCompletedServiceCost() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        _userEmail = currentUser.email;

        if (_userEmail != null) {
          QuerySnapshot querySnapshot = await _firestore
              .collection('serviceReqDetails')
              .where('email', isEqualTo: _userEmail)
              .where('status', isEqualTo: 'Completed')
              .where('payment',
                  isEqualTo: 'notdone') // Check if payment is pending
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
            _serviceDocument =
                documentSnapshot.reference; // Store the document reference
          }
        }
      }
    } catch (e) {
      print('Error fetching cost: $e');
    }
  }

  // Notification function
  Future<void> _showPaymentCompletedNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'payment_channel', // Channel ID
      'Payment Notifications', // Channel name
      channelDescription: 'Notifications when payment status is updated.',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Payment Completed', // Title
      'Your payment has been processed successfully!', // Body
      platformChannelSpecifics,
      payload: 'payment_done',
    );
  }

  Future<void> _updatePaymentStatus() async {
    try {
      if (_serviceDocument != null) {
        // Update the payment status to 'paymentdone' in Firestore
        await _serviceDocument!.update({
          'payment': 'paymentdone', // Updated payment status
          'paymentMethod':
              _selectedPaymentMethod, // Optionally store the selected payment method
        });

        // Show success dialog after updating payment status
        _showSuccessDialog();

        // Show the notification
        await _showPaymentCompletedNotification();

        // Navigate to Stepper page after payment success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RequestStatusStepper()),
        );
      }
    } catch (e) {
      print('Error updating payment status: $e');
      _showErrorDialog(); // Show error dialog if update fails
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Payment Method'),
          content: Text('Do you want to proceed with $_selectedPaymentMethod?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _updatePaymentStatus(); // Update payment status after confirmation
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Payment processed successfully!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please select a payment method!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method',
            style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the cost passed in
            Text(
              'Amount to be Paid: ₹${widget.cost.toStringAsFixed(2)}', // Use widget.cost here
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _paymentOptions.length,
                itemBuilder: (context, index) {
                  return _buildPaymentOption(
                    _paymentOptions[index]['title'],
                    _paymentOptions[index]['icon'],
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNewCardScreen()),
                );
                if (result == true) {
                  setState(() {
                    _cardAdded = true;
                  });
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    _cardAdded ? 'Pay with Card' : 'Add New Card',
                    style: GoogleFonts.poppins(),
                  ),
                  trailing: Icon(Icons.add, color: Colors.black),
                ),
              ),
            ),
            if (widget.cost != null)
              Text(
                'Subtotal: ₹${widget.cost.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedPaymentMethod != null) {
                    _showConfirmationDialog();
                  } else {
                    _showErrorDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Proceed to Pay',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: ListTile(
        title: Text(title, style: GoogleFonts.poppins()),
        leading: Icon(icon, size: 32),
        onTap: () {
          setState(() {
            _selectedPaymentMethod = title;
          });
        },
        selected: _selectedPaymentMethod == title,
        selectedTileColor: Colors.blue.shade50,
      ),
    );
  }
}
