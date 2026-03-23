import 'package:flutter/material.dart';
import 'auth_screen.dart';

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
      
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 40),
                      //centered logo +icom
                    Center(
                      child: Column(
                        children: [
                          //change this to a custom animated pulsing radar
                          const Icon(Icons.radar, color:Colors.white, size: 100),
                          const SizedBox(width:10),
                          const Text(
                            "RADAR",
                            style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold, letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 80),
                    //main hero text
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w700, 
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(text: "Explore\n"),
                          TextSpan(text: "what’s\n"),
                          TextSpan(text: "happening\n", 
                            style: TextStyle(
                              fontStyle: FontStyle.italic, 
                              color: Color(0xFF9FB3BD)
                            ),
                          ),
                          TextSpan(text:"near you."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //custom circle button
              Positioned(
                bottom: 40,
                right: 28,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                  },
                  child: Container(
                    width:80,
                    height: 80,
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
      ),
    );
  }
}