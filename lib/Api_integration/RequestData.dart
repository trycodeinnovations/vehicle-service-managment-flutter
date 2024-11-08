import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> RequestDetails(
    BuildContext context, Map<String, dynamic> data) async {
  try {
    // Add the service request to Firestore
    await firestore.collection("serviceReqDetails").add(data);

    // Show success message immediately
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Success")));
  } catch (e) {
    print("exception: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Failed")));
  }
}
