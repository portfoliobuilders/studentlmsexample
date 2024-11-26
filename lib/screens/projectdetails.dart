import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:portfoliobuilders/models/project.dart';
import 'dart:convert';

class ProjectDetailsScreen extends StatefulWidget {
  final int? courseId;
  final int? moduleId;

  const ProjectDetailsScreen({
    Key? key,
    required this.courseId,
    required this.moduleId,
  }) : super(key: key);

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late Future<Project> _futureProject;

  @override
  void initState() {
    super.initState();
    _futureProject = fetchProjectDetails();
  }

  Future<Project> fetchProjectDetails() async {
    final response = await http.get(
      Uri.parse('https://lms-server-202k.onrender.com/api/v1/admin/course/${widget.courseId}/module/${widget.moduleId}/project/all'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'][0];
      return Project.fromJson(data);
    } else {
      throw Exception('Failed to load project details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Project>(
      future: _futureProject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final project = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Deadline: ${project.deadline.toLocal()}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                Text(
                  project.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Lessons to Unlock',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: project.lessonsToUnlock.length,
                    itemBuilder: (context, index) {
                      final lesson = project.lessonsToUnlock[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(lesson.name),
                          subtitle: Text(lesson.description),
                          trailing: IconButton(
                            icon: Icon(Icons.play_arrow),
                            onPressed: () {
                              // Handle URL launch
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
