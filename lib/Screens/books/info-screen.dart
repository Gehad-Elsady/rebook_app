import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebook_app/Screens/add-services/model/service-model.dart';
import 'package:rebook_app/Screens/cart/model/cart-model.dart';
import 'package:rebook_app/backend/firebase_functions.dart';

class InfoScreen extends StatelessWidget {
  static const String routeName = 'seeds-info-screen';

  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var model = ModalRoute.of(context)?.settings.arguments as ServiceModel?;

    if (model == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Book Details'),
        ),
        body: const Center(
          child: Text('No service details available.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '${model.name ?? 'Book Details'}',
          style: GoogleFonts.domine(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
          onPressed: () async {
            CartModel cartData = CartModel(
              itemId:
                  "", // Placeholder, actual itemId will be set in FirebaseFunctions
              serviceModel: model,
              userId: FirebaseAuth.instance.currentUser!.uid,
            );
            await FirebaseFunctions.addCartService(cartData);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Book added successfully!'),
              ),
            );
          },
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add_shopping_cart_rounded,
            color: Colors.blue,
            size: 40,
          ),
          elevation: 8,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: model.image ?? '',
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.redAccent,
                            size: 40,
                          ),
                        ),
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 280,
                      ),
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Text(
                          model.name ?? 'No Name Available',
                          style: GoogleFonts.domine(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Product Overview:\n ${model.description ?? 'No Description Available'}',
                      style: GoogleFonts.lato(
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: 'Price: '),
                          TextSpan(
                            text: model.price != null
                                ? '\$${model.price}'
                                : 'Not Available',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: model.price != null
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Types: ${model.type ?? 'No Types Available'}',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Handle add to cart action
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(0xFF6EDE8A),
              //       padding: const EdgeInsets.symmetric(
              //           vertical: 14, horizontal: 32),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     child: Text(
              //       'Add to Cart',
              //       style: GoogleFonts.domine(
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
