import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
// Welcome Screen 
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() { // pre loading function
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    //NAvigation to File Upload Screen After Processing whole Animation
    Future.delayed(const Duration(seconds: 3), () {
     
      Navigator.pushReplacementNamed( context, '/file_upload'); 
    });
  }

  @override
  void dispose() {
    _controller.dispose();// To End transition
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(   // Screen Base 
      backgroundColor: Colors.teal,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: const Text(
            'Sentiment Analysis',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color:Colors.white ),
          ),
        ),
      ),
    );
  }
}