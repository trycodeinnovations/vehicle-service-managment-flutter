import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_service/Api_integration/ProfileGet.dart';
import 'package:flutter_car_service/Api_integration/ServicedetailsGet.dart';
import 'package:flutter_car_service/constants/dayGeting.dart';
import 'package:flutter_car_service/data/articles_data.dart';
import 'package:flutter_car_service/data/last_service.dart';
import 'package:flutter_car_service/data/pages/Review.dart';
import 'package:flutter_car_service/data/service.dart';
import 'package:flutter_car_service/data/pages/Fullservivedetail.dart';
import 'package:flutter_car_service/data/pages/Oilservicedetailscreen.dart';
import 'package:flutter_car_service/data/pages/soundsystemdetail.dart';
import 'package:flutter_car_service/data/pages/tiredetails.dart';
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
    'assets/images/img1.jpg',
    'assets/images/img1.jpg',
  ];

  @override
  void initState() {
    super.initState();
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
                RatingsAndReviews(),
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
  // Check if servicedata is empty
  if (servicedata.isEmpty) {
    return SizedBox(
      height: 190,
      child: Center(
        child: Text(
          'No recent services available.',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  return SizedBox(
    height: 190,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: servicedata.length,
      itemBuilder: (context, index) {
        // Check that index is within range
        if (index >= servicedata.length) {
          return Container(); // Or handle the case gracefully
        }

        // Determine icon and text based on service status
        Icon statusIcon;
        Color iconColor;
        String statusText;
        String buttonText;

        // Adjust the keys here according to your actual data structure
        String status = servicedata[index]['status'] ?? 'unknown';

        if (status.toLowerCase() == 'Completed') {
          statusIcon = Icon(Icons.check_circle, color: Colors.green);
          iconColor = Colors.green;
          statusText = "Completed";
          buttonText = "Detail"; // Button text for completed status
        } else if (status.toLowerCase() == 'Pending') {
          statusIcon = Icon(Icons.pending, color: Colors.orange);
          iconColor = Colors.orange;
          statusText = "In Progress";
          buttonText = "Track"; // Button text for in-progress status
        } else {
          statusIcon = Icon(Icons.error, color: Colors.red);
          iconColor = Colors.red;
          statusText = "Unknown Status";
          buttonText = "Detail"; // Default button text for unknown status
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
                        daytime(servicedata[index]['selectedDate'].toString()),
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
                    servicedata[index]["selectedTimeSlot"] ?? '',
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
                servicedata[index]["selectedService"][0]['title'] ?? '',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: mainColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // Add the status icon here
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(), // Display the status icon
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
                    // Navigate based on button text
                    if (buttonText == "Track") {
                      Navigator.pushNamed(context, "/stepper");
                    } else {
                      Navigator.pushNamed(context, "/detailScreen");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      buttonText, // Use dynamic button text
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

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              color: subText.withOpacity(0.1),
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
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    profiledata['imageurl'] ??
                        'https://example.com/default_image.png', // Default image URL if none
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profiledata['name'] ??
                          'No Name', // Default text if name is missing
                      style: GoogleFonts.poppins(
                        color: mainColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Premium Customer",
                      style: GoogleFonts.poppins(
                        color: subText,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.notifications_outlined,
              color: mainColor,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
