import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Date extends GetxController {
  Date({this.fullDate, this.onlyDate});
  final String fullDate;
  final String onlyDate;

  // This will generate Bangla Date From DateTime.now()
  static getFullBanglaDate(int number) {
    initializeDateFormatting('bn_BN', null).then((_) {});
    String weekDay = DateFormat.EEEE('bn_BN')
        .format(DateTime.now().add(Duration(days: number ?? 0)));
    String monthNameWithDate = DateFormat.MMMMd('bn_BN')
        .format(DateTime.now().add(Duration(days: number ?? 0)));
    // Don't delete the '\n', it is for a line break
    // if you remove then it will break the ui

    String fullDate = weekDay + ',\n' + monthNameWithDate;
    return fullDate;
  }

  static getSingleBanglaDate(int number) {
    String singleDate = DateFormat.MMMMd('bn_BN')
        .format(DateTime.now().add(Duration(days: number ?? 0)));
    return singleDate;
  }

  // This will generate a WEEK in Bangla
  List<Date> dateGenerator = [];

  addBanglaWeek() {
    // For yesterDay Weather weather API
    // The IF statement is for the week is only genenrated once
    if (dateGenerator.isEmpty) {
      dateGenerator.add(
        Date(
          fullDate: Date.getFullBanglaDate(-1),
          onlyDate: Date.getSingleBanglaDate(-1),
        ),
      );
      // This loop is for generating a week Bangla
      for (var i = 0; i <= 7; i++) {
        String fullDate = Date.getFullBanglaDate(i);
        String onlyDate = Date.getSingleBanglaDate(i);

        dateGenerator.add(
          Date(
            fullDate: fullDate,
            onlyDate: onlyDate,
          ),
        );
      }
    } else
      return null;
  }
}
