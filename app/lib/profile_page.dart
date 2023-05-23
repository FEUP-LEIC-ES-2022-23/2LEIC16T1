import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportspotter/widgets/profile_widget.dart';
import 'widgets/auth_widget.dart';
import 'navigation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return const ProfileWidget(key: Key('profile page'));
                } else {
                  return const AuthWidget();
                }
              },
            ), // Replace with your desired content
          ),
          const NavigationWidget(selectedIndex: 3),
        ],
      ),
    );
  }
}
