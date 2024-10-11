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

    // Wait for 5 seconds before showing the rating prompt
    await Future.delayed(Duration(seconds: 5));

    // After the delay, show the star rating dialog
    await showStarRatingDialog(context);
  } catch (e) {
    print("exception: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Failed")));
  }
}

Future<void> showStarRatingDialog(BuildContext context) async {
  double rating = 0;

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Rate Your Experience'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40.0,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                rating = newRating;
                print("User feedback: $rating stars");
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Here you can handle the rating submission, if needed
                Navigator.of(dialogContext).pop();
              },
              child: Text("Submit"),
            ),
          ],
        ),
      );
    },
  );
}
