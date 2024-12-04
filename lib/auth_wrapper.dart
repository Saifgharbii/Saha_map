import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saha_map/pages/home/HomePage.dart';

import 'main.dart';

class AuthWrapper extends StatelessWidget {
  static const routeName = '/';
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final currentUser = FirebaseAuth.instance.currentUser!;
          return HomePage(userName: currentUser.displayName ?? "", userAvatar: "");
        }else{
        return const HomeScreen();
        }
      },
    );
  }
}