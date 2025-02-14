import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rebook_app/Screens/home/home-screen.dart';

class SellBooksScreen extends StatefulWidget {
  static const String routeName = 'SellBooksPage';

  @override
  _SellBooksScreenState createState() => _SellBooksScreenState();
}

class _SellBooksScreenState extends State<SellBooksScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  // Dropdown variables
  // String? _selectedServiceType;
  // final List<String> _serviceTypes = ['Seeds', 'Equipment', "crops"];

  // Pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Upload image to Firebase Storage and get URL
  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('books_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Save service data to Firestore
  Future<void> _saveService() async {
    if (_formKey.currentState!.validate() && _image != null) {
      setState(() => _isUploading = true);
      final imageUrl = await _uploadImage(_image!);

      if (imageUrl != null) {
        await FirebaseFirestore.instance.collection('Books').add({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'price': _priceController.text.trim(),
          'image': imageUrl,
          'createdAt': Timestamp.now(),
          'userId': FirebaseAuth.instance.currentUser!.uid
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Book added successfully')));
        Navigator.pushReplacementNamed(
            context, HomeScreen.routeName); // Go back after saving
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload image')));
      }
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sell Books',
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24),

                // Service Name
                TextFormField(
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Book Name',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    // Define the border
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color when enabled
                        width: 2.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color when focused
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                SizedBox(height: 16),

                // Description
                TextFormField(
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    // Define the border
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color when enabled
                        width: 2.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color when focused
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                SizedBox(height: 16),

                // Price
                TextFormField(
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    // Define the border
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color when enabled
                        width: 2.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color when focused
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                ),
                SizedBox(height: 16),

                // Service Type Dropdown
                // DropdownButtonFormField<String>(
                //   style: const TextStyle(color: Colors.black, fontSize: 20),
                //   decoration: InputDecoration(
                //     labelText: 'Book Type',
                //     labelStyle: const TextStyle(
                //       color: Colors.black,
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //     // Define the border
                //     border: OutlineInputBorder(
                //       borderRadius:
                //           BorderRadius.circular(10.0), // Rounded corners
                //       borderSide: const BorderSide(
                //         color: Colors.black, // Border color
                //         width: 2.0, // Border width
                //       ),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //       borderSide: const BorderSide(
                //         color: Colors.black, // Border color when enabled
                //         width: 2.0, // Border width
                //       ),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //       borderSide: const BorderSide(
                //         color: Colors.black, // Border color when focused
                //         width: 2.0, // Border width
                //       ),
                //     ),
                //   ),
                //   value: _selectedServiceType,
                //   icon: const Icon(Icons.arrow_drop_down,
                //       color: Colors.black), // black dropdown icon
                //   dropdownColor: Color.fromARGB(255, 13, 56, 43),
                //   items: _serviceTypes
                //       .map((type) => DropdownMenuItem(
                //             value: type,
                //             child: Text(type),
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedServiceType = value;
                //     });
                //   },
                //   validator: (value) =>
                //       value == null ? 'Please select a service type' : null,
                // ),
                SizedBox(height: 16),

                // Image Picker
                _image == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No image selected',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      )
                    : Image.file(_image!, height: 150, fit: BoxFit.cover),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text(
                    'Pick Image',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Submit Button
                _isUploading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _saveService,
                        child: Text(
                          'Sell Book',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
