import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class ErrorHomeScreen extends StatelessWidget {
  const ErrorHomeScreen({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.red),
          SizedBox(height: 10),
          Text(
            errorMessage,
            style: kHeaderTitle.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
