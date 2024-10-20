import 'package:flutter/material.dart';

const kHeaderTitle =
    TextStyle(color: Colors.white, fontFamily: 'Solaiman', fontSize: 50);

const kBanglaFont =
    TextStyle(color: Colors.white70, fontFamily: 'Solaiman', fontSize: 20);

BoxDecoration homeBoxDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Color(0xFF32C3DB),
        Color(0xFF3278E1),
      ],
    ),
  );
}
