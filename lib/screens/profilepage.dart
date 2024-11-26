import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:portfoliobuilders/screens/Login.dart';
import 'package:portfoliobuilders/screens/authservice.dart'; // Import AuthService
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = ''; // Example name
  String _contact = ''; // Example contact

  @override
  void initState() {
    super.initState();
    // Fetch and set user details here, if needed
    // _fetchUserDetails();
  }

 Future<void> _logout() async {
  try {
    // Retrieve the token from localStorage or other secure storage
    String? token = await AuthService.getToken();

    if (token == null) {
      // If no token is found, navigate to the login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthLoginAndOtpScreen()), 
        (Route<dynamic> route) => false,
      );
      return;
    }

    // Make an API call to the logout endpoint to invalidate the token
    final response = await http.post(
      Uri.parse('https://lms-server-202k.onrender.com/api/v1/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'x-portfolio-builders-auth': token, // Pass the token in the header
      },
      body: jsonEncode({}), // Include any required body parameters if needed
    );

    if (response.statusCode == 200) {
      // Successfully logged out on the server
      print('Logout successful');
      
      // Remove the token from localStorage or secure storage
      await AuthService.removeToken();
      
      // Navigate to the login screen and remove previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthLoginAndOtpScreen()), 
        (Route<dynamic> route) => false,
      );
    } else {
      // Handle errors, e.g., token already invalidated
      print('Error during logout: ${response.body}');
      
      // Optionally, remove the token and still navigate to login
      await AuthService.removeToken();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthLoginAndOtpScreen()), 
        (Route<dynamic> route) => false,
      );
    }
  } catch (e) {
    // Handle sign-out errors if necessary
    print('Error during logout: $e');
    
    // Remove the token and navigate to the login screen
    await AuthService.removeToken();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AuthLoginAndOtpScreen()), 
      (Route<dynamic> route) => false,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: () {
                // Implement profile picture upload functionality here
                print('Uploading profile photo');
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Set the color to white
                  border: Border.all(color: Colors.blueAccent, width: 4), // Optional border
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icons/user.png', // Asset image
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Name
            Text(
              _name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              _contact,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40.0),
            // Additional user information or actions
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Information',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'More details about the user can be added here.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Logout Button
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 53, 22, 176), // Button color
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 5,
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
