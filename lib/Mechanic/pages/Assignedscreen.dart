import 'package:flutter/material.dart';

class AssignedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assigned Tasks"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTaskCard(
                "Oil Change", "Due: Today", "assets/logo/oil_categories.png"),
            _buildTaskCard("Brake Repair", "Due: Tomorrow",
                "assets/logo/oil_categories.png"),
            _buildTaskCard("Tire Rotation", "Due: In 2 days",
                "assets/logo/oil_categories.png"),
            // Add more tasks as needed
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String title, String subtitle, String imgPath) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(imgPath, width: 50, height: 50),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 15),
        onTap: () {
          // Handle task details
        },
      ),
    );
  }
}
