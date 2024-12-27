import 'package:abohawa/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class NoCityAvailable extends StatelessWidget {
  const NoCityAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacityValue(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Center(
        child: Text(
          'কোন শহর খোঁজে পাওয়া যায়নি!',
          style: kHeaderTitle.copyWith(fontSize: 25),
        ),
      ),
    );
  }
}
