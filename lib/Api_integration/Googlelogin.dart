import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class Firebaseservices {
  final auth = FirebaseAuth.instance;
  final googlesignin = GoogleSignIn();

  signinwithgoogle() async {
    try {
      final GoogleSignInAccount? googlesigninaccount =
          await googlesignin.signIn();
      if (googlesigninaccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googlesigninaccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }
}
