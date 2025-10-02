import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsse_app/app/controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 199, 206, 220), // Warna atas
                  Color.fromARGB(255, 206, 208, 211), // Warna tengah
                  Color.fromARGB(255, 173, 175, 179), // Warna bawah
                ],
                stops: [0.0, 0.3, 3.0], // Mengatur posisi transisi warna
              ),
            ),
          ),

          Center(child: Column(children: [Icon(Icons.abc)])),
        ],
      ),
    );
  }
}
