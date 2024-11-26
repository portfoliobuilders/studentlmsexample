import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfoliobuilders/models/lessons.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonDetailsScreen extends StatefulWidget {
  final Lesson lesson;
  final Map<int, VideoPlayerController> videoControllers;
  final Map<int, YoutubePlayerController> youtubeControllers;
  final void Function(String) onLaunchURL;

  const LessonDetailsScreen({
    Key? key,
    required this.lesson,
    required this.videoControllers,
    required this.youtubeControllers,
    required this.onLaunchURL,
  }) : super(key: key);

  @override
  _LessonDetailsScreenState createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  String _selectedQuality = '720p'; // Default quality

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setOrientationBasedOnMode();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setOrientationBasedOnMode();
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  void _setOrientationBasedOnMode() {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isYouTubeUrl = widget.lesson.url.contains('youtube.com') || widget.lesson.url.contains('youtu.be');
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.lesson.name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: isLandscape
          ? _buildFullScreenVideo()
          : _buildPortraitContent(context, isYouTubeUrl),
    );
  }

  Widget _buildFullScreenVideo() {
    final isYouTubeUrl = widget.lesson.url.contains('youtube.com') || widget.lesson.url.contains('youtu.be');

    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: isYouTubeUrl
            ? YoutubePlayer(
                controller: widget.youtubeControllers[widget.lesson.id]!,
                showVideoProgressIndicator: true,
              )
            : AspectRatio(
                aspectRatio: widget.videoControllers[widget.lesson.id]!.value.aspectRatio,
                child: VideoPlayer(widget.videoControllers[widget.lesson.id]!),
              ),
      ),
    );
  }

  Widget _buildPortraitContent(BuildContext context, bool isYouTubeUrl) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5.0)],
            ),
            child: isYouTubeUrl
                ? YoutubePlayer(
                    controller: widget.youtubeControllers[widget.lesson.id]!,
                    showVideoProgressIndicator: true,
                  )
                : AspectRatio(
                    aspectRatio: widget.videoControllers[widget.lesson.id]!.value.aspectRatio,
                    child: VideoPlayer(widget.videoControllers[widget.lesson.id]!),
                  ),
          ),
          SizedBox(height: 16),
         
          SizedBox(height: 16),
          Text('Description:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 18, 0, 48))),
          SizedBox(height: 8),
          Text(widget.lesson.description, style: TextStyle(fontSize: 16, color: Colors.black87)),
          SizedBox(height: 16),
          Text('Documents:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 0, 20))),
          SizedBox(height: 8),
          ...widget.lesson.docUrls.map((docUrl) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ElevatedButton(
                onPressed: () => widget.onLaunchURL(docUrl),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 9, 39, 137), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Break Out Activity', style: TextStyle(fontSize: 16),),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
