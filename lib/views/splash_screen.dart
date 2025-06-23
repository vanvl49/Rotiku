import 'package:flutter/material.dart';
import 'package:rotiku/views/get_started.dart';
import 'package:rotiku/views/roti_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GetStarted()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_rotiku.png',
              height: 300,
              width: 300,
            ),
            const Text(
              'Rotiku',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 214, 133, 99),
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 214, 133, 99),
            ),
          ],
        ),
      ),
    );
  }
}
