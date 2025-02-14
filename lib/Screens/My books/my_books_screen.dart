import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebook_app/Screens/My%20books/update_books.dart';
import 'package:rebook_app/backend/firebase_functions.dart';
import 'package:rebook_app/photos/images.dart';

class MyBooksScreen extends StatefulWidget {
  static const String routeName = 'my-services-screen';
  MyBooksScreen({super.key});

  @override
  State<MyBooksScreen> createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              Photos.logo,
              scale: 12,
            ),
            SizedBox(width: 10),
            Text(
              'My Books',
              style: GoogleFonts.domine(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF56ab91),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              // StreamBuilder for fetching services
              StreamBuilder(
                stream: FirebaseFunctions.getMyBooks(
                    FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(child: Text('No services available'));
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, UpdateBooks.routeName,
                                arguments: service);
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
                                        SizedBox(height: 8),
                                        // Button for adding to cart
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              // padding: EdgeInsets.all(16),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text("Delete Service"),
                                                    content: Text(
                                                        "Are you sure you want to delete this service?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              Text("Cancel")),
                                                      TextButton(
                                                          onPressed: () {
                                                            FirebaseFunctions
                                                                .deleteMyBooks(
                                                                    service
                                                                        .createdAt,
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              Text("Delete")),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ))
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
