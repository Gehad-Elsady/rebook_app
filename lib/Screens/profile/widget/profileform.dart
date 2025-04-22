// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:road_mate/backend/firebase_functions.dart';

// class ProfileForm extends StatelessWidget {
//   const ProfileForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Form(
//         key: _formKey,
//         child: ListView(
//           children: [
//             Center(
//               child: GestureDetector(
//                 onTap: _pickImage,
//                 child: CircleAvatar(
//                   radius: 100,
//                   backgroundImage: _imageFile != null
//                       ? FileImage(_imageFile!)
//                       : _downloadURL != null && _downloadURL!.isNotEmpty
//                           ? NetworkImage(_downloadURL!)
//                           : const NetworkImage(
//                               'https://via.placeholder.com/150',
//                             ) as ImageProvider,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 50),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     style: const TextStyle(color: Colors.white),
//                     controller: firstName,
//                     decoration: InputDecoration(
//                         labelText: 'first-name'.tr(),
//                         labelStyle: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         )),
//                     validator: (value) =>
//                         value!.isEmpty ? 'first-name-error'.tr() : null,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextFormField(
//                     style: const TextStyle(color: Colors.white),
//                     controller: lastName,
//                     decoration: InputDecoration(
//                         labelText: 'last-name'.tr(),
//                         labelStyle: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         )),
//                     validator: (value) =>
//                         value!.isEmpty ? 'last-name-error'.tr() : null,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             TextFormField(
//               style: const TextStyle(color: Colors.white),
//               controller: email,
//               decoration: InputDecoration(
//                   labelText: 'email'.tr(),
//                   labelStyle: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   )),
//               validator: Validation.validateEmail(email.text),
//             ),
//             const SizedBox(height: 30),
//             TextFormField(
//               style: const TextStyle(color: Colors.white),
//               controller: address,
//               decoration: InputDecoration(
//                   labelText: 'address'.tr(),
//                   labelStyle: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   )),
//               validator: (value) =>
//                   value!.isEmpty ? 'address-error'.tr() : null,
//             ),
//             const SizedBox(height: 30),
//             TextFormField(
//               style: const TextStyle(color: Colors.white),
//               controller: contactNumber,
//               decoration: InputDecoration(
//                   labelText: 'phone-number'.tr(),
//                   labelStyle: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   )),
//               validator: (value) =>
//                   value!.isEmpty ? 'phone-number-error'.tr() : null,
//             ),
//             const SizedBox(height: 30),
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     style: const TextStyle(color: Colors.black),
//                     value: city.text.isEmpty ? null : city.text,
//                     items: ['Mehrab', 'City 2', 'City 3']
//                         .map((city) =>
//                             DropdownMenuItem(value: city, child: Text(city)))
//                         .toList(),
//                     onChanged: (value) => setState(() => city.text = value!),
//                     decoration: InputDecoration(
//                         labelText: 'city'.tr(),
//                         labelStyle: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         )),
//                     validator: (value) =>
//                         value == null ? 'city-error'.tr() : null,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     style: const TextStyle(color: Colors.black),
//                     value: state.text.isEmpty ? null : state.text,
//                     items: ['Bozorgi', 'State 2', 'State 3']
//                         .map((state) =>
//                             DropdownMenuItem(value: state, child: Text(state)))
//                         .toList(),
//                     onChanged: (value) => setState(() => state.text = value!),
//                     decoration: InputDecoration(
//                         labelText: 'state'.tr(),
//                         labelStyle: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         )),
//                     validator: (value) =>
//                         value == null ? 'state-error'.tr() : null,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 OutlinedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     backgroundColor: Colors.red,
//                     shape: const StadiumBorder(),
//                     side: const BorderSide(
//                       color: Colors.red,
//                       width: 2,
//                     ),
//                   ),
//                   child: Text('cancel'.tr(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       )),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await _uploadImage(); // Upload the image before saving
//                     if (_formKey.currentState!.validate()) {
//                       ProfileModel data = ProfileModel(
//                         firstName: firstName.text,
//                         lastName: lastName.text,
//                         address: address.text,
//                         phoneNumber: contactNumber.text,
//                         city: city.text,
//                         state: state.text,
//                         email: email.text,
//                         profileImage: _downloadURL ??
//                             "", // Use existing URL if no image selected
//                         id: FirebaseAuth.instance.currentUser!.uid,
//                       );
//                       FirebaseFunctions.addUserProfile(data);
//                       firstName.clear();
//                       lastName.clear();
//                       address.clear();
//                       contactNumber.clear();
//                       city.clear();
//                       state.clear();
//                       email.clear();
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('profile-saved'.tr())),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     backgroundColor: Colors.green,
//                     shape: const StadiumBorder(),
//                     side: const BorderSide(
//                       color: Colors.green,
//                       width: 2,
//                     ),
//                   ),
//                   child: Text('save'.tr(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       )),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );;
//   }
// }