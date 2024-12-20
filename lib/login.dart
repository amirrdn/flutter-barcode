import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sakaiapp/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';
import 'profile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
      errorMessage = '';
    });

    try {
      final result =
          await ApiService.login(emailController.text, passwordController.text);

      if (result['status'] == 'success') {
        final token = result['token'];
        final userData = result['data'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(userData));
        await prefs.setString('token', jsonEncode(token));

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      } else {
        if (!mounted) return;
        setState(() {
          errorMessage = result['message'];
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 20, 158, 226),
              Color.fromARGB(255, 30, 93, 125)
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.email, color: Colors.grey),
                                  hintText: 'Email',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(18),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.grey),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  hintText: 'Password',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(18),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                'Lupa password? Klik Disini',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00C6FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 16),
                              ),
                              onPressed: _isLoading ? null : _login,
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                            if (errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                children: [
                  Text(
                    'Belum memiliki Akun?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                    ),
                    child: Text(
                      'Buat Akun',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterStore()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
