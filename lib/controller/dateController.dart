import 'package:abohawa/modal/Date.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateController extends GetxController {
  // This will generate a WEEK in Bangla
  // You can change the language here for the date
  String bengali = 'bn_BN';
  // String english = 'en_US';

  List<Date> generatedWeek = [];
  // <---------------------------------------->

  // This will generate Bangla Date From DateTime.now()
  getFullBanglaDate(int number) {
    initializeDateFormatting(bengali, null).then((_) {});
    String weekDay = DateFormat.EEEE(bengali)
        .format(DateTime.now().add(Duration(days: number ?? 0)));
    String monthNameWithDate = DateFormat.MMMMd(bengali)
        .format(DateTime.now().add(Duration(days: number ?? 0)));
    // Don't delete the '\n', it is for a line break
    // if you remove then it will break the ui

    String fullDate = weekDay + ',\n' + monthNameWithDate;
    return fullDate;
  }

  getSingleBanglaDate(int number) {
    String singleDate = DateFormat.MMMMd(bengali)
        .format(DateTime.now().add(Duration(days: number ?? 0)));
    return singleDate;
  }

  addBanglaWeek() {
    // For yesterDay Weather weather API
    // It will generate the list only once
    if (generatedWeek.isEmpty) {
      generatedWeek.add(
        Date(
          fullDate: getFullBanglaDate(-1),
          onlyDate: getSingleBanglaDate(-1),
        ),
      );
      // This loop is for generating a week Bangla
      for (var i = 0; i <= 7; i++) {
        String fullDate = getFullBanglaDate(i);
        String onlyDate = getSingleBanglaDate(i);

        generatedWeek.add(
          Date(
            fullDate: fullDate,
            onlyDate: onlyDate,
          ),
        );
      }
    } else
      return null;
  }

  // If user on current page show "এখন"
  userOnTodayPage(int currentPage) {
    if (currentPage == 1) {
      return 'এখন ';
    } else if (currentPage == 0) {
      return 'গতকাল ';
    }
    return '';
  }

  // If user on current page show "আজ"
  isItToday(int currentPage) {
    if (currentPage == 1) {
      return 'আজ ';
    } else
      return '';
  }

  traillingWord(int currentPage) {
    if (currentPage == 1) {
      return 'রয়েছে';
    } else if (currentPage == 0) {
      return 'ছিল';
    } else
      return '- সম্ভবনা রয়েছে';
  }
}
