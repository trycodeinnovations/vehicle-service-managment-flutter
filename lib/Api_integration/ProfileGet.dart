import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> profileGet() async {
  try {
    String? email = FirebaseAuth.instance.currentUser!.email;
    print(email);
    var update = FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email);
    QuerySnapshot querySnapshot = await update.get();
    print(querySnapshot);
  List<Map<String, dynamic>>   profiledatasss =
        querySnapshot.docs.map((doc) {
      return {  
        'name': doc['name'],
        'email': doc['email'],
        'car name': doc['car name'],
        'reg number': doc['reg number'],
        'imageurl': doc['imageurl']
      };
    }).toList();
    print(profiledata);
    if (profiledatasss.isNotEmpty) {
      profiledata=profiledatasss[0];
    }
  } catch (e) {
    print("exptn:$e");
  }
}
Map<String, dynamic> profiledata={};