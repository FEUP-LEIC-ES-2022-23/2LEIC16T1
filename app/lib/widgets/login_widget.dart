import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickRegister;

  const LoginWidget({
    Key? key,
    required this.onClickRegister,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text("SIGN IN",
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none, 
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                hintText: "Email",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: Colors.grey.shade300,
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none, 
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                hintText: "Password",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: Colors.grey.shade300,
                prefixIcon: const Icon(Icons.lock),
          
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                ),
                text: "Don't have an account yet?  ",
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickRegister,
                    text: 'Register here',
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
              onPressed: logIn,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 40),
                backgroundColor: Colors.grey.shade300,
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future logIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pop(dialogContext);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(dialogContext);
      Utils.showErrorBar(e.message);
    }
  }
}
