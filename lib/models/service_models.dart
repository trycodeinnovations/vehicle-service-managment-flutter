class ServiceModels {
  final String id;
  final String logo;
  final String title; // Non-nullable title

  ServiceModels({
    required this.id,
    required this.logo,
    required this.title, // Make title required
  });
}
