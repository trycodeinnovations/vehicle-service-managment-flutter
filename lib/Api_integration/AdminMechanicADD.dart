import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> MechanicReg(BuildContext context, String email, String password,
    Map<String, dynamic> data, image) async {
  try {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (cred.user != null) {
      final StorageRef = FirebaseStorage.instance
          .ref()
          .child("mechanic_images")
          .child("${cred.user!.uid}.jpg");
      await StorageRef.putFile(image!);
      print('Image stored');

      final imageurl = await StorageRef.getDownloadURL();
      data["imageurl"] = imageurl;

      await firestore.collection("mechanics").doc(email).set(data);

      // Show success alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Registered successfully!',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.blueGrey[800]!,
      );
    }
  } catch (e) {
    print(e);

    // Show error alert
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Registration failed: ${e.toString()}',
      confirmBtnText: 'OK',
      confirmBtnColor: Colors.blueGrey[800]!,
    );
  }
}
