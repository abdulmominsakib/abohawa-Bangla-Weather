import 'package:abohawa/controller/services/connection/getWeather.dart';
import 'package:abohawa/controller/services/weatherData/banglaWeatherDesc.dart';
import 'package:abohawa/controller/services/weatherData/whichIconToShow.dart';
import 'package:abohawa/modal/City.dart';
import 'package:bangla_utilities/bangla_utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllZilla extends GetxController {
  onInit() {
    super.onInit();
    makeWeatherListZilla();
  }

  // <-- Bengali Weather Description -->
  getBanglaWeatherDesc(String weatherDesc) {
    return BanglaWeatherDescription.getBanglaDesc(weatherDesc);
  }

// <-- Which Icon To Show Function -->
  whichIconToShow(String weatherDesc) {
    return WhichIconToShow.iconName(weatherDesc);
  }

  List<City> allZillaWeather = List<City>().obs;
  var isZillaLoading = true.obs;
  var allZillaLoaded = false.obs;
  var paginationLoading = false.obs;
  var scrollController = ScrollController().obs;

  Future<List<City>> makeWeatherListZilla() async {
    isZillaLoading.value = true;
    if (allZillaWeather.isEmpty) {
      getCityWeather(String lat, String lon, String bnCityName) async {
        Map<String, dynamic> zillaWeather =
            await GetWeatherData.getCityWeatherAlt(lat, lon);

        int cityTemp = await zillaWeather['main']['temp'].toInt();
        String weatherDesc = await zillaWeather['weather'][0]['description'];

        String banglaCityTemp =
            BanglaUtility.englishToBanglaDigit(englishDigit: cityTemp);

        String iconName = whichIconToShow(weatherDesc);

        String banglaWeatherDescription = getBanglaWeatherDesc(weatherDesc);
        return City(
            cityName: '$bnCityName',
            temperature: banglaCityTemp,
            weatherDesc: banglaWeatherDescription,
            iconName: iconName);
      }

      addFirstZilla() async {
        allZillaWeather.addAll([
          await getCityWeather('22.335109', '91.834073', 'চট্টগ্রাম'),
          await getCityWeather('23.7115253', '90.4111451', 'ঢাকা'),
          await getCityWeather('23.4682747', '91.1788135', 'কুমিল্লা'),
          await getCityWeather('23.023231', '91.3840844', 'ফেনী'),
          await getCityWeather('23.9570904', '91.1119286', 'ব্রাহ্মণবাড়িয়া'),
          await getCityWeather('22.7324', '92.2985', 'রাঙ্গামাটি'),
          await getCityWeather('22.869563', '91.099398', 'নোয়াখালী'),
          await getCityWeather('23.2332585', '90.6712912', 'চাঁদপুর'),
          await getCityWeather('22.94247', '90.841184', 'লক্ষ্মীপুর'),
          await getCityWeather('21.4272', '92.0058', 'কক্সবাজার'),
          await getCityWeather('23.119285', '91.984663', 'খাগড়াছড়ি'),
          await getCityWeather('21.8311', '92.3686', 'বান্দরবান'),
          await getCityWeather('24.4533978', '89.7006815', 'সিরাজগঞ্জ'),
        ]);
        isZillaLoading.value = false;
      }

      addSecondZilla() async {
        allZillaWeather.addAll([
          await getCityWeather('23.998524', '89.233645', 'পাবনা'),
          await getCityWeather('24.8465228', '89.377755', 'বগুড়া'),
          await getCityWeather('24.3745', '88.6042', 'রাজশাহী'),
          await getCityWeather('24.420556', '89.000282', 'নাটোর'),
          await getCityWeather('25.0968', '89.0227', 'জয়পুরহাট'),
          await getCityWeather('24.7413', '88.2912', 'চাঁপাইনবাবগঞ্জ'),
          await getCityWeather('24.7936', '88.9318', 'নওগাঁ'),
          await getCityWeather('23.1778', '89.1801', 'যশোর'),
          await getCityWeather('22.3155', '89.1115', 'সাতক্ষীরা'),
          await getCityWeather('23.8052', '88.6724', 'মেহেরপুর'),
          await getCityWeather('23.1163', '89.5840', 'নড়াইল'),
          await getCityWeather('23.6161', '88.8263', 'চুয়াডাঙ্গা'),
          await getCityWeather('23.9088', '89.1220', 'কুষ্টিয়া'),
          await getCityWeather('23.4855', '89.4198', 'মাগুরা'),
        ]);
      }

      addThirdZilla() async {
        allZillaWeather.addAll([
          await getCityWeather('22.8456', '89.5403', 'খুলনা'),
          await getCityWeather('22.6602', '89.7895', 'বাগেরহাট'),
          await getCityWeather('23.5528', '89.1754', 'ঝিনাইদহ'),
          await getCityWeather('22.5721', '90.1870', 'ঝালকাঠি'),
          await getCityWeather('22.3586', '90.3317', 'পটুয়াখালী'),
          await getCityWeather('22.5791', '89.9759', 'পিরোজপুর'),
          await getCityWeather('22.7010', '90.3535', 'বরিশাল'),
          await getCityWeather('22.6859', '90.6481', 'ভোলা'),
          await getCityWeather('22.0953', '90.1121', 'বরগুনা'),
          await getCityWeather('24.8949', '91.8687', 'সিলেট'),
          await getCityWeather('24.3095', '91.7315', 'মৌলভীবাজার'),
          await getCityWeather('24.3840', '91.4169', 'হবিগঞ্জ'),
          await getCityWeather('25.0667', '91.4072', 'সুনামগঞ্জ'),
        ]);
      }

      addfourthZilla() async {
        allZillaWeather.addAll([
          await getCityWeather('23.9193', '90.7176', 'নরসিংদী'),
          await getCityWeather('23.9999', '90.4203', 'গাজীপুর'),
          await getCityWeather('23.2423', '90.4348', 'শরীয়তপুর'),
          await getCityWeather('23.6316', '90.4974', 'নারায়ণগঞ্জ'),
          await getCityWeather('24.2513', '89.9167', 'টাঙ্গাইল'),
          await getCityWeather('24.4331', '90.7866', 'কিশোরগঞ্জ'),
          await getCityWeather('23.8644', '90.0047', 'মানিকগঞ্জ'),
          await getCityWeather('23.4981', '90.4127', 'মুন্সিগঞ্জ'),
          await getCityWeather('23.7151', '89.5875', 'রাজবাড়ী'),
          await getCityWeather('23.2393', '90.1870', 'মাদারীপুর'),
          await getCityWeather('23.0488', '89.8879', 'গোপালগঞ্জ'),
          await getCityWeather('23.6019', '89.8333', 'ফরিদপুর'),
          await getCityWeather('26.3354', '88.5517', 'পঞ্চগড়'),
        ]);
      }

      addFifthZilla() async {
        allZillaWeather.addAll([
          await getCityWeather('25.6217061', '88.6354504', 'দিনাজপুর'),
          await getCityWeather('25.9923', '89.2847', 'লালমনিরহাট'),
          await getCityWeather('25.931794', '88.856006', 'নীলফামারী'),
          await getCityWeather('25.328751', '89.528088', 'গাইবান্ধা'),
          await getCityWeather('26.0336945', '88.4616834', 'ঠাকুরগাঁও'),
          await getCityWeather('25.7558096', '89.244462', 'রংপুর'),
          await getCityWeather('25.805445', '89.636174', 'কুড়িগ্রাম'),
          await getCityWeather('25.0204933', '90.0137', 'শেরপুর'),
          await getCityWeather('24.7471', '90.4203', 'ময়মনসিংহ'),
          await getCityWeather('24.937533', '89.937775', 'জামালপুর'),
          await getCityWeather('24.870955', '90.727887', 'নেত্রকোণা'),
        ]);
      }

      addFirstZilla();

      // <-- Pagination --->

      /* ---- Important ----->
      The reason I am adding these booleans because
       If I don't these functions can be run multiple times,
      Which in result will add multiple data in the collection */
      bool secondBatchAdded = false;
      bool thirdBatchAdded = false;
      bool fourthBatchAdded = false;
      bool fifthBatchAdded = false;

      pagination() {
        if (secondBatchAdded == false) {
          secondBatchAdded = true;
          addSecondZilla()
              .whenComplete(() => {paginationLoading.value = false});
        } else if (thirdBatchAdded == false) {
          thirdBatchAdded = true;
          addThirdZilla().whenComplete(() => {paginationLoading.value = false});
        } else if (fourthBatchAdded == false) {
          fourthBatchAdded = true;
          addfourthZilla()
              .whenComplete(() => {paginationLoading.value = false});
        } else if (fifthBatchAdded == false) {
          fifthBatchAdded = true;
          addFifthZilla().whenComplete(() => {paginationLoading.value = false});
        }
      }

      listCheck(ScrollController listController) {
        listController.addListener(() {
          if (listController.position.pixels ==
              listController.position.maxScrollExtent) {
            // List aList = [13, 27, 40, 53, 64];
            // these are the number of list completed
            print(allZillaWeather.length == 64
                ? 'All Zilla Loaded'
                : 'Loading More Zilla...');

            paginationLoading.value = true;
            pagination();
            if (allZillaWeather.length == 64) {
              paginationLoading.value = false;
              allZillaLoaded.value = true;
            }
            print('Total Zilla Weather Fetched: ${allZillaWeather.length}');
          }
        });
      }

      listCheck(scrollController.value);

      return allZillaWeather;
    }

    // used for Debugging purpose
    // print(allZillaWeather.length);
    isZillaLoading.value = false;
    return allZillaWeather;
  }
}
