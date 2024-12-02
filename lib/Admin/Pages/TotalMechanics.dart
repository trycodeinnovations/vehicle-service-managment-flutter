import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MechanicProfileScreen extends StatefulWidget {
  const MechanicProfileScreen({super.key});

  @override
  _MechanicProfileScreenState createState() => _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends State<MechanicProfileScreen> {
  List<Map<String, dynamic>> mechanicdata = []; // Store mechanic data here
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchMechanics(); // Fetch mechanics when widget initializes
  }

  // Fetch data from Firestore
  Future<void> _fetchMechanics() async {
    try {
      var collection = FirebaseFirestore.instance.collection('mechanics');
      var snapshot = await collection.get();
      setState(() {
        mechanicdata = snapshot.docs
            .map((doc) => doc.data())
            .toList();
        isLoading = false; // Data loaded
      });
    } catch (e) {
      print('Error fetching mechanics: $e');
      setState(() {
        isLoading = false; // Stop loading if error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mechanics Profiles',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : ListView.builder(
              itemCount: mechanicdata.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(mechanicdata[index]['email'] ??
                      'unknown_email'), // Use email as key
                  background: _buildSwipeBackground(),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await _showDeleteConfirmation(context) ?? false;
                  },
                  onDismissed: (direction) {
                    _deleteMechanic(
                        mechanicdata[index]['email']); // Delete by email
                    setState(() {
                      mechanicdata.removeAt(index); // Remove from local list
                    });
                    _showToast(context, 'Mechanic profile deleted');
                  },
                  child: _buildMechanicTile(mechanicdata[index]),
                );
              },
            ),
    );
  }

  Widget _buildMechanicTile(Map<String, dynamic> mechanic) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blueGrey,
            backgroundImage: NetworkImage(
              mechanic['imageurl'] ??
                  'https://via.placeholder.com/150', // Fallback image URL
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mechanic["name"] ??
                      'Unknown Name', // Fallback if name is null
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  mechanic["email"] ??
                      'Unknown Email', // Fallback if email is null
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  'Phone: ${mechanic["phone"] ?? 'Unknown Phone'}', // Fallback if phone is null
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  'Experience: ${mechanic["experience"] ?? '0'} years', // Fallback if experience is null
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.swipe, color: Colors.red, size: 18),
                SizedBox(width: 4),
                Text(
                  'Swipe to delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.delete, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Text('Swipe to delete', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Mechanic'),
        content: Text('Are you sure you want to delete this mechanic profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteMechanic(String email) async {
    try {
      var collection = FirebaseFirestore.instance.collection('mechanics');
      var snapshot = await collection.where('email', isEqualTo: email).get();

      for (var doc in snapshot.docs) {
        await doc.reference
            .delete(); // Delete the document(s) with the matching email
      }
        } catch (e) {
      print('Error deleting mechanic: $e'); // Log error
    }
  }
}
