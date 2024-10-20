import 'package:flutter/material.dart';

import '../constants/styling.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: homeBoxDecoration(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              'ইন্টারনেট কানেকশন নেই!',
              style: kHeaderTitle.copyWith(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
