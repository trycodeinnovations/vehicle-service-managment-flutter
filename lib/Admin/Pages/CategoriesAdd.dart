import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/service_models.dart';

class ServiceFetchScreen extends StatelessWidget {
  // Function to fetch services from Firestore
  Stream<List<ServiceModels>> fetchServices() {
    return FirebaseFirestore.instance.collection('services').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => ServiceModels.fromFirestore(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services List'),
      ),
      body: StreamBuilder<List<ServiceModels>>(
        stream: fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No services available.'));
          }

          final services = snapshot.data!;

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return ListTile(
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(service.logo, fit: BoxFit.cover),
                ),
                title: Text(service.title),
                subtitle: Text('ID: ${service.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

class ServiceModels {
  final String id;
  final String logo;
  final String title;

  ServiceModels({required this.id, required this.logo, required this.title});

  // Convert model to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logo': logo,
      'title': title,
    };
  }

  // Create a ServiceModels object from Firestore data
  factory ServiceModels.fromFirestore(Map<String, dynamic> data) {
    return ServiceModels(
      id: data['id'] ?? '',
      logo: data['logo'] ?? '',
      title: data['title'] ?? '',
    );
  }
}
