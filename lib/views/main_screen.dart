import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_screen.dart';
import 'fields_screen.dart';
import 'bookings_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FieldsScreen(),
    const BookingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 24.sp,
              ),
              activeIcon: Icon(
                Icons.home,
                size: 24.sp,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.sports_outlined,
                size: 24.sp,
              ),
              activeIcon: Icon(
                Icons.sports,
                size: 24.sp,
              ),
              label: 'Fields',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.event_note_outlined,
                size: 24.sp,
              ),
              activeIcon: Icon(
                Icons.event_note,
                size: 24.sp,
              ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                size: 24.sp,
              ),
              activeIcon: Icon(
                Icons.person,
                size: 24.sp,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}