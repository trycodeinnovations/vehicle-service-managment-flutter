import 'package:flutter/material.dart';
import 'package:flutter_car_service/Admin/Pages/AddMechanicScreen.dart';
import 'package:flutter_car_service/Admin/Pages/CategoriesAdd.dart';
import 'package:flutter_car_service/Admin/Pages/TotalMechanics.dart';
import 'package:flutter_car_service/Admin/Pages/ServiceRequestScreen.dart';

import 'package:flutter_car_service/Admin/Pages/totalrequest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_car_service/Api_integration/LoginAPI.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key, required this.title, required this.mainColor});

  final String title;
  final Color mainColor;

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.dashboard, 'title': 'Dashboard'},
    {'icon': Icons.build, 'title': 'Mechanic Management'},
    {'icon': Icons.assignment, 'title': 'Service Request'},
    {'icon': Icons.report, 'title': 'Reports'},
    {'icon': Icons.settings, 'title': 'Settings'},
  ];

  final List<Map<String, dynamic>> stats1 = [
    {'icon': Icons.grid_view, 'title': 'Total enquiries'},
    {'icon': 'assets/images/Mechanic1.jpg', 'title': 'Total Mechanics'},
  ];

  final List<Map<String, dynamic>> stats2 = [
    {'icon': Icons.grid_view, 'title': 'Total Services'},
    {'icon': Icons.file_copy, 'title': 'Service Requests'},
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "Logout",
      text: "Are you sure you want to logout?",
      confirmBtnText: "Yes",
      cancelBtnText: "No",
      onConfirmBtnTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pop(); // Close the dialog
        Navigator.pushReplacementNamed(context, "/signin");
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop(); // Close the dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.mainColor,
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildProfileContainer(),
            SizedBox(height: 16.0),
            _buildStatsGrid(stats1),
            SizedBox(height: 16.0),
            _buildStatsGrid(stats2),
            SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: _buildCrystalBottomNavigationBar(),
    );
  }

  Widget _buildProfileContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              currentlogindata["name"][0],
              style: TextStyle(color: widget.mainColor, fontSize: 24),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentlogindata["name"],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  currentlogindata["email"],
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(List<Map<String, dynamic>> stats) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (stats[index]['title'] == 'Total Mechanics') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => MechanicProfileScreen()),
                );
              } else if (stats[index]['title'] == 'Service Requests') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceRequestScreen(),
                  ),
                );
              } else if (stats[index]['title'] == 'Total Services') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        RequestsScreen(), // New Screen for Request View
                  ),
                );
              } else if (stats[index]['title'] == 'Total enquiries') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        UserTicketsScreen(), // New Screen for Request View
                  ),
                );
              }
            },
            child: _buildStatCard(
              stats[index]['icon'] is IconData
                  ? Icon(
                      stats[index]['icon'],
                      size: 24,
                      color: Colors.black,
                    )
                  : Image.asset(
                      stats[index]['icon'],
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
              stats[index]['title'],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(Widget iconWidget, String title) {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(
                  menuItems[index]['icon'],
                  menuItems[index]['title'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(currentlogindata["name"]),
      accountEmail: Text(currentlogindata["email"]),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          currentlogindata["name"][0],
          style: TextStyle(color: widget.mainColor, fontSize: 40),
        ),
      ),
    );
  }

  Widget _buildCrystalBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Mechanics'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.assignment), label: 'Requests'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: widget.mainColor,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: widget.mainColor),
      title: Text(title),
      onTap: () {
        if (title == 'Service Request') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ServiceRequestScreen(),
            ),
          );
        } else if (title == 'Mechanic Management') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddMechanicScreen(),
            ),
          );
        }
      },
    );
  }
}
