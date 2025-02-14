import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rebook_app/photos/images.dart';

class OnboardingPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(Photos.onBoarding1, height: 300),
          const SizedBox(height: 30),
          const Text(
            'Welcome to Rebook',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const Text(
            'Let’s make your reading experience better with Rebook',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
