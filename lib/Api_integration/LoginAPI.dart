import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/ProfileGet.dart';
import 'package:flutter_car_service/User/component/bottom_nav.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> Login(context, email, pass) async {
  FirebaseAuth loginauth = FirebaseAuth.instance;

  try {
    UserCredential cred = await loginauth.signInWithEmailAndPassword(
        email: email, password: pass);
    print('a');
    String? type = await getlogintypes(email);
    print('abcd $type');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', type!); // 'admin', 'mechanic', or 'user'

    await profileGet();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Login success as $type")));
    switch (type) {
      case "users":
        Navigator.pushReplacementNamed(context, "/bottom");
        break;
      case "mechanics":
        Navigator.pushReplacementNamed(context, "/mechanicbottomnav");
        break;
      case "admin":
        Navigator.pushReplacementNamed(context, "/admindashboard");
        break;
      default:
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid login")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Login failed")));
    print("Login failed");
  }
}

Future<String?> getlogintypes(String email) async {
  final List<String> loginTypes = ["users", "mechanics", "admin"];
  try {
    for (String collection in loginTypes) {
      print("Checking the collection: $collection");
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(collection)
              .where("email", isEqualTo: email)
              .get();
      print("Documents found in $collection:${querySnapshot.docs.length}");
      List<Map<String, dynamic>> logindata = [];
      if (querySnapshot.docs.isNotEmpty) {
        print("User found in:$collection");

        if (collection == "users") {
          logindata = querySnapshot.docs.map((doc) {
            return {
              "name": doc['name'],
              "email": doc['email'],
              "car name": doc['car name'],
              "reg number": doc['reg number'],
              "imageurl": doc['imageurl'],
            };
          }).toList();
        } else if (collection == "mechanics") {
          print('mecanic found');
          logindata = querySnapshot.docs.map((doc) {
            return {
              "name": doc['name'],
              "email": doc['email'],
              "experience": doc['experience'],
              "phone": doc['phone'],
              "imageUrl": doc['imageurl'],
            };
          }).toList();
          print(logindata);
        } else if (collection == "admin") {
          print("admin not found");
          logindata = querySnapshot.docs.map((doc) {
            return {
              "name": doc['name'],
              "email": doc['email'],
              "imageurl": doc['imageurl'],
            };
          }).toList();
        }
        if (logindata.isNotEmpty) {
          currentlogindata = logindata.first;
        }
        return collection;
      }
    }
  } catch (e) {
    print(e);
  }
}

Map<String, dynamic> currentlogindata = {};
