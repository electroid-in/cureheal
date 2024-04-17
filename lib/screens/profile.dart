import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cureheal/screens/splash.dart';

import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ignore: unused_field
  late UserData _userData;
  // bool _isLoading = true;
  String _userName = ''; // Variable to hold user's first name
  final TextEditingController _controllerBio = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Get the user document from Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .get();

        // Check if the widget is still mounted before updating the state
        if (mounted) {
          // Get the user's name field from the document
          setState(() {
            _userName = snapshot['name'];
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Profile',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 28, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200.0, // Adjust width as needed
                height: 200.0, // Adjust height as needed
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/user.png'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _userName.isNotEmpty ? '$_userName!' : 'user',
                // 'Mahesh Bora',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'name:',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black38,
                ),
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                controller: _controllerBio,
                decoration: InputDecoration(
                  hintText: 'Enter a Quote Here...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.red), // Custom border color
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () async {
                  // Functionality to sign out
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Splash()));
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
