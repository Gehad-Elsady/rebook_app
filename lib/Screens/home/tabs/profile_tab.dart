import 'package:flutter/material.dart';
import 'package:rebook_app/Screens/My%20books/my_books_screen.dart';
import 'package:rebook_app/Screens/add-services/sell_books_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.0),

          // Profile Header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 50.0,
                child: const Text(
                  'P',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Name',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Profile Email',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.0),
          Divider(color: Colors.grey, thickness: 1.5),

          // Menu List
          Expanded(
            child: ListView(
              children: [
                _buildProfileOption(Icons.person, 'Profile', () {}),
                _buildProfileOption(Icons.shopping_cart, 'Sell Books', () {
                  // Navigate to BookSellingScreen
                  Navigator.pushNamed(context, SellBooksScreen.routeName);
                }),
                _buildProfileOption(Icons.book, 'My Books', () {
                  // Navigate to MyBooksScreen
                  Navigator.pushNamed(context, MyBooksScreen.routeName);
                }),
                _buildProfileOption(Icons.request_page, 'My Requests', () {}),
                _buildProfileOption(Icons.contact_mail, 'Contact Us', () {}),
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
