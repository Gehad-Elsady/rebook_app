import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rebook_app/Screens/Auth/login-screen.dart';
import 'package:rebook_app/Screens/Auth/signup-screen.dart';
import 'package:rebook_app/Screens/My%20books/my_books_screen.dart';
import 'package:rebook_app/Screens/My%20books/update_books.dart';
import 'package:rebook_app/Screens/OnBoarding/boarding-screen.dart';
import 'package:rebook_app/Screens/SplashScreen/splash-screen.dart';
import 'package:rebook_app/Screens/add-services/sell_books_screen.dart';
import 'package:rebook_app/Screens/home/home-screen.dart';
import 'package:rebook_app/backend/firebase_options.dart';
import 'package:rebook_app/provider/check-user.dart';
import 'package:rebook_app/provider/finish-onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Optionally, initialize Firebase Analytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // Initialize Firebase Messaging with error handling
  // MyNotification.initialize();
  //   await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  //   appleProvider: AppleProvider.deviceCheck,
  // );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FinishOnboarding()),
    ChangeNotifierProvider(create: (_) => CheckUser()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        // UserProfile.routeName: (context) => UserProfile(),
        SellBooksScreen.routeName: (context) => SellBooksScreen(),
        // InfoScreen.routeName: (context) => InfoScreen(),
        // AddEng.routeName: (context) => AddEng(),
        // ContactScreen.routeName: (context) => ContactScreen(),
        // CartScreen.routeName: (context) => CartScreen(),
        // HistoryScreen.routeName: (context) => HistoryScreen(),
        // AddLandPage.routeName: (context) => AddLandPage(),
        // LandInfoScreen.routeName: (context) => LandInfoScreen(),
        MyBooksScreen.routeName: (context) => MyBooksScreen(),
        UpdateBooks.routeName: (context) => UpdateBooks(),
        // MyRequestsScreen.routeName: (context) => MyRequestsScreen(),
      },
    );
  }
}
