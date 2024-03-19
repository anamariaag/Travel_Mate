import 'package:flutter/material.dart';

void main() => runApp(NewItinerary());

class NewItinerary extends StatelessWidget {
  NewItinerary({super.key});

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
