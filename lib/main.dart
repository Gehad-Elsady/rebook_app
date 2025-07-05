import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rebook_app/Screens/Auth/login-screen.dart';
import 'package:rebook_app/Screens/Auth/signup-screen.dart';
import 'package:rebook_app/Screens/My%20books/my_books_screen.dart';
import 'package:rebook_app/Screens/My%20books/update_books.dart';
import 'package:rebook_app/Screens/OnBoarding/boarding-screen.dart';
import 'package:rebook_app/Screens/Search/search_screen.dart';
import 'package:rebook_app/Screens/SplashScreen/splash-screen.dart';
import 'package:rebook_app/Screens/add-services/sell_books_screen.dart';
import 'package:rebook_app/Screens/books/categories_screen.dart';
import 'package:rebook_app/Screens/books/info-screen.dart';
import 'package:rebook_app/Screens/cart/cart-screen.dart';
import 'package:rebook_app/Screens/contact/contact-screen.dart';
import 'package:rebook_app/Screens/history/historyscreen.dart';
import 'package:rebook_app/Screens/home/home-screen.dart';
import 'package:rebook_app/Screens/my%20Requests/my_requests_screen.dart';
import 'package:rebook_app/Screens/profile/user-profile-screen.dart';
import 'package:rebook_app/Screens/profile/payment_methods_screen.dart';
import 'package:rebook_app/backend/firebase_options.dart';
import 'package:rebook_app/notifications/notification.dart';
import 'package:rebook_app/provider/check-user.dart';
import 'package:rebook_app/provider/finish-onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // Initialize Firebase Messaging with error handling
  MyNotification.initialize();
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
        SellBooksScreen.routeName: (context) => SellBooksScreen(),
        MyBooksScreen.routeName: (context) => MyBooksScreen(),
        UpdateBooks.routeName: (context) => UpdateBooks(),
        BooksCategoriesScreen.routeName: (context) => BooksCategoriesScreen(),
        BooksSearchPage.routeName: (context) => BooksSearchPage(),
        UserProfile.routeName: (context) => UserProfile(),
        CartScreen.routeName: (context) => CartScreen(),
        InfoScreen.routeName: (context) => InfoScreen(),
        MyRequestsScreen.routeName: (context) => MyRequestsScreen(),
        HistoryScreen.routeName: (context) => HistoryScreen(),
        ContactScreen.routeName: (context) => ContactScreen(),
        PaymentMethodsScreen.routeName: (context) => PaymentMethodsScreen(),
      },
    );
  }
}
