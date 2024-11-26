import 'package:flutter/material.dart';
import 'package:portfoliobuilders/constants/color.dart';
import 'package:portfoliobuilders/screens/blog_listscreen.dart';
import 'package:portfoliobuilders/screens/course_screen.dart';

import 'package:portfoliobuilders/screens/mycourses.dart';
import 'package:portfoliobuilders/screens/profilepage.dart';

class BaseScreen extends StatefulWidget {
  final String token;

  const BaseScreen({Key? key, required this.token}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  // Screens list where the token is passed to CourseScreen
  List<Widget> _getScreens(String token) {
    return [
      CourseScreen(token: token),
      MyCourseScreen(),
     // BlogListScreen(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Image.asset(
            'assets/icons/blue.png',
            width: 100,
            height: 50,
            fit: BoxFit.fill,
          ),
        ),
      ),
    
      body: _getScreens(widget.token)[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Color.fromARGB(255, 3, 17, 101),
        onTap: _onItemTapped,
        items: List.generate(
          _bottomNavIcons.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(_bottomNavIcons[index]),
            label: _bottomNavLabels[index],
          ),
        ).toList(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<IconData> _bottomNavIcons = [
    Icons.home,
    Icons.play_circle,
 //   Icons.my_library_books_rounded,
    Icons.account_circle,
  ];

  static const List<String> _bottomNavLabels = [
    'Home',
    'My Courses',
    'Profile',
  ];
}
