import 'package:flutter/material.dart';
import 'package:flutter_car_service/Authentication/Constants.dart';
import 'package:flutter_car_service/Authentication/SigninScreen.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart'; // Import QuickAlert
// Adjust the import to your SignIn screen

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  // Email/Mobile TextField
  Widget _buildInputField({
    required String hintText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: _emailController,
      style: GoogleFonts.poppins(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: mainColor),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: Colors.black26,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Submit Button
  Widget _buildSubmitBtn() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _sendResetLink,
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.all(15),
        ),
        child: Text(
          "Submit",
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _sendResetLink() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Warning',
        text: 'Please enter your email.',
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Password reset link sent to $email. Check your inbox.',
        onConfirmBtnTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SignInScreen()), // Adjust to your sign-in screen
          );
        },
      );
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30.0),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: kBackButtonColor,
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Image.asset(
                "assets/images/forgot-password.png",
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              "Forgot\nPassword?",
              style: GoogleFonts.poppins(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: kTextHeadingColor,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              "Don’t worry. Please enter the address associated with your account.",
              style: GoogleFonts.poppins(
                fontSize: 16.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40.0),
            _buildInputField(
              hintText: "Email ID / Mobile number",
              icon: Icons.alternate_email_sharp,
            ),
            const SizedBox(height: 50.0),
            _buildSubmitBtn(),
          ],
        ),
      ),
    );
  }
}
