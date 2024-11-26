import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CategoryCard(
                borderColor: Color(0xFF5E5E5E),
                title: 'Coding',
                subtitle: '3 Courses',
                icon: Icons.code, // Add the desired icon here
              ),
              CategoryCard(
                borderColor: Color(0xFF696969),
                title: 'Creative',
                subtitle: '4 Courses',
                icon: Icons.palette, // Add the desired icon here
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Color borderColor;
  final String title;
  final String subtitle;
  final IconData icon; // Added icon parameter

  const CategoryCard({
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175, // Original width
      height: 60, // Original height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        color: Colors.white, // Default background color
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 40, // Adjust icon size
            color: borderColor, // Icon color
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
