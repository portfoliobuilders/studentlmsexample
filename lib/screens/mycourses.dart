import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:portfoliobuilders/models/course_model.dart';
import 'package:portfoliobuilders/screens/authservice.dart';
import 'package:portfoliobuilders/screens/details_screen.dart';
import 'package:portfoliobuilders/screens/mycoursescreendetails.dart';
import 'package:portfoliobuilders/screens/nocourse.dart';

class MyCourseScreen extends StatefulWidget {
  const MyCourseScreen({Key? key}) : super(key: key);

  @override
  _MyCourseScreenState createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  late Future<List<Course>> futuremyCourses;
  List<String> imageUrls = [
    'assets/icons/uiux.png',
    'assets/icons/flutter.png',
    'assets/images/ds.png',
  ];

  @override
  void initState() {
    super.initState();
    futuremyCourses = fetchmyCourses();
  }

  Future<List<Course>> fetchmyCourses() async {
    final token = await AuthService.getToken(); // Retrieve the token

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('https://lms-server-202k.onrender.com/api/v1/courses/my'),
        headers: {
          "Content-Type": "application/json",
          "x-portfolio-builders-auth": token,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> coursesJson = jsonDecode(response.body)['data'];
        return coursesJson.map((json) => Course.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception('Unauthorized: Please check your authentication token.');
      } else {
        throw Exception('Failed to load courses: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color.fromARGB(255, 20, 45, 137),
      ),
      body: FutureBuilder<List<Course>>(
        future: futuremyCourses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              // If no courses, show the "No Courses" page
              return NoCoursesPage();
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    Course course = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => mycourseDetailsScreen(course: course),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(15),
                              ),
                              child: Image.asset(
                                imageUrls[index % imageUrls.length],
                                width: 120, // Adjust the width as needed
                                height: 90, // Adjust the height as needed
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}