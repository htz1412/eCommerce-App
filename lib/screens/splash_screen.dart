import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  final waitingMessage;

  SplashScreen(this.waitingMessage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          waitingMessage,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
