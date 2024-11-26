// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:portfoliobuilders/constants/borders.dart';
// import 'package:portfoliobuilders/constants/color.dart';
// import 'package:portfoliobuilders/screens/course_screen.dart'; // Update the import to CourseScreen

// class OtpVerificationScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String orderId;

//   const OtpVerificationScreen({
//     Key? key,
//     required this.phoneNumber,
//     required this.orderId,
//   }) : super(key: key);

//   @override
//   _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final TextEditingController _otpController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _otpController.clear();
//   }

//   Future<void> _verifyOtp() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final urlString = 'https://lms-server-202k.onrender.com/api/v1/auth/verify_otp';
//     final url = Uri.parse(urlString);
//     final data = {
//       'phone_number': widget.phoneNumber,
//       'otp': _otpController.text,
//       'order_id': widget.orderId,
//     };

//     try {
//       final response = await http.post(
//         url,
//         body: jsonEncode(data),
//         headers: {
//           "Content-Type": "application/json",
//           "accept": "application/json",
//         },
//       );

//       final responseBody = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         final token = responseBody['data']['token'];

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token);
//         await prefs.setBool('is_logged_in', true);

//         _showMessage('OTP Verified', Colors.green);

//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => CourseScreen(token: token),
//           ),
//           (route) => false,
//         );
//       } else {
//         _handleError(responseBody);
//       }
//     } catch (e) {
//       _showMessage('An error occurred while verifying OTP. Please try again.', Colors.red);
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _handleError(Map<String, dynamic> responseBody) {
//     final errorMessage = responseBody['error'] != null ? responseBody['error']['message'] : 'OTP verification failed';
//     _showMessage(errorMessage, Colors.red);
//   }

//   void _showMessage(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//         backgroundColor: color,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 140, 20, 0),
//                   child: Image.asset('assets/icons/blue.png'), // Adjust path as per your assets
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(22),
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Enter OTP sent to ${widget.phoneNumber}',
//                           style: TextStyle(fontSize: 18, color: Colors.black54),
//                         ),
//                         const SizedBox(height: 20),
//                         TextFormField(
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             fillColor: kBackgroundColor,
//                             border: borders,
//                             focusedBorder: borders,
//                             enabledBorder: borders,
//                             hintText: 'OTP',
//                           ),
//                           controller: _otpController,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter OTP";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         _isLoading
//                             ? CircularProgressIndicator()
//                             : ElevatedButton(
//                                 onPressed: () async {
//                                   if (_formKey.currentState!.validate()) {
//                                     await _verifyOtp();
//                                   }
//                                 },
//                                 style: TextButton.styleFrom(
//                                   elevation: 8,
//                                   backgroundColor: const Color(0xFF9A7BFF),
//                                   minimumSize: const Size(double.infinity, 50),
//                                   shadowColor: const Color(0xFF9A7BFF),
//                                 ),
//                                 child: const Text(
//                                   'Verify OTP',
//                                   style: TextStyle(fontSize: 20, color: Color(0xFF030303)),
//                                 ),
//                               ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
