// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rebook_app/Screens/Auth/model/usermodel.dart';
import 'package:rebook_app/Screens/add-services/model/service-model.dart';

class FirebaseFunctions {
  static SignUp(String emailAddress, String password,
      {required Function onSuccess,
      required Function onError,
      required String userName,
      required int age}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      credential.user?.sendEmailVerification();
      UserModel userModel = UserModel(
        age: age,
        email: emailAddress,
        name: userName,
        id: credential.user!.uid,
      );
      addUser(userModel);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    } catch (e) {
      print(e);
    }
  }

  static Login(
    String emailAddress,
    String password, {
    required Function onSuccess,
    required Function onError,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }

  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, options) {
        return UserModel.fromJason(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJason();
      },
    );
  }

  static Future<void> addUser(UserModel user) {
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Future<UserModel?> readUserData() async {
    var collection = getUserCollection();

    DocumentSnapshot<UserModel> docUser =
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    return docUser.data();
  }

  static signOut() {
    FirebaseAuth.instance.signOut();
  }
  ///////////////////////////

  // static CollectionReference<ProfileModel> getUserProfileCollection() {
  //   return FirebaseFirestore.instance
  //       .collection("UsersProfile")
  //       .withConverter<ProfileModel>(
  //     fromFirestore: (snapshot, options) {
  //       return ProfileModel.fromJson(snapshot.data()!);
  //     },
  //     toFirestore: (user, _) {
  //       return user.toJson();
  //     },
  //   );
  // }

  // static Future<void> addUserProfile(ProfileModel user) {
  //   var collection = getUserProfileCollection();
  //   var docRef = collection.doc(user.id);
  //   return docRef.set(user);
  // }

  // static Stream<ProfileModel?> getUserProfile(String uid) {
  //   return FirebaseFirestore.instance
  //       .collection('UsersProfile')
  //       .doc(uid)
  //       .snapshots()
  //       .map((userProfileSnapshot) {
  //     if (userProfileSnapshot.exists) {
  //       var data = userProfileSnapshot.data() as Map<String, dynamic>;
  //       return ProfileModel.fromJson(
  //           data); // Assuming ProfileModel has a fromJson constructor
  //     } else {
  //       print('User profile not found');
  //       return null; // Return null if the document does not exist
  //     }
  //   }).handleError((e) {
  //     print('Error fetching user profile: $e');
  //     return null; // Handle errors by returning null
  //   });
  // }

  // static Stream<List<ServiceModel>> getSeeds() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   try {
  //     // Query the collection where type is "Seeds"
  //     return _firestore
  //         .collection('services')
  //         .where('type', isEqualTo: 'Seeds') // Add this filter
  //         .snapshots()
  //         .map((snapshot) {
  //       return snapshot.docs.map((doc) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         return ServiceModel(
  //           userId: data['userId'] ?? "no id",
  //           name: data['name'] ?? 'No Name',
  //           image: data['image'] ?? 'default_image.png',
  //           description: data['description'] ?? 'No Description',
  //           price: data['price'] ?? 'No Price',
  //           type: data['type'] ?? 'No Type',
  //           createdAt: data['createdAt'] ?? 'No Date',
  //         );
  //       }).toList();
  //     });
  //   } catch (e) {
  //     print('Error fetching services: $e');
  //     return const Stream.empty(); // Return an empty stream in case of error
  //   }
  // }

  // //---------------------------Contact---------------------------

  // static Future<void> addProblem(ContactModel problem) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('Problem')
  //         .doc()
  //         .withConverter<ContactModel>(
  //       fromFirestore: (snapshot, options) {
  //         return ContactModel.fromJson(snapshot.data()!);
  //       },
  //       toFirestore: (value, options) {
  //         return value.toJson();
  //       },
  //     ).set(problem);
  //     print('problem added successfully!');
  //   } catch (e) {
  //     print('Error adding problem: $e');
  //   }
  // }

  // //---------------------------Cart---------------------------

  // static Stream<List<CartModel>> getCardStream() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  //   return _firestore
  //       .collection('cart')
  //       .where('userId', isEqualTo: uid)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return CartModel(
  //         userId: data['userId'] ?? "no id",
  //         serviceModel: ServiceModel.fromJson(data['serviceModel']),
  //         itemId: data['itemId'] ?? "no id",
  //       );
  //     }).toList();
  //   });
  // }

  // static Future<void> addCartService(CartModel model) async {
  //   // Get the highest existing itemId and increment it
  //   final cartCollection = FirebaseFirestore.instance.collection('cart');
  //   final snapshot =
  //       await cartCollection.orderBy('itemId', descending: true).limit(1).get();

  //   int newId = 1; // Default to 1 if no items are in the collection
  //   if (snapshot.docs.isNotEmpty) {
  //     final lastId = int.parse(snapshot.docs.first['itemId']);
  //     newId = lastId + 1;
  //   }

  //   final cartItem = CartModel(
  //     itemId: newId.toString(),
  //     serviceModel: model.serviceModel,
  //     userId: model.userId,
  //   );

  //   await cartCollection.add(cartItem.toMap());
  // }

  // static Future<void> deleteCartService(String itemId) async {
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  //   if (uid.isEmpty) {
  //     print('User is not authenticated.');
  //     return;
  //   }

  //   try {
  //     // Get the document(s) that match the userId and itemId
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('cart')
  //         .where('itemId', isEqualTo: itemId)
  //         .where('userId',
  //             isEqualTo: uid) // Ensure the item belongs to the current user
  //         .get();

  //     if (querySnapshot.docs.isEmpty) {
  //       print('No items found to delete.');
  //       return;
  //     }

  //     // Delete each document found
  //     for (var doc in querySnapshot.docs) {
  //       await doc.reference.delete();
  //     }

  //     print('Service deleted successfully!');
  //   } catch (e) {
  //     print('Error deleting service: $e');
  //   }
  // }

  // static Future<void> checkOut(
  //     int totalPrice, Function onSuccess, Function onError) async {
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  //   // Listen to the user profile stream
  //   await for (var profileData in getUserProfile(uid)) {
  //     if (profileData != null) {
  //       onSuccess(); // Profile is valid, proceed with success
  //       return; // Exit after success is handled
  //     } else {
  //       onError(); // Handle the error if profile data is null
  //       return; // Exit after error is handled
  //     }
  //   }
  // }

  // static Future<void> clearCart(String uid) async {
  //   final cartCollection = FirebaseFirestore.instance
  //       .collection('cart')
  //       .where('userId', isEqualTo: uid);
  //   await cartCollection.get().then((querySnapshot) {
  //     for (var doc in querySnapshot.docs) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // //---------------------------History---------------------------
  // static Future<void> orderHistory(HistoryModel order) async {
  //   try {
  //     // Reference to the 'History' collection
  //     final historyCollection =
  //         FirebaseFirestore.instance.collection('History');

  //     // Debug log: Check collection size
  //     print('Fetching the highest existing order ID...');

  //     // Get the highest existing order ID
  //     final snapshot = await historyCollection
  //         .orderBy('id', descending: true)
  //         .limit(1)
  //         .get();

  //     int newId = 1; // Default to 1 if no orders exist
  //     if (snapshot.docs.isNotEmpty) {
  //       final lastId = snapshot.docs.first.data()['id'];

  //       // Debug log: Output the last ID
  //       print('Last order ID retrieved: $lastId');

  //       // Parse last ID safely and increment
  //       newId = (int.tryParse(lastId?.toString() ?? '0') ?? 0) + 1;

  //       // Debug log: Output the new ID
  //       print('New order ID to be used: $newId');
  //     }

  //     // Fetch user profile asynchronously
  //     final userProfile =
  //         await getUserProfile(FirebaseAuth.instance.currentUser!.uid).first;

  //     if (userProfile == null) {
  //       print('User profile not found!');
  //       return;
  //     }

  //     // Debug log: Output user profile
  //     print('User profile retrieved: ${userProfile.firstName}');

  //     // Create a new order
  //     final newOrder = HistoryModel(
  //       id: newId.toString(),
  //       userId: FirebaseAuth.instance.currentUser!.uid,
  //       items: order.items,
  //       orderType: order.orderType,
  //       serviceModel: order.serviceModel,
  //       locationModel: order.locationModel,
  //       timestamp: DateTime.now().millisecondsSinceEpoch,
  //       orderStatus: "Pending",
  //       orderOwnerName: userProfile.firstName,
  //       orderOwnerPhone: userProfile.phoneNumber,
  //     );

  //     // Add the new order to Firestore
  //     await historyCollection.add(newOrder.toJson());

  //     // Clear the user's cart
  //     await clearCart(FirebaseAuth.instance.currentUser!.uid);

  //     print('Order added successfully with ID: $newId');
  //   } catch (e) {
  //     print('Error adding order: $e');
  //   }
  // }

  // static Stream<List<HistoryModel>> getHistoryStream() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  //   return _firestore
  //       .collection('History')
  //       .where('userId', isEqualTo: uid) // Filter by current user's ID
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return HistoryModel(
  //         timestamp: data['timestamp'] ?? 0,
  //         userId: data['userId'] ?? "no id",
  //         serviceModel: data['serviceModel'] != null
  //             ? ServiceModel.fromJson(data['serviceModel'])
  //             : null,
  //         locationModel: data['locationModel'] != null
  //             ? LocationModel.fromMap(data['locationModel'])
  //             : null,
  //         items: data['items'] != null
  //             ? (data['items'] as List<dynamic>)
  //                 .map((item) => CartModel.fromMap(item))
  //                 .toList()
  //             : [],
  //         orderType: data['OrderType'] ?? "No Order Type",
  //         id: data['id'] ?? "No Id",
  //         orderStatus: data['orderStatus'] ?? "No Status",
  //         orderOwnerName: data['orderOwnerName'] ?? "No Name",
  //         orderOwnerPhone: data['orderOwnerPhone'] ?? "No Phone",
  //       );
  //     }).toList();
  //   });
  // }

  // static Future<void> deleteHistoryOrder(int timestamp) async {
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  //   if (uid.isEmpty) {
  //     print('User is not authenticated.');
  //     return;
  //   }

  //   try {
  //     // Get the document(s) that match the userId and itemId
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('History')
  //         .where('timestamp', isEqualTo: timestamp)
  //         .where('userId',
  //             isEqualTo: uid) // Ensure the item belongs to the current user
  //         .get();

  //     if (querySnapshot.docs.isEmpty) {
  //       print('No items found to delete.');
  //       return;
  //     }

  //     // Delete each document found
  //     for (var doc in querySnapshot.docs) {
  //       await doc.reference.delete();
  //     }

  //     print('Service deleted successfully!');
  //   } catch (e) {
  //     print('Error deleting service: $e');
  //   }
  // }

  // //-----------------------Add land-----------------------
  // static Future<void> addLand(AddLandModel land) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('lands')
  //         .doc()
  //         .withConverter<AddLandModel>(
  //       fromFirestore: (snapshot, options) {
  //         return AddLandModel.fromJson(snapshot.data()!);
  //       },
  //       toFirestore: (value, options) {
  //         return value.toJson();
  //       },
  //     ).set(land);
  //     print('problem added successfully!');
  //   } catch (e) {
  //     print('Error adding problem: $e');
  //   }
  // }

  // static Future<void> deleteMyLand(Timestamp createdAt, String userId) async {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   try {
  //     // Query the document(s) matching the filters
  //     final querySnapshot = await _firestore
  //         .collection('lands')
  //         .where('createdAt', isEqualTo: createdAt)
  //         .where('userId', isEqualTo: userId)
  //         .get();

  //     // Loop through and delete each matching document
  //     for (var doc in querySnapshot.docs) {
  //       await _firestore.collection('lands').doc(doc.id).delete();
  //     }

  //     print('Service(s) deleted successfully');
  //   } catch (e) {
  //     print('Error deleting service: $e');
  //   }
  // }

  // static Stream<List<AddLandModel>> getLandStream() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   return _firestore.collection('lands').snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return AddLandModel(
  //         address: data['address'] ?? "No Address",
  //         description: data['description'] ?? "No Description",
  //         image: data['image'] ?? "No Image",
  //         price: data['price'] ?? "No Price",
  //         investmentType: data['investmentType'] ?? "No Investment Type",
  //         locationModel: data['locationModel'] != null
  //             ? LocationModel.fromMap(data['locationModel'])
  //             : null,
  //         OwnerName: data['ownerName'] ?? "No Name",
  //         OwnerPhone: data['ownerPhone'] ?? "No Phone Number",
  //         landSpace: data['landSpace'] ?? "No Land Space",
  //         userId: data['userId'] ?? "No User Id",
  //         createdAt: data['createdAt'] ?? "No Date",
  //       );
  //     }).toList();
  //   });
  // }

  //----------------manage my server----------------
  static Stream<List<ServiceModel>> getMyBooks(String userId) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore
          .collection('Books')
          .where('userId', isEqualTo: userId) // Add this filter
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ServiceModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            type: data['type'] ?? 'No Type',
            createdAt: data['createdAt'] ?? 'No Date',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Future<void> deleteMyBooks(Timestamp createdAt, String userId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the document(s) matching the filters
      final querySnapshot = await _firestore
          .collection('Books')
          .where('createdAt', isEqualTo: createdAt)
          .where('userId', isEqualTo: userId)
          .get();

      // Loop through and delete each matching document
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('Books').doc(doc.id).delete();
      }

      print('Books(s) deleted successfully');
    } catch (e) {
      print('Error deleting Books: $e');
    }
  }

  // static Stream<List<AddLandModel>> getMyLandStream() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   return _firestore
  //       .collection('lands')
  //       .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return AddLandModel(
  //         address: data['address'] ?? "No Address",
  //         description: data['description'] ?? "No Description",
  //         image: data['image'] ?? "No Image",
  //         price: data['price'] ?? "No Price",
  //         investmentType: data['investmentType'] ?? "No Investment Type",
  //         locationModel: data['locationModel'] != null
  //             ? LocationModel.fromMap(data['locationModel'])
  //             : null,
  //         OwnerName: data['ownerName'] ?? "No Name",
  //         OwnerPhone: data['ownerPhone'] ?? "No Phone Number",
  //         landSpace: data['landSpace'] ?? "No Land Space",
  //         userId: data['userId'] ?? "No User Id",
  //         createdAt: data['createdAt'] ?? "No Date",
  //       );
  //     }).toList();
  //   });
  // }
  // //--------------------------Notifications--------------------------

  // static Future<void> addDeviceTokens(NotificationModel token) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('UserTokens')
  //         .doc(token.id)
  //         .withConverter<NotificationModel>(
  //       fromFirestore: (snapshot, options) {
  //         return NotificationModel.fromJson(snapshot.data()!);
  //       },
  //       toFirestore: (value, options) {
  //         return value.toJson();
  //       },
  //     ).set(token);
  //     print('token added successfully!');
  //   } catch (e) {
  //     print('Error adding token: $e');
  //   }
  // }

  // static Stream<String?> getUserDeviceTokenStream(String userId) {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   return _firestore
  //       .collection('UserTokens')
  //       .doc(
  //           userId) // Directly reference the document with the userId as the document ID.
  //       .snapshots()
  //       .map((snapshot) {
  //     if (snapshot.exists) {
  //       final data = snapshot.data() as Map<String, dynamic>;
  //       return data['deviceToken'] as String?; // Return the deviceToken field.
  //     }
  //     return null; // Return null if the document does not exist.
  //   });
  // }

  // //--------------------------my requests--------------------------
  // static Stream<List<HistoryModel>> getMyRequestStream() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  //   return _firestore.collection('History').snapshots().map((snapshot) {
  //     return snapshot.docs.where((doc) {
  //       final data = doc.data();
  //       // Check if any item in the 'items' list contains a serviceModel with userId matching the current user's uid
  //       final items = data['items'] as List<dynamic>?;
  //       if (items != null) {
  //         // Filter items by checking if any item's serviceModel userId matches the current uid
  //         return items.any((item) =>
  //             item['serviceModel'] != null &&
  //             item['serviceModel']['userId'] == uid);
  //       }
  //       return false;
  //     }).map((doc) {
  //       final data = doc.data();
  //       return HistoryModel(
  //         timestamp: data['timestamp'] ?? 0,
  //         userId: data['userId'] ?? "no id",
  //         serviceModel: data['serviceModel'] != null
  //             ? ServiceModel.fromJson(data['serviceModel'])
  //             : null,
  //         locationModel: data['locationModel'] != null
  //             ? LocationModel.fromMap(data['locationModel'])
  //             : null,
  //         items: data['items'] != null
  //             ? (data['items'] as List<dynamic>)
  //                 .map((item) => CartModel.fromMap(item))
  //                 .toList()
  //             : [],
  //         orderType: data['OrderType'] ?? "No Order Type",
  //         id: data['id'] ?? "No Id",
  //         orderStatus: data['orderStatus'] ?? "No Status",
  //         orderOwnerName: data['orderOwnerName'] ?? "No Name",
  //         orderOwnerPhone: data['orderOwnerPhone'] ?? "No Phone",
  //       );
  //     }).toList();
  //   });
  // }

  // static Future<void> acceptOrderStatus(
  //     String orderId, String newStatus) async {
  //   try {
  //     // Reference to the Firestore collection 'History'
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('History')
  //         .where('id', isEqualTo: orderId)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Get the document reference from the first document in the query result
  //       DocumentReference orderRef = querySnapshot.docs[0].reference;

  //       // Update the orderStatus field
  //       await orderRef.update({
  //         'orderStatus': newStatus,
  //       });

  //       print("Order status updated successfully!");
  //     } else {
  //       print("Order not found!");
  //     }
  //   } catch (e) {
  //     print("Error updating order status: $e");
  //   }
  // }

  // static Future<void> completOrder(int timestamp, String userId) async {
  //   // final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  //   // if (uid.isEmpty) {
  //   //   print('User is not authenticated.');
  //   //   return;
  //   // }

  //   try {
  //     // Get the document(s) that match the userId and itemId
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('History')
  //         .where('timestamp', isEqualTo: timestamp)
  //         .where('userId',
  //             isEqualTo: userId) // Ensure the item belongs to the current user
  //         .get();

  //     if (querySnapshot.docs.isEmpty) {
  //       print('No items found to delete.');
  //       return;
  //     }

  //     // Delete each document found
  //     for (var doc in querySnapshot.docs) {
  //       await doc.reference.delete();
  //     }

  //     print('Service deleted successfully!');
  //   } catch (e) {
  //     print('Error deleting service: $e');
  //   }
  // }
}
