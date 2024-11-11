import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_car_service/Api_integration/Stepper.dart';
import 'package:flutter_car_service/Authentication/SigninScreen.dart';
import 'package:flutter_car_service/Mechanic/component/bottomnav.dart';
import 'package:flutter_car_service/Mechanic/pages/FullTaskDetails.dart';
import 'package:flutter_car_service/Mechanic/pages/live.dart';
import 'package:flutter_car_service/User/data/pages/home_pages.dart';
import 'package:flutter_car_service/User/data/pages/paymentscreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'Provider/ServiceHistoryProvider.dart';
import 'Admin/Pages/AddMechanicScreen.dart';
import 'Admin/Pages/Adminhomepage.dart';
import 'Admin/Pages/ServiceDetails.dart';
import 'Mechanic/pages/Homepage.dart';

import 'User/component/bottom_nav.dart';
import 'User/data/pages/splashscreen.dart';
import 'style/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Request Notification Permissions (for Android 13 and above)
  await requestNotificationPermission();

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    'resourceKey', // Specify a resource key
    [
      NotificationChannel(
        channelKey: 'basic',
        channelName: 'Basic Notification',
        channelDescription: 'Notification for basic alerts',
      ),
    ],
    debug: true,
  );

  runApp(const MyApp());
}

// Function to request notification permission (for Android 13+)
Future<void> requestNotificationPermission() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    final status =
        await AwesomeNotifications().requestPermissionToSendNotifications();
    if (status) {
      print("Notification permission granted!");
    } else {
      print("Notification permission denied!");
    }
  }
}

// Declare a global notification plugin instance
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _initializeNotifications() async {
  // Initialization settings for Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
          "/mechanicbottomnav": (context) => BotomMechanic(),
          "/stepper": (context) => RequestStatusStepper(),
        },
      ),
    );
  }
}
