import 'package:flutter/material.dart';
import 'package:portfoliobuilders/models/course_model.dart';
import 'package:portfoliobuilders/models/module.dart';
import 'package:portfoliobuilders/screens/authservice.dart';
import 'package:http/http.dart' as http;
import 'package:portfoliobuilders/screens/lessonsscreen.dart';

class ModulesScreen extends StatefulWidget {
  final Course course;
  final int courseId;

  const ModulesScreen({Key? key, required this.course, required this.courseId}) : super(key: key);

  @override
  _ModulesScreenState createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  late Future<List<Module>> futureModules;

  @override
  void initState() {
    super.initState();
    futureModules = fetchModules(widget.courseId); // Fetch modules based on courseId
  }

  Future<List<Module>> fetchModules(int courseId) async {
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('https://lms-server-202k.onrender.com/api/v1/courses/$courseId/modules/all'),
      headers: {
        "Content-Type": "application/json",
        "x-portfolio-builders-auth": token,
      },
    );

    if (response.statusCode == 200) {
      return Module.fromJsonList(response.body);
    } else {
      throw Exception('Failed to load modules: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: FutureBuilder<List<Module>>(
        future: futureModules,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final modules = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  ...modules.map((module) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      title: Text(module.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(module.description),
                      leading: CircleAvatar(
                       
                        backgroundColor: Color.fromARGB(255, 36, 33, 184),
                      
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LessonsScreen(
                              moduleId: module.id,
                              courseId: widget.courseId,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
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
