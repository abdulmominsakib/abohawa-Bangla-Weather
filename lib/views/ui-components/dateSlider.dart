import 'package:abohawa/modal/Date.dart';
import 'package:abohawa/views/ui-components/styling.dart';
import 'package:flutter/material.dart';

class TodayWeatherButton extends StatelessWidget {
  TodayWeatherButton({this.date, this.active = false, this.today});

  final bool active;
  final Date date;
  final String today;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        top: active ? 0 : 30,
        bottom: active ? 15 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: active ? Colors.white : Colors.transparent,
      ),
      height: 20,
      child: FlatButton(
        // minWidth: 30,
        onPressed: () {},
        child: Text(
          '${active ? today + date.fullDate : date.onlyDate}',
          style: kBanglaFont.copyWith(
              color: active ? Color(0xFF263B7E) : super.key,
              fontSize: active ? 15 : 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
