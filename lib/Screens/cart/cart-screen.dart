import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rebook_app/Screens/cart/widget/cartitem.dart';
import 'package:rebook_app/Screens/checkout/address_form_screen.dart';
import 'package:rebook_app/Screens/history/model/historymaodel.dart';
import 'package:rebook_app/Screens/profile/model/profilemodel.dart';
import 'package:rebook_app/backend/firebase_functions.dart';
import 'package:rebook_app/location/location.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = 'cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("are-you-sure"),
                    actions: [
                      TextButton(
                        child: Text("yes"),
                        onPressed: () {
                          FirebaseFunctions.clearCart(
                              FirebaseAuth.instance.currentUser!.uid);
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("no"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
      body: Container(
        height: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFunctions.getCardStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset("assets/lotties/Animation - 1738160219532.json",
                      height: 400, width: double.infinity),
                  Text(
                    'Cart empty',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }

            // Calculate the total price by summing the prices of all items
            double totalPrice = snapshot.data!
                .map((item) => double.parse(
                    item.serviceModel.price)) // Safe parse with fallback
                .reduce((value, element) => value + element); // Sum all prices

            return Column(
              children: [
                // List of cart items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final service = snapshot.data![index].serviceModel;
                      String itemId = snapshot.data![index].itemId ?? "";
                      return Column(
                        children: [
                          CartItem(service: service, itemId: itemId),
                        ],
                      );
                    },
                  ),
                ),
                // Total price at the bottom of the page
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'total-price',
                        style: GoogleFonts.domine(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.domine(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'checkout',
                        style: GoogleFonts.domine(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      onPressed: () async {
                        try {
                          // Fetch the user profile
                          ProfileModel? profileModel =
                              await FirebaseFunctions.getUserProfile(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  .first;

                          if (profileModel == null) {
                            // Show an alert dialog if the profile is null
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('no-profile'),
                                  content: Text('profile-error'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Navigate to address form screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressFormScreen(
                                  cartItems: snapshot.data!,
                                  totalPrice: totalPrice,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          // Handle exceptions and display an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
