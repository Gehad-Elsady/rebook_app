import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:rebook_app/Screens/Auth/login-screen.dart';
import 'package:rebook_app/backend/firebase_functions.dart';
import 'package:rebook_app/photos/images.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = "sign up";
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

final TextEditingController ageController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController nameController = TextEditingController();
var formKey = GlobalKey<FormState>();

String? role;

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 50),
              Image.asset(Photos.signUp2, height: 250),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        hintText: "Name",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 15),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your age";
                        }
                        if (int.parse(value) < 20) {
                          return "Sorry, age must be at least 20";
                        }
                        return null;
                      },
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.numbers,
                        ),
                        hintText: "Age",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 15),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        hintText: "Email",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 15),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        final RegExp regex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (!regex.hasMatch(value)) {
                          return 'Password must include an uppercase letter, a number, and a special character';
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        hintText: "Password",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 15),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          FirebaseFunctions.SignUp(
                            emailController.text,
                            passwordController.text,
                            age: int.parse(ageController.text),
                            userName: nameController.text,
                            onSuccess: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset(Photos.create),
                                        SizedBox(height: 16),
                                        Text(
                                          "Please Verify Your Email Address to Login",
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              Timer(
                                Duration(seconds: 3),
                                () {
                                  Navigator.pushNamed(
                                      context, LoginPage.routeName);
                                },
                              );
                            },
                            onError: (e) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginPage.routeName);
                        },
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text: "have an account?  ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 15),
                            children: [
                              TextSpan(
                                text: "Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
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
  }
}
