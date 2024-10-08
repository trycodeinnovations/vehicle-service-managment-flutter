import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_car_service/Api_integration/Stepper.dart';
import 'package:flutter_car_service/Authentication/SigninScreen.dart';
import 'package:flutter_car_service/Mechanic/component/bottomnav.dart';
import 'package:flutter_car_service/data/pages/home_pages.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'Provider/ServiceHistoryProvider.dart';
import 'Admin/Pages/AddMechanicScreen.dart';
import 'Admin/Pages/Adminhomepage.dart';
import 'Admin/Pages/ServiceDetails.dart';
import 'Mechanic/pages/Homepage.dart';

import 'component/bottom_nav.dart';
import 'data/pages/splashscreen.dart';
import 'style/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print("FCM Token: $fcmToken"); // Uncomment for debugging

  // AwesomeNotifications().initialize(
  //   'resourceKey', // Specify a resource key
  //   [
  //     NotificationChannel(
  //       channelKey: 'basic',
  //       channelName: 'Basic Notification',
  //       channelDescription: 'Notification for basic alerts',
  //     ),
  //   ],
  //   debug: true,
  // );
  // } catch (e) {
  //   print("Error initializing Firebase: $e");
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ServiceRequestProvider>(
          create: (_) => ServiceRequestProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/splash",
        routes: {
          "/home": (context) => HomePage(),
          "/splash": (context) => SplashScreen(),
          "/admindashboard": (context) => AdminDashboard(
                title: "",
                mainColor: mainColor,
              ),
          "/bottom": (context) => BottomNav(),
          "/signin": (context) => SignInScreen(),
          "/addmechanic": (context) => AddMechanicScreen(),
          // "/allserviceDetails": (context) => ServiceDetailsScreen(
          //       service: context,
          //     ),
          "/mechanicbottomnav": (context) => BotomMechanic(),
          "/stepper": (context) => RequestStatusStepper(),
        },
      ),
    );
  }
}
