import 'package:flutter/material.dart';

void main() => runApp(Itinerary());

class Itinerary extends StatelessWidget {
  Itinerary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
