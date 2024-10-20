import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class HomeLoading extends StatelessWidget {
  const HomeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: homeBoxDecoration(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(backgroundColor: Colors.white),
            SizedBox(height: 10),
            Text(
              'একটু অপেক্ষা করুন',
              style: kHeaderTitle.copyWith(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
