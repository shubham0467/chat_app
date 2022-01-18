import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'authenication page.dart';

class Screen extends StatelessWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something is wrong"));
          } else if (snapshot.hasData) {
            return const Homescreen();
          } else {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      AuthProvider().googleLogin();
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.login,
                          size: 30,
                        ),
                        Text(
                          "Google Sign",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
