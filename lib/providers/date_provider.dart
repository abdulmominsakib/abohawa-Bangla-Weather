import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../models/date_model.dart';

class DateNotifier extends StateNotifier<List<Date>> {
  DateNotifier() : super([]) {
    addBanglaWeek();
  }

  final String bengali = 'bn_BN';

  String getFullBanglaDate(int number) {
    initializeDateFormatting(bengali, null);
    String weekDay = DateFormat.EEEE(bengali)
        .format(DateTime.now().add(Duration(days: number)));
    String monthNameWithDate = DateFormat.MMMMd(bengali)
        .format(DateTime.now().add(Duration(days: number)));
    return '$weekDay,\n$monthNameWithDate';
  }

  String getSingleBanglaDate(int number) {
    return DateFormat.MMMMd(bengali)
        .format(DateTime.now().add(Duration(days: number)));
  }

  void addBanglaWeek() {
    if (state.isEmpty) {
      List<Date> newDates = [];

      for (var i = 0; i <= 6; i++) {
        newDates.add(Date(
          fullDate: getFullBanglaDate(i),
          onlyDate: getSingleBanglaDate(i),
        ));
      }

      state = newDates;
    }
  }

  String userOnTodayPage(int currentPage) {
    if (currentPage == 1) return 'এখন ';
    if (currentPage == 0) return 'গতকাল ';
    return '';
  }

  String isItToday(int currentPage) {
    return currentPage == 1 ? 'আজ ' : '';
  }

  String traillingWord(int currentPage) {
    if (currentPage == 1) return 'রয়েছে';
    if (currentPage == 0) return 'ছিল';
    return '- সম্ভবনা রয়েছে';
  }
}

final dateProvider = StateNotifierProvider<DateNotifier, List<Date>>((ref) {
  return DateNotifier();
});
