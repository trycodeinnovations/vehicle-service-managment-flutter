import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/Googlelogin.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';
import 'package:flutter_car_service/Api_integration/ProfileGet.dart';
import 'package:flutter_car_service/Api_integration/ServicedetailsGet.dart';
import 'package:flutter_car_service/Api_integration/ushNotification.dart';
import 'package:flutter_car_service/Authentication/Constants.dart';
import 'package:flutter_car_service/Authentication/ForgetPasswordScreen.dart';
import 'package:flutter_car_service/Authentication/SignUpScreen.dart';
import 'package:flutter_car_service/Mechanic/component/bottomnav.dart';
import 'package:flutter_car_service/User/Widgets/customScafold.dart';

import 'package:flutter_car_service/User/component/bottom_nav.dart';
import 'package:flutter_car_service/User/data/pages/get_started.dart';
import 'package:flutter_car_service/User/data/pages/home_pages.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  bool isLoading = false; // Add a loading state
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? userId;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: GoogleFonts.poppins(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: mainColor,
                        ),
                      ),
                      SizedBox(height: 40.0),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: mainColor,
                              ),
                              Text(
                                'Remember me',
                                style: GoogleFonts.poppins(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                )),
                            child: Text(
                              'Forget password?',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Material(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            splashColor: subText,
                            borderRadius: BorderRadius.circular(15),
                            onTap: () async {
                              if (_formSignInKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true; // Set loading state to true
                                });

                                // Attempt to log in the user
                                await Login(context, emailController.text,
                                    passwordController.text);
                                ServiceDataGet();

                                // Fetch user type and save it in SharedPreferences
                                ServiceDataGet(); // Assume this function fetches userType

                                setState(() {
                                  isLoading =
                                      false; // Set loading state to false
                                });
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      "Sign in",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: GoogleFonts.poppins(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () async {
                              // Call the Google sign-in method
                              try {
                                await Firebaseservices().signinwithgoogle();
                                // Navigate to BottomNav after successful sign-in
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNav(),
                                  ),
                                );
                              } catch (error) {
                                // Handle any errors during sign-in
                                print("Error signing in with Google: $error");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Sign-in failed. Please try again.")),
                                );
                              }
                            },
                            icon: Icon(Bootstrap.google, color: mainColor),
                          ),
                          Icon(Bootstrap.facebook, color: mainColor),
                          Icon(Bootstrap.apple, color: mainColor),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
