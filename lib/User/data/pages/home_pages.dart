import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/ProfileGet.dart';
import 'package:flutter_car_service/Api_integration/ServicedetailsGet.dart';
import 'package:flutter_car_service/constants/dayGeting.dart';
import 'package:flutter_car_service/User/data/articles_data.dart';
import 'package:flutter_car_service/User/data/last_service.dart';
import 'package:flutter_car_service/User/data/service.dart';
import 'package:flutter_car_service/User/data/pages/Fullservivedetail.dart';
import 'package:flutter_car_service/User/data/pages/Oilservicedetailscreen.dart';
import 'package:flutter_car_service/User/data/pages/soundsystemdetail.dart';
import 'package:flutter_car_service/User/data/pages/tiredetails.dart';
import 'package:flutter_car_service/style/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatbot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgList = [
    'assets/images/img1.jpg',
    'assets/images/9226862.jpg',
    'assets/images/8187546.jpg',
  ];

  @override
  void initState() {
    super.initState();
    ServiceDataGet();
    profileGet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileContainer(),
                const SizedBox(height: 25),
                if (servicedata.isNotEmpty) ...[
                  Text(
                    "Last Service",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: subText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  lastServiceList(),
                ],
                const SizedBox(height: 8),
                Text(
                  "Service List",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: subText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                buildServiceList(),
                const SizedBox(height: 25),
                Text(
                  "Current promotions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: subText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                buildPromotionsList(),
                Divider(),
                const SizedBox(height: 25),
                buildCarousel(),
                const SizedBox(height: 25),
                // RatingsAndReviews(),
              ],
            ),
          ),
        ),
        floatingActionButton: Chatbot(), // Add the chatbot here
      ),
    );
  }

  Widget buildServiceList() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: serviceItemsData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              late Widget screen;
              if (serviceItemsData[index].id == '1') {
                screen = VehicleFullServiceDetailPage();
              } else if (serviceItemsData[index].id == '2') {
                screen = SoundSystemDetailPage();
              } else if (serviceItemsData[index].id == '3') {
                screen = OilChangeDetailPage();
              } else {
                screen = TireDetailPage();
              }
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => screen));
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(right: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: mainColor,
              ),
              child: Column(
                children: [
                  Image.asset(
                    serviceItemsData[index].logo.toString(),
                    height: 20,
                    width: 40,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    serviceItemsData[index].title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPromotionsList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: articlesData.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(articlesData[index].image.toString()),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      articlesData[index].title ?? '',
                      style: GoogleFonts.poppins(
                        color: mainColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: Text(
                        articlesData[index].description ?? '',
                        textAlign: TextAlign.left,
                        maxLines: 4,
                        style: GoogleFonts.poppins(
                          color: subText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCarousel() {
    return CarouselSlider.builder(
      itemCount: imgList.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imgList[itemIndex],
            fit: BoxFit.cover,
          ),
        ),
      ),
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        enableInfiniteScroll: true,
        initialPage: 0,
      ),
    );
  }
}

SizedBox lastServiceList() {
  // Get current user's email (assuming FirebaseAuth is used)
  String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  // Check if servicedata is null or empty
  if (servicedata.isEmpty || currentUserEmail.isEmpty) {
    return SizedBox(); // Return nothing (an empty widget)
  }

  // Filter the servicedata based on the current user's email
  List<dynamic> userServices = servicedata.where((service) {
    String serviceEmail =
        service['email']; // Assuming the email field exists in your data
    return serviceEmail == currentUserEmail;
  }).toList();

  // If no services found for the user, return an empty widget
  if (userServices.isEmpty) {
    return SizedBox();
  }

  return SizedBox(
    height: 190,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: userServices.length,
      itemBuilder: (context, index) {
        // Retrieve data for the current service
        String status = userServices[index]['status'] ?? 'unknown';
        String paymentStatus = userServices[index]['payment'] ?? 'notdone';
        String selectedDate =
            userServices[index]['selectedDate']?.toString() ?? '';
        String selectedTimeSlot = userServices[index]['selectedTimeSlot'] ?? '';
        List<dynamic> selectedService =
            userServices[index]["selectedService"] ?? [];

        String serviceTitle = selectedService.isNotEmpty
            ? '${selectedService[0]['title'] ?? ''}${selectedService.length > 1 ? '...' : ''}'
            : '';

        // Determine icon, color, status text, and button text based on status and payment
        Icon statusIcon;
        Color iconColor;
        String statusText;
        String buttonText;
        String cleanStatus = status
            .trim()
            .toLowerCase(); // Trim whitespaces and convert to lowercase

        if (cleanStatus == 'pending' || cleanStatus == 'in progress') {
          statusIcon = Icon(Icons.pending, color: Colors.orange);
          iconColor = Colors.orange;
          statusText = "In Progress";
          buttonText = "Track";
        } else if (cleanStatus == 'completed') {
          statusIcon = Icon(Icons.check_circle, color: Colors.green);
          iconColor = Colors.green;
          statusText = "Completed";
          buttonText = "Detail";
        } else {
          // Debug print to check what value is triggering "Unknown Status"
          print('Unknown status: $cleanStatus');
          statusIcon = Icon(Icons.error, color: Colors.red);
          iconColor = Colors.red;
          statusText = "Unknown Status";
          buttonText = "Detail";
        }

        return Container(
          width: 150,
          height: 120,
          margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: index == 0 ? Colors.white : lastServiceAccent,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: index == 0
                    ? subText.withOpacity(0.1)
                    : Colors.white.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        daytime(selectedDate),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: subText,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        lastService[index].clock ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: mainColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    selectedTimeSlot,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: mainColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Service",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: subText,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                serviceTitle,
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: mainColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    statusText,
                    style: GoogleFonts.poppins(
                      color: iconColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Material(
                color: index == 0 ? blueAccent : mainColor,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  splashColor: index == 0 ? mainColor : blueAccent,
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    if (buttonText == "Track") {
                      Navigator.pushNamed(context, "/stepper");
                    } else {
                      // Call the bottom sheet function with the current service data
                      showServiceRequestDetailsBottomSheet(
                          context, userServices[index]);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

// Method to show the bottom sheet
void showServiceRequestDetailsBottomSheet(
    BuildContext context, Map<String, dynamic> servicedata) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow scrolling if the content is too long
    builder: (context) {
      return ServiceRequestDetailsBottomSheet(servicedata: servicedata);
    },
  );
}

class ServiceRequestDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> servicedata;

  const ServiceRequestDetailsBottomSheet({
    super.key,
    required this.servicedata,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(16.0), // Padding for the bottom sheet
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Rounded top corners
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Make the column take minimum height
        children: [
          Text(
            'Service Request Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 16),
          _buildRow('Phone Number',
              servicedata['phoneNumber'] ?? 'Not provided', screenWidth),
          SizedBox(height: 8), // Space between rows
          _buildRow(
              'Email', servicedata['email'] ?? 'Not provided', screenWidth),
          SizedBox(height: 8), // Space between rows
          _buildRow(
              'Status', servicedata['status'] ?? 'Not specified', screenWidth),
          SizedBox(height: 8), // Space between rows
          _buildRow(
              'Cost', servicedata['cost'] ?? 'Not specified', screenWidth),
          SizedBox(height: 8), // Space between rows
          _buildRow('Mechanic Name', servicedata['mechanic'] ?? 'Unknown',
              screenWidth),
          SizedBox(height: 8), // Space between rows
          _buildRow('Selected Date',
              servicedata['selectedDate'] ?? 'Not specified', screenWidth),
          SizedBox(height: 8), // Space between rows
          _buildRow('Selected Time Slot',
              servicedata['selectedTimeSlot'] ?? 'Not specified', screenWidth),
          SizedBox(height: 8), // Space between rows
          _buildRow(
              'Selected Services',
              (servicedata['selectedService']
                      ?.map((service) => service['title'])
                      .join(', ') ??
                  'None'),
              screenWidth),
        ],
      ),
    );
  }

  // Helper method to build rows for displaying details
  Widget _buildRow(String label, String value, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.4, // Fixed width for label
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.02), // Space between name and colon
        Text(
          ':', // Colon after label
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: screenWidth * 0.04), // Space between colon and value
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
            ),
          ),
        ),
      ],
    );
  }
}

// Helper method to build rows for displaying details
Widget _buildRow(String label, String value, double screenWidth) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: screenWidth * 0.4, // Fixed width for label
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(width: screenWidth * 0.02), // Space between name and colon
      Text(
        ':', // Colon after label
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(width: screenWidth * 0.04), // Space between colon and value
      Expanded(
        child: Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
          ),
        ),
      ),
    ],
  );
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current user's email from Firebase Authentication
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (currentUserEmail == null) {
      return Center(
        child: Text('User not logged in'),
      );
    }

    return InkWell(
      onTap: () {
        // Navigator.push(
        // context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // StreamBuilder for fetching user data from Firestore
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(
                          'users') // Replace 'users' with your collection name
                      .where('email', isEqualTo: currentUserEmail)
                      .limit(1) // Fetch only one document
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        child:
                            CircularProgressIndicator(), // Loading indicator in avatar
                      );
                    }

                    if (snapshot.hasError) {
                      return CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.error, color: Colors.white),
                      );
                    }

                    // Check if data is available
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            'https://example.com/default_image.png'), // Default image
                      );
                    }

                    // Get user document
                    var userDoc = snapshot.data?.docs.first;
                    String userName = userDoc?['name'] ?? 'No Name';
                    String imageUrl = userDoc?['imageurl'] ??
                        'https://example.com/default_image.png'; // Default image if not found

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              imageUrl), // Fetch image from Firestore
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Premium Customer",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
