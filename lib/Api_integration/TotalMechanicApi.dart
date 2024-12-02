import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> TotalMechanics() async {
  try {
    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) {
      print("User is not logged in.");
      return;
    }

    print("Fetching service details for: $email");

    // Fetch the documents where the email matches
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("mechanics").get();

    if (querySnapshot.docs.isNotEmpty) {
      // Clear the previous mechanicda data list
      mechanicdata.clear();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data();

        // Check if data is not null
        // Extract the service details from the document
        Map<String, dynamic> mechanicsProfile = {
          'email': data['email'],
          'experience': data['experience'],
          'imageurl': data['imageurl'],
          'name': data['name'],
          'phone': data['phone'],
        };

        // Add it to the list
        mechanicdata.add(mechanicsProfile);

        print("Service data fetched: $mechanicsProfile");
            }
    } else {
      print("No documents found for this user.");
    }
  } catch (e) {
    print("Exception: $e");
  }
}

// List to store the mechanicdata data
List<Map<String, dynamic>> mechanicdata = [];
