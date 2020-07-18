import 'package:flutter/material.dart';
import 'services/authentication.dart';
import 'pages/root_page.dart';
// import 'pages/home_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Attendance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF323232),
        scaffoldBackgroundColor: Color(0xFF444957),
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}
