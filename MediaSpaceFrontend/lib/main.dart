import 'package:MediaSpaceFrontend/pages/home_page.dart';
import 'package:MediaSpaceFrontend/pages/profile_pages/update_profile_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'MediaSpace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Color(0xFFFEF9EB),
      ),
      //Define the routes
      routes: {
        '/home':(context) => MyHomePage(),
        '/updateProfile': (context) => UpdateProfileScreen()
      },
      home: const MyHomePage(),
    );
  }
}

