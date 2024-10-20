import 'package:flutter/material.dart';

import '../../../models/date_model.dart';
import '../../../constants/styling.dart';

class TodayWeatherButton extends StatelessWidget {
  const TodayWeatherButton({
    super.key,
    required this.date,
    required this.isActive,
    required this.today,
  });

  final bool isActive;
  final Date date;
  final String today;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        top: isActive ? 0 : 30,
        bottom: isActive ? 15 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isActive ? Colors.white : Colors.transparent,
      ),
      height: 20,
      child: TextButton(
        onPressed: () {},
        child: Text(
          isActive ? today + date.fullDate : date.onlyDate,
          style: kBanglaFont.copyWith(
              color: isActive ? Color(0xFF263B7E) : null,
              fontSize: isActive ? 15 : 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
