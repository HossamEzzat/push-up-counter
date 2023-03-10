import 'package:flutter/material.dart';
import './homepage.dart';

void main() {
  runApp(const PushupCounter());
}

class PushupCounter extends StatelessWidget {
  const PushupCounter({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بتجيب كام ضغط',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'بتجيب كام ضغط'),
    );
  }
}
