import 'package:flutter/material.dart';
import 'package:rebook_app/photos/images.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(Photos.onBoarding2, height: 300),
          const SizedBox(height: 30),
          const Text(
            'Manage your books and share with others.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const Text(
            "You can manage your books and share with others by adding them to the shop list where clients can find and buy it.",
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
