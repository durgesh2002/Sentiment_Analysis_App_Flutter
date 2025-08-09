import 'package:flutter/material.dart';
import 'package:sentiment_analysis_app/fileuploadscreen.dart';
import 'package:sentiment_analysis_app/realtimesentiment.dart';
import 'package:sentiment_analysis_app/splash_screen.dart';

void main() {
  runApp(MyApp());
}
// Stateless Widget is used For static data representation.
// Sentiment_dart Package in which Postive words marks as 3,negative word as -3 , neutral word as 0
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sentiment Analysis App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/file_upload': (context) => FileUploadScreen(),
        '/realtime': (context) => const RealtimeAnalysisScreen(),
      },
    );
  }
}