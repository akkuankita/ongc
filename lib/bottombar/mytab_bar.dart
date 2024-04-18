import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ongcguest_house/bottombar/admin_dashboards.dart';
import 'package:ongcguest_house/bottombar/booking_screen.dart';
import 'package:ongcguest_house/bottombar/check_in.dart';
import 'package:ongcguest_house/bottombar/check_out.dart';
import 'package:ongcguest_house/constants.dart';
 

class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const AdminDashboards(),
    const BookingScreen(),
    const CheckIn(),
    const CheckOut(),
    
  ];

void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    
    });
  }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4.0, spreadRadius: 2),
          ],
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              // activeIcon: Image.asset("assets/icon/home.png",
              //     width: 22.w, height: 22.h, color: kPrimaryColor),
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Latest Booking',
              // activeIcon: Image.asset("assets/icon/community.png",
              //     color: kPrimaryColor),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Check In',
              // activeIcon: Image.asset("assets/icon/community.png",
              //     color: kPrimaryColor),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Check Out',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          unselectedFontSize: 14.sp,
          selectedFontSize: 14.sp,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedItemColor: const Color(0xFF9A9696),
          unselectedLabelStyle: TextStyle(
              fontSize: 14.sp, height: 1.5.h, fontWeight: FontWeight.w500),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
