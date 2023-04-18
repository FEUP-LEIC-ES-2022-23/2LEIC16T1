import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


import '../utils.dart';

class RegisterWidget extends StatefulWidget {
  final VoidCallback onClickLogIn;

  const RegisterWidget({
    Key? key,
    required this.onClickLogIn,
  }) : super(key: key);

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final birthdateController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    birthdateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text("REGISTER",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "EMAIL"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? "Enter a valid email"
                          : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "PASSWORD"),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? "Password needs to be at least 6 characters"
                      : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: firstNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "FIRST NAME"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.isEmpty
                      ? "Please enter your first name"
                      : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: lastNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "LAST NAME"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.isEmpty
                      ? "Please enter your last name"
                      : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: usernameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "USERNAME"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.isEmpty
                      ? "Please enter your username"
                      : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: birthdateController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(labelText: "BIRTHDATE"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.isEmpty
                      ? "Please enter your birthdate"
                      : null,
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    text: "Already have an account?  ",
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickLogIn,
                        text: 'Log In',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: register,
                  child: const Text('REGISTER'),
                ),
              ],
            ),
          ),
      ),
    );
  }


  Future register() async {

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      // Create the user in Firebase Authentication
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Add the additional user data to the Firebase Database
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid)
          .set({
        'email': emailController.text.trim(),
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'username': usernameController.text.trim(),
        'birthdate': birthdateController.text.trim(),
      });
    } on FirebaseAuthException catch (e) {
      Utils.showErrorBar(e.message);
    }
  }
}
