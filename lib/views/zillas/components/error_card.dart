import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String errorMessage;

  const ErrorCard({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Error: $errorMessage',
          style: TextStyle(color: Colors.red[900]),
        ),
      ),
    );
  }
}
