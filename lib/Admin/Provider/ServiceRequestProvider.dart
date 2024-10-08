// import 'package:flutter/material.dart';
// import 'package:flutter_car_service/Admin/Model/ServiceReqquestModel.dart';


// class ServiceRequestProvider with ChangeNotifier {
//   List<ServiceRequest> _serviceRequests = [
//     ServiceRequest(
//       id: '1',
//       userId: 'user1', // user1 made this request
//       description: 'Oil change and tire rotation',
//       status: 'Pending',
//       customerName: 'John Doe',
//       vehicleName: 'Toyota Camry',
//       serviceDate: '2024-09-20',
//     ),
//     ServiceRequest(
//       id: '2',
//       userId: 'user2', // user2 made this request
//       description: 'Brake replacement',
//       status: 'Completed',
//       customerName: 'Jane Smith',
//       vehicleName: 'Honda Civic',
//       serviceDate: '2024-09-18',
//     ),
//   ];

//   String _currentUserId = 'user1'; // This should be dynamic based on logged-in user

//   List<ServiceRequest> get pendingRequests =>
//       _serviceRequests.where((request) =>
//           request.status == 'Pending' && request.userId == _currentUserId).toList();

//   List<ServiceRequest> get completedRequests =>
//       _serviceRequests.where((request) =>
//           request.status == 'Completed' && request.userId == _currentUserId).toList();

//   void markAsCompleted(String id) {
//     final requestIndex =
//         _serviceRequests.indexWhere((request) => request.id == id);
//     if (requestIndex != -1) {
//       _serviceRequests[requestIndex] = ServiceRequest(
//         id: _serviceRequests[requestIndex].id,
//         userId: _serviceRequests[requestIndex].userId,
//         description: _serviceRequests[requestIndex].description,
//         status: 'Completed',
//         customerName: _serviceRequests[requestIndex].customerName,
//         vehicleName: _serviceRequests[requestIndex].vehicleName,
//         serviceDate: _serviceRequests[requestIndex].serviceDate,
//       );
//       notifyListeners();
//     }
//   }

//   void setCurrentUser(String userId) {
//     _currentUserId = userId;
//     notifyListeners();
//   }
// }
