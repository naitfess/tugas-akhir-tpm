import 'package:flutter/material.dart';
import '../profile/profile_page.dart';
import 'admin_requests_page.dart';

class MainAdminNav extends StatefulWidget {
  const MainAdminNav({Key? key}) : super(key: key);

  @override
  State<MainAdminNav> createState() => _MainAdminNavState();
}

class _MainAdminNavState extends State<MainAdminNav> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    AdminRequestsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
