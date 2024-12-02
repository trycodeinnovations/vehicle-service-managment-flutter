import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> ServiceDataGet() async {
  try {
    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) {
      print("User is not logged in.");
      return;
    }

    print("Fetching service details for: $email");

    // Fetch the documents where the email matches
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("serviceReqDetails")
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Clear the previous service data list
      servicedata.clear();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data();

        // Check if data is not null
        // Extract the service details from the document
        Map<String, dynamic> serviceData = {
          'isPickupSelected': data['isPickupSelected'],
          'pickupAddress': data['pickupAddress'],
          'selectedDate': data['selectedDate'],
          'selectedDeliveryType': data['selectedDeliveryType'],
          'selectedService': data['selectedService'],
          'selectedTimeSlot': data['selectedTimeSlot'],
          "status": data['status'],
          "mechanic": data["not assign"],
          "cost": data["estimated"],
          "userissue": data['userissue'],
          "phoneNumber": data['phoneNumber'],
          "email": data["email"],
          "payment": data["notdone"]
        };

        // Add it to the list
        servicedata.add(serviceData);

        print("Service data fetched: $serviceData");
            }
    } else {
      print("No documents found for this user.");
    }
  } catch (e) {
    print("Exception: $e");
  }
}

// List to store the service data
List<Map<String, dynamic>> servicedata = [];
