import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinishOnboarding extends ChangeNotifier {
  bool finishOnBoarding = false;

  bool get isOnBoardingCompleted => finishOnBoarding;

  FinishOnboarding() {
    checkOnBoarding();
  }

  // Check if onboarding is already completed
  void checkOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    finishOnBoarding = prefs.getBool('isOnBoardingCompleted') ?? false;
    notifyListeners();
  }

  // Mark onboarding as completed
  Future<void> completeOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnBoardingCompleted', true);
    // finishOnBoarding = true;
    notifyListeners();
  }
}
