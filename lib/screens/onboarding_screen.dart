import 'package:flutter/material.dart';
import '../helper/user_session_helper.dart';
import './main_navigator.dart';

class OnboardingScreen extends StatelessWidget {
  final int userId;

  const OnboardingScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await SessionHelper.setOnboardingDone();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNav()),
            );
          },
          child: const Text("Finish Onboarding"),
        ),
      ),
    );
  }
}