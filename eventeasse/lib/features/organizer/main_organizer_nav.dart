import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../favorite/favorite_page.dart';
import '../profile/profile_page.dart';
import 'organizer_events_page.dart';

class MainOrganizerNav extends StatefulWidget {
  const MainOrganizerNav({Key? key}) : super(key: key);

  @override
  State<MainOrganizerNav> createState() => _MainOrganizerNavState();
}

class _MainOrganizerNavState extends State<MainOrganizerNav> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    HomePage(),
    OrganizerEventsPage(),
    FavoritePage(),
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
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
