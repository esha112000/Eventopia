import 'package:eventopia_app/services/session_manager.dart';
import 'package:eventopia_app/scripts/batch_add.dart';
import 'package:eventopia_app/view/events/events_list_page.dart';
import 'package:eventopia_app/view/events/favourites_event_page.dart';
import 'package:eventopia_app/view/events/my_bookings_page.dart';
import 'package:eventopia_app/view/profile/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventopia_app/controller/auth_controller.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Navigation options
  final List<Widget> _pages = [
    EventsListPage(),
    const FavoriteEventsPage(),
    const MyBookingsPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _monitorAuthState();
  }

  void _monitorAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // User is logged out
        final sessionManager = SessionManager();
        sessionManager.clearToken();
        Navigator.pushReplacementNamed(context, '/auth');
      }
    });
  }

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
