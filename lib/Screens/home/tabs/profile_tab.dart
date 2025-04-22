import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rebook_app/Screens/My%20books/my_books_screen.dart';
import 'package:rebook_app/Screens/add-services/sell_books_screen.dart';
import 'package:rebook_app/Screens/contact/contact-screen.dart';
import 'package:rebook_app/Screens/my%20Requests/my_requests_screen.dart';
import 'package:rebook_app/Screens/profile/user-profile-screen.dart';
import 'package:rebook_app/backend/firebase_functions.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60.0),
          StreamBuilder(
            stream: FirebaseFunctions.getUserProfile(
                FirebaseAuth.instance.currentUser?.uid ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading profile',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                    ),
                    const SizedBox(width: 18.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to Rebook App',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            "User name",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              var userData = snapshot.data!;

              return Row(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: (userData.profileImage ?? '').isNotEmpty
                        ? NetworkImage(userData.profileImage)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userData.firstName} ${userData.lastName}',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          userData.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 20.0),
          Divider(color: Colors.grey, thickness: 1.5),

          // Menu List
          Expanded(
            child: ListView(
              children: [
                _buildProfileOption(Icons.person, 'Profile', () {
                  Navigator.pushNamed(context, UserProfile.routeName);
                }),
                _buildProfileOption(Icons.shopping_cart, 'Sell Books', () {
                  // Navigate to BookSellingScreen
                  Navigator.pushNamed(context, SellBooksScreen.routeName);
                }),
                _buildProfileOption(Icons.book, 'My Books', () {
                  // Navigate to MyBooksScreen
                  Navigator.pushNamed(context, MyBooksScreen.routeName);
                }),
                _buildProfileOption(Icons.request_page, 'My Requests', () {
                  // Navigate to MyRequestsScreen
                  Navigator.pushNamed(context, MyRequestsScreen.routeName);
                }),
                _buildProfileOption(Icons.contact_mail, 'Contact Us', () {
                  // Navigate to ContactScreen
                  Navigator.pushNamed(context, ContactScreen.routeName);
                }),
                _buildProfileOption(Icons.logout, 'Logout', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
