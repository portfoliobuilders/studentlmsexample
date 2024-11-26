import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:portfoliobuilders/constants/color.dart';
import 'package:portfoliobuilders/models/course_model.dart';
import 'package:portfoliobuilders/screens/details_screen.dart';
import 'package:portfoliobuilders/screens/form.dart';
import 'package:portfoliobuilders/screens/modules.dart';

class mycourseDetailsScreen extends StatefulWidget {
  final Course course;

  const mycourseDetailsScreen({Key? key, required this.course}) : super(key: key);

  @override
  _mycourseDetailsScreenState createState() => _mycourseDetailsScreenState();
}

class _mycourseDetailsScreenState extends State<mycourseDetailsScreen> {
  int _selectedTag = 0;

  void changeTab(int index) {
    setState(() {
      _selectedTag = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.course.name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1D0093), Color(0xFF2D05CE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    initialPage: 0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                  ),
                  items: [
                    _buildCarouselItem('assets/icons/we.png'),
                    _buildCarouselItem('assets/icons/me.png'),
                   _buildCarouselItem('assets/icons/he.png'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.black),
                    Text(
                      " 4.8",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 15),
                    Icon(Icons.timer, color: const Color.fromARGB(255, 0, 0, 0)),
                    Text(
                      " ${widget.course.duration} Months",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 20),
                CustomTabView(index: _selectedTag, changeTab: changeTab),
                SizedBox(height: 20),
                _selectedTag == 0
                    ? ModulesScreen(course: widget.course, courseId: widget.course.id)
                    : CourseCurriculum(course: widget.course),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CourseCurriculum extends StatelessWidget {
  final Course course;

  const CourseCurriculum({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Course Curriculum:',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18,
            //   ),
            // ),
            SizedBox(height: 10),
            // Text(
            //   course.description,
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.grey.shade600,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomTabView extends StatefulWidget {
  final Function(int) changeTab;
  final int index;

  const CustomTabView({
    Key? key,
    required this.changeTab,
    required this.index,
  }) : super(key: key);

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  final List<String> _tags = ["Modules",];

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        widget.changeTab(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .08,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: widget.index == index ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (widget.index == index)
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
          ],
        ),
        child: Text(
          _tags[index],
          style: TextStyle(
            color: widget.index != index ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: widget.index != index ? FontWeight.w700 : FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _tags
            .asMap()
            .entries
            .map((MapEntry map) => _buildTags(map.key))
            .toList(),
      ),
    );
  }
}
