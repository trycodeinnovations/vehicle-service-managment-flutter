import 'package:flutter/material.dart';

class ServiceRequestProvider with ChangeNotifier {
  List<Map<String, String>> _serviceRequests = [
    {"service": "Oil Change", "status": "Pending"},
    {"service": "AC Repair", "status": "Completed"},
  ];

  List<Map<String, String>> get serviceRequests => _serviceRequests;

  get pendingRequests => null;

  get completedRequests => null;

  void updateRequestStatus(int index, String status) {
    _serviceRequests[index]["status"] = status;
    notifyListeners();
  }

  void setCurrentUser(String s) {}

  void markAsCompleted(id) {}

  void assignRequest(String id, String s, double parse) {}
}
