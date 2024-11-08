import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> AdminServiceDataGet() async {
  try {
    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) {
      print("User is not logged in.");
      return;
    }

    print("Fetching service details for: $email");

    // Fetch the documents where the email matches
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("serviceReqDetails").get();

    if (querySnapshot.docs.isNotEmpty) {
      // Clear the previous service data list
      servicedata.clear();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data();

        // Check if data is not null
        if (data != null) {
          // Extract the service details from the document
          Map<String, dynamic> serviceData = {
            'isPickupSelected': data['isPickupSelected'],
            'pickupAddress': data['pickupAddress'],
            'selectedDate': data['selectedDate'],
            'selectedDeliveryType': data['selectedDeliveryType'],
            'selectedService': data['selectedService'],
            'selectedTimeSlot': data['selectedTimeSlot'],
            "userissue": data['userissue'],
          };

          // Add it to the list
          servicedata.add(serviceData);

          print("Service data fetched: $serviceData");
        } else {
          print("No service data found for this user.");
        }
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
