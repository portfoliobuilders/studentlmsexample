import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NoCoursesPage extends StatelessWidget {
  // Google Form URL
  final String googleFormUrl = 'https://forms.gle/yCUQuTVgH7Jbpqad8'; // Replace with your Google Form URL

  // Function to launch URL
  void _launchURL() async {
    if (await canLaunch(googleFormUrl)) {
      await launch(googleFormUrl);
    } else {
      throw 'Could not launch $googleFormUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Image
            Image.asset(
              'assets/icons/nocourse.png', // Replace with your image asset path
              height: 150.0,
              width: 150.0,
            ),
            SizedBox(height: 20.0),
            
            // Message
            Text(
              'No courses\nLooks like you have not enrolled for any course yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30.0),

            // Button
            ElevatedButton(
              onPressed: _launchURL,
              child: Text('Start Your Journey'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 4, 21, 134), // Text color
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
