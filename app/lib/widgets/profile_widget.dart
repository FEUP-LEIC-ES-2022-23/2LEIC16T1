import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  Map<String, dynamic>? userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userData = snapshot.data!.data();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: userData?['photoUrl'] != null
                      ? NetworkImage(userData!['photoUrl'])
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  userData?['username'] ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${userData?['firstName']} ${userData?['lastName']}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildProfileInfoItem(
                              'Email Address', userData?['email'] ?? ''),
                          const SizedBox(height: 10),
                          _buildProfileInfoItem(
                              'Birthdate', userData?['birthdate'] ?? ''),
                          const SizedBox(height: 100),
                          ElevatedButton(
                            key: Key("sign out button"),
                            onPressed: () => FirebaseAuth.instance.signOut(),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 40),
                              backgroundColor: Colors.grey.shade300,
                            ),
                            child: const Text(
                              'SIGN OUT',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildProfileInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
