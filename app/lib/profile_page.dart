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
      appBar: AppBar(
        key: Key("profile page"),
        automaticallyImplyLeading: false,
        title: const Text('My profile'),
      ),
      body: Stack(
        children: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return const ProfileWidget();
              } else {
                return const AuthWidget();
              }
            },
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            child: NavigationWidget(selectedIndex: 3),
          )
        ],
      ),
    );
  }
}
