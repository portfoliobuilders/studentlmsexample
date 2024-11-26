import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:portfoliobuilders/constants/borders.dart';
import 'package:portfoliobuilders/constants/color.dart';
import 'package:portfoliobuilders/screens/authservice.dart';
import 'package:portfoliobuilders/screens/base_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLoginAndOtpScreen extends StatefulWidget {
  const AuthLoginAndOtpScreen({Key? key}) : super(key: key);

  @override
  State<AuthLoginAndOtpScreen> createState() => _AuthLoginAndOtpScreenState();
}

class _AuthLoginAndOtpScreenState extends State<AuthLoginAndOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _phoneNumber;
  String? _orderId;
  String? _name;
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;
  int _start = 120; // Timer for 2 minutes
  Timer? _timer; // Make _timer nullable
  bool _isCheckingAuth = true; // Flag to manage authentication check

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  void _checkAutoLogin() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      final token = await AuthService.getToken();
      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BaseScreen(token: token),
          ),
        );
      } else {
        setState(() {
          _isCheckingAuth = false; // Update state when auth check is done
        });
      }
    } else {
      setState(() {
        _isCheckingAuth = false; // Update state when auth check is done
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _register() async {
    if (_phoneNumber == null) {
      _showErrorMessage('Please enter a valid phone number');
      return;
    }

    var urlString = 'https://lms-server-202k.onrender.com/api/v1/auth/send_otp';
    var url = Uri.parse(urlString);
    String formattedPhoneNumber = _phoneNumber!.startsWith('+') ? _phoneNumber! : '+$_phoneNumber';

    var data = {
      'phone_number': formattedPhoneNumber,
    };

    try {
      var response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        _orderId = responseData['data']['orderId'];

        _showSuccessMessage('OTP Sent');
        setState(() {
          _isOtpSent = true;
          _start = 120; // Reset timer
          _startTimer();
        });
      } else {
        _showErrorMessage('OTP request failed');
      }
    } catch (e) {
      _showErrorMessage('Error occurred');
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    final urlString = 'https://lms-server-202k.onrender.com/api/v1/auth/verify_otp';
    final url = Uri.parse(urlString);
    final data = {
      'phone_number': _phoneNumber!,
      'otp': _otpController.text,
      'order_id': _orderId!,
      'name' : _name!,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseBody['data']['token'];

        await AuthService.setToken(token);

        _showMessage('OTP Verified', Colors.green);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => BaseScreen(token: token),
          ),
          (route) => false,
        );
      } else {
        _handleError(responseBody);
      }
    } catch (e) {
      _showMessage('An error occurred while verifying OTP. Please try again.', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleError(Map<String, dynamic> responseBody) {
    final errorMessage = responseBody['error'] != null ? responseBody['error']['message'] : 'OTP verification failed';
    _showMessage(errorMessage, Colors.red);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Use ? to avoid calling cancel on an uninitialized timer
    _otpController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAuth) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final minutes = (_start / 60).floor();
    final seconds = _start % 60;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Center-align elements
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Image.asset(
                    'assets/icons/blue.png',
                    width: 200.0,
                    height: 100.0,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center-align elements
                      children: [
                        if (!_isOtpSent) ...[
                          IntlPhoneField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kBackgroundColor,
                              border: borders,
                              focusedBorder: borders,
                              enabledBorder: borders,
                              hintText: 'Phone Number',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              setState(() {
                                _phoneNumber = phone.completeNumber!;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kBackgroundColor,
                              border: borders,
                              focusedBorder: borders,
                              enabledBorder: borders,
                              hintText: 'Name',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _register();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 8, backgroundColor: Color.fromARGB(255, 11, 2, 41),
                              minimumSize: const Size(double.infinity, 50),
                              shadowColor: Color.fromARGB(255, 12, 29, 93),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Send OTP',
                              style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 240, 240, 240)),
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Enter OTP sent to $_phoneNumber',
                            style: const TextStyle(fontSize: 18, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: kBackgroundColor,
                              border: borders,
                              focusedBorder: borders,
                              enabledBorder: borders,
                              hintText: 'OTP',
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.all(16),
                            ),
                            controller: _otpController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter OTP";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Time remaining: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          const SizedBox(height: 20),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await _verifyOtp();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 8, backgroundColor: Color.fromARGB(255, 13, 0, 56),
                                    minimumSize: const Size(double.infinity, 50),
                                    shadowColor: Color.fromARGB(255, 60, 51, 88),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Verify OTP',
                                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 214, 206, 206)),
                                  ),
                                ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
