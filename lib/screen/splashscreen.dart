import 'package:flutter/material.dart';
import 'dart:async';
import 'package:murobi_beta/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginWidget()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: const Color(0xFF99D399),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/SplashScreen.png"),
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
