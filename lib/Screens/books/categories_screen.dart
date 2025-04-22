import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rebook_app/Screens/books/info-screen.dart';
import 'package:rebook_app/backend/firebase_functions.dart';

class BooksCategoriesScreen extends StatefulWidget {
  static const String routeName = 'categories-screen';
  BooksCategoriesScreen({super.key});

  @override
  State<BooksCategoriesScreen> createState() => _BooksCategoriesScreenState();
}

class _BooksCategoriesScreenState extends State<BooksCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    var category = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: GoogleFonts.domine(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              // StreamBuilder for fetching services
              StreamBuilder(
                stream: FirebaseFunctions.getBookCategory(category),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                        child: Lottie.asset(
                            "assets/lotties/Animation - 1744069824873.json"));
                  } else {
                    return GridView.builder(
                      shrinkWrap:
                          true, // Allows GridView to be scrollable within the SingleChildScrollView
                      physics:
                          NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final service = snapshot.data![index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              InfoScreen.routeName,
                              arguments: service,
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16), // Rounded corners
                            ),
                            elevation: 5, // Shadow effect
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  16), // Rounded corners for the image
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Image section
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: service.image,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  // Text for name and price
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          service.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "${service.price} EGP",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors
                                                .green[700], // Price in green
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
