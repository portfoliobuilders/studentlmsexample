import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:portfoliobuilders/models/course_model.dart';
import 'package:portfoliobuilders/screens/carosel.dart';
import 'package:portfoliobuilders/screens/categories.dart';
import 'package:portfoliobuilders/screens/details_screen.dart';

class CourseScreen extends StatefulWidget {
  final String token;

  const CourseScreen({Key? key, required this.token}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> with SingleTickerProviderStateMixin {
  late Future<List<Course>> _futureCourses;
  late AnimationController _animationController;

  final List<String> imageUrls = [
    'assets/icons/uiux.png',
    'assets/icons/flutter.png',
    'assets/images/ds.png',
  ];

  final List<Map<String, String>> slides = [
    {
      "imageUrl": "assets/icons/athul.png",
      "title": "Transform Ideas",
      "description": "From Concept to Creation: UI/UX Design Excellence"
    },
    {
      "imageUrl": "assets/icons/jomon.png",
      "title": "App Development",
      "description": "Crafting Intuitive and Engaging User Experiences"
    },
    {
      "imageUrl": "assets/icons/both.png",
      "title": "Elevate Your Skills",
      "description": "Master the Art of tech career with Expert Guidance"
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _futureCourses = fetchCourses();
    });
  }

  Future<List<Course>> fetchCourses() async {
    try {
      final response = await http.get(
        Uri.parse('https://lms-server-202k.onrender.com/api/v1/courses/all'),
        headers: {
          "Content-Type": "application/json",
          "x-portfolio-builders-auth": widget.token,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> coursesJson = jsonDecode(response.body)['data'];
        return coursesJson.map((json) => Course.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchCourses,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Slider
           CarouselSlider.builder(
  itemCount: slides.length,
  itemBuilder: (context, index, realIndex) {
    return CarouselCard(
      imageUrl: slides[index]["imageUrl"]!,
      title: slides[index]["title"]!,
      description: slides[index]["description"]!,
      googleFormUrl: 'https://forms.gle/yCUQuTVgH7Jbpqad8', // Replace with your Google Form URL
    );
  },
  options: CarouselOptions(
    height: 180, // Adjust the carousel height
    enlargeCenterPage: true,
    autoPlay: true,
    aspectRatio: 16 / 9,
    autoPlayCurve: Curves.fastOutSlowIn,
    enableInfiniteScroll: true,
    autoPlayAnimationDuration: Duration(milliseconds: 800),
    viewportFraction: 0.8,
  ),
),

            // Categories Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CategoriesScreen(), // Add CategoriesScreen here
            ),
            // Top Courses Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Top Courses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Courses List
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _futureCourses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Course course = snapshot.data![index];
                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + 0.02 * _animationController.value,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(course: course),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15),
                                        ),
                                        child: Image.asset(
                                          imageUrls[index % imageUrls.length],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              course.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No courses available.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
