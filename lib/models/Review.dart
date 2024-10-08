class Review {
  final String userName;
  final String comment;
  final double rating;
  final String userImageUrl; // New field for user image URL

  Review({
    required this.userName,
    required this.comment,
    required this.rating,
    required this.userImageUrl, // Add user image URL
  });
}

// Sample data for reviews with user images
List<Review> reviewsData = [
  Review(
    userName: "Alice",
    comment: "Great service!",
    rating: 5.0,
    userImageUrl: "assets/images/user1.jpg", // Replace with actual URL
  ),
  Review(
    userName: "Bob",
    comment: "Very satisfied with my last visit.",
    rating: 4.5,
    userImageUrl: "assets/images/user2.jpg", // Replace with actual URL
  ),
  Review(
    userName: "Charlie",
    comment: "Will definitely come back!",
    rating: 5.0,
    userImageUrl: "assets/images/user3.jpg", // Replace with actual URL
  ),
];
