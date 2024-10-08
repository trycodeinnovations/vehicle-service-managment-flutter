class ServiceRequest {
  final String id;
  final String userId; // New field to track the user who made the request
  final String description;
  final String status; // "Pending" or "Completed"
  final String customerName;
  final String vehicleName;
  final String serviceDate;

  ServiceRequest({
    required this.id,
    required this.userId, // User ID
    required this.description,
    required this.status,
    required this.customerName,
    required this.vehicleName,
    required this.serviceDate,
  });

  get serviceType => null;
}
