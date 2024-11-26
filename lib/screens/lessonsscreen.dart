import 'package:flutter/material.dart';
import 'package:portfoliobuilders/models/lessons.dart';
import 'package:portfoliobuilders/screens/LessonDetailsScreen.dart';
import 'package:portfoliobuilders/screens/authservice.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonsScreen extends StatefulWidget {
  final int moduleId;
  final int courseId;

  const LessonsScreen({Key? key, required this.moduleId, required this.courseId}) : super(key: key);

  @override
  _LessonsScreenState createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  late Future<List<Lesson>> futureLessons;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, YoutubePlayerController> _youtubeControllers = {};

  @override
  void initState() {
    super.initState();
    futureLessons = fetchLessons(widget.moduleId);
  }

  Future<List<Lesson>> fetchLessons(int moduleId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Token not found');

    final response = await http.get(
      Uri.parse('https://lms-server-202k.onrender.com/api/v1/courses/${widget.courseId}/modules/$moduleId/lessons/all'),
      headers: {
        "Content-Type": "application/json",
        "x-portfolio-builders-auth": token,
      },
    );

    if (response.statusCode == 200) {
      return Lesson.fromJsonList(response.body);
    } else {
      throw Exception('Failed to load lessons: ${response.reasonPhrase}');
    }
  }

  void _initializeController(int lessonId, String url) {
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      final youtubeId = YoutubePlayer.convertUrlToId(url);
      if (youtubeId != null && !_youtubeControllers.containsKey(lessonId)) {
        final YoutubePlayerController controller = YoutubePlayerController(
          initialVideoId: youtubeId,
          flags: YoutubePlayerFlags(autoPlay: false),
        );
        _youtubeControllers[lessonId] = controller;
      }
    } else {
      if (!_videoControllers.containsKey(lessonId)) {
        final VideoPlayerController controller = VideoPlayerController.network(url)
          ..initialize().then((_) {
            setState(() {}); // Refresh to show video
          });
        _videoControllers[lessonId] = controller;
      }
    }
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
        
        "lessons",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 54, 14, 212), Color(0xFF2D05CE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Lesson>>(
          future: futureLessons,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No lessons available.'));
            }

            final lessons = snapshot.data!;

            return LayoutBuilder(
              builder: (context, constraints) {
                final isPortrait = constraints.maxWidth < constraints.maxHeight;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(isPortrait ? 8.0 : 16.0),
                    child: Column(
                      children: lessons.map((lesson) {
                        _initializeController(lesson.id, lesson.url);
                        return LessonTile(
                          lesson: lesson,
                          isPortrait: isPortrait,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LessonDetailsScreen(
                                  lesson: lesson,
                                  videoControllers: _videoControllers,
                                  youtubeControllers: _youtubeControllers,
                                  onLaunchURL: _launchURL,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _videoControllers.values.forEach((controller) => controller.dispose());
    _youtubeControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}

class LessonTile extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final bool isPortrait;

  const LessonTile({
    Key? key,
    required this.lesson,
    required this.onTap,
    required this.isPortrait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: isPortrait ? 8 : 16),
    child:   ListTile(
  contentPadding: EdgeInsets.all(isPortrait ? 8.0 : 16.0),
  title: Text(
    lesson.name,
    style: TextStyle(fontSize: isPortrait ? 16.0 : 18.0),
  ),
  subtitle: Text(
    lesson.description,
    style: TextStyle(fontSize: isPortrait ? 14.0 : 16.0),
  ),
  leading: CircleAvatar(
    backgroundColor: Color.fromARGB(255, 16, 30, 122), // Set your desired color here
    child: Text(""), // Optional: add text or an icon here
  ),
  trailing: Icon(
    Icons.arrow_forward,
    color: Color.fromARGB(255, 9, 39, 137), // Set your desired color here
  ),
  onTap: onTap,
)


    );
  }
}
