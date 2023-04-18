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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "SIGN IN",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "EMAIL"),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "PASSWORD"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  text: "Don't have an account?  ",
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
                child: const Text('LOGIN'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future logIn() async {

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Utils.showErrorBar(e.message);
    }

  }
}
