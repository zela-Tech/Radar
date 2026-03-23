import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width:double.infinity,
        decoration:const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(03,20,32,1),
              Color.fromRGBO(6, 32, 51, 1),
              Color.fromRGBO(15,46,68,1),
              Color.fromRGBO(14,54,82,1),
              Color.fromRGBO(1,1,13,1),

            ],
            stops: [0.0, 0.3, 0.4,0.55, 0.8],
            begin: Alignment.topCenter,
            end:Alignment.bottomRight,
          ),

        ),
      
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "RADAR",
              style: TextStyle(color:Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            const Text(
              "Explore what's happening near you.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 40),
            //custom circle button
            Positioned(
              bottom: 30,
              right: 24,
              child: GestureDetector(
                onTap: () {Navigator.pushReplacementNamed(context, '/login');},
                child: Container(
                  width:60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),

                ),
              )
            )
          ],
        ),
      ),
      
    );
  }
}