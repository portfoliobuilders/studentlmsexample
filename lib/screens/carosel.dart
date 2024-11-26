import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class CarouselCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String googleFormUrl; // Add this to handle the Google Form URL

  CarouselCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.googleFormUrl, // Add this to the constructor
  });

  // Method to launch the URL
  Future<void> _launchURL() async {
    if (await canLaunch(googleFormUrl)) {
      await launch(googleFormUrl);
    } else {
      throw 'Could not launch $googleFormUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1D0093), Color(0xFF2D05CE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _launchURL, // Call the method to launch the URL
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF3E3E3E), backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Enroll Now',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 120, // Adjust the height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
