import 'package:flutter/material.dart';

class SignInPrompt extends StatelessWidget {
  const SignInPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('First, sign in to create your shop'),
      ),
    );
  }
}
