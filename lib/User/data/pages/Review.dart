import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingsAndReviews extends StatelessWidget {
  RatingsAndReviews({Key? key}) : super(key: key);

  final Color mainColor = const Color(0xff172D48); // Your app's main color
  final Color subTextColor =
      const Color(0xff888686); // Your app's subtext color

  final List<Review> reviewsData = [
    Review(
      userName: 'Alice Johnson',
      userImageUrl: 'assets/images/user.jpg',
      comment: 'Great service! Highly recommend.',
      rating: 5,
    ),
    Review(
      userName: 'John Doe',
      userImageUrl: 'assets/images/user.jpg',
      comment: 'Good experience but can improve speed.',
      rating: 4,
    ),
    // Add more reviews as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0), // Added padding
            child: Text(
              "Customer Reviews",
              style: GoogleFonts.poppins(
                color: mainColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CarouselSlider.builder(
            itemCount: reviewsData.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      mainColor.withOpacity(0.8),
                      subTextColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage(reviewsData[itemIndex].userImageUrl),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reviewsData[itemIndex].userName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.mood, color: Colors.yellowAccent),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            reviewsData[itemIndex].comment,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < reviewsData[itemIndex].rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.thumb_up, color: Colors.white)),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.thumb_down, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              height: 180, // Set a fixed height
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              enlargeCenterPage: true,
            ),
          ),
        ],
      ),
    );
  }
}

// Sample Review class to hold review data
class Review {
  final String userName;
  final String userImageUrl;
  final String comment;
  final int rating;

  Review({
    required this.userName,
    required this.userImageUrl,
    required this.comment,
    required this.rating,
  });
}
