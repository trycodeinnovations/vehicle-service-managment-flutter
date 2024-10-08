import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/Authentication/SigninScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> Register(
    BuildContext context, email, password, data, _image) async {
  try {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (cred.user != null) {
      final StorageRef = FirebaseStorage.instance
          .ref()
          .child("user_images")
          .child("${cred.user!.uid}.jpg");
      await StorageRef.putFile(_image!);
      print('img stored');
      final imageurl = await StorageRef.getDownloadURL();
      data["imageurl"] = imageurl;
      await firestore.collection("users").doc(email).set(data);
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Registered Succesfull")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen(),));
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Registered Failed: ${e.toString()}")));
  }
}
