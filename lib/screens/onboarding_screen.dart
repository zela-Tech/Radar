import 'package:flutter/material.dart';


class OnboardingScreen extends StatelessWidget {
  final int userId;

  const OnboardingScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Onboarding for user $userId')),
    );
  }
}