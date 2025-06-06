import 'package:flutter/material.dart';

class BigStoopid extends StatelessWidget {
  const BigStoopid({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Hello'), centerTitle: true),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}