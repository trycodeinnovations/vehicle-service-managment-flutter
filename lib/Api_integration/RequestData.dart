import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

    // After the delay, show the emoji rating dialog
    await showEmojiRatingDialog(context);
  } catch (e) {
    print("exception: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Failed")));
  }
}

Future<void> showEmojiRatingDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Rate Your Experience'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Text(
                    '😡',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    print("User feedback: Very Bad");
                    Navigator.of(dialogContext).pop();
                  },
                ),
                IconButton(
                  icon: Text('😐'), // Neutral emoji
                  onPressed: () {
                    print("User feedback: Neutral");
                    Navigator.of(dialogContext).pop();
                  },
                ),
                IconButton(
                  icon: Text('😍'), // Love emoji
                  onPressed: () {
                    print("User feedback: Very Good");
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
