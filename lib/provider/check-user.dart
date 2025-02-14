import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rebook_app/Screens/Auth/model/usermodel.dart';
import 'package:rebook_app/backend/firebase_functions.dart';

class CheckUser extends ChangeNotifier {
  UserModel? userModel;
  User? firebaseUser;

  CheckUser() {
    firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      initUser();
    }
  }

  Future<void> initUser() async {
    userModel = await FirebaseFunctions.readUserData();
    notifyListeners();
  }
}
