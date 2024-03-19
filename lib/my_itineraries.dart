import 'package:flutter/material.dart';

void main() => runApp(MyItineraries());

class MyItineraries extends StatelessWidget {
  MyItineraries({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
