import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rebook_app/backend/firebase_functions.dart';

class WelcomePart extends StatelessWidget {
  const WelcomePart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFunctions.readUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var userData = snapshot.data;
        String userName = userData?.name ?? 'User';

        return SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 25),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome to ReBook',
                        textStyle: GoogleFonts.domine(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () => print("Tap Event"),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: GoogleFonts.domine(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Discover the world of\nShared Books with us.",
                    style: GoogleFonts.domine(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Lottie.asset(
                    "assets/lotties/Animation - 1744065329456.json",
                    width: MediaQuery.of(context).size.width * 0.50,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
