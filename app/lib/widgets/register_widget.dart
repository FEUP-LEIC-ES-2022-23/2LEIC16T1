import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Email"),
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
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please, enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    if (!RegExp(r'^(?=.*?[A-Z]).{8,}$').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!RegExp(r'^(?=.*?[a-z]).{8,}$').hasMatch(value)) {
                      return 'Password must contain at least one lowercase letter';
                    }
                    if (!RegExp(r'^(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                      return 'Password must contain at least one number';
                    }
                    if (!RegExp(r'^(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)) {
                      return 'Password must contain at least one special character';
                    }
                    return null;
                  }),
              const SizedBox(height: 4),
              TextFormField(
                controller: firstNameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "First Name"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.isEmpty
                    ? "Please, enter your first name"
                    : null,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: lastNameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Last Name"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.isEmpty
                    ? "Please, enter your last name"
                    : null,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: usernameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Username"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.isEmpty
                    ? "Please, enter your username"
                    : null,
              ),
              const SizedBox(height: 4),
              DateFormField(birthdateController: birthdateController),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                ),
                text: "Do you already have an account?  ",
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickLogIn,
                    text: 'Login',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: register,
                child: const Text('Register'),
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

    BuildContext dialogContext = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return const Center(child: CircularProgressIndicator());
      },
    );

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

      Navigator.pop(dialogContext);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(dialogContext);
      Utils.showErrorBar(e.message);
    }
  }
}

class DateFormField extends StatefulWidget {
  const DateFormField({
    super.key,
    required this.birthdateController,
  });

  final TextEditingController birthdateController;

  @override
  State<DateFormField> createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.birthdateController,
      decoration: const InputDecoration(
        labelText: 'Birthdate',
      ),
      readOnly: true, // Make the text field read-only
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(1920),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
            widget.birthdateController.text = DateFormat('dd-MM-yyyy').format(
                _selectedDate!); // Set the text of the text field to the selected date
          });
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value != null && value.isEmpty
          ? 'Please, enter your birthdate'
          : null,
    );
  }
}
