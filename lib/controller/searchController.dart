import 'package:abohawa/controller/services/connection/getWeather.dart';
import 'package:abohawa/controller/services/weatherData/banglaWeatherDesc.dart';
import 'package:abohawa/controller/services/weatherData/whichIconToShow.dart';
import 'package:abohawa/modal/City.dart';
import 'package:bangla_utilities/bangla_utilities.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class SearchCity extends GetxController {
  var searchedCity = City().obs;
  var userPressedSearch = false.obs;
  var progressIndicator = true.obs;
  var noCityAvailableCode = false.obs;

  searchWeather(String typedCityName) async {
    Map<String, dynamic> cityWeather =
        await GetWeatherData.getWeatherByCityName(typedCityName);
    print(cityWeather['cod']);
    if (cityWeather['cod'] == 200) {
      progressIndicator.value = true;
      String cityName = cityWeather['name'];
      String weatherDescription = cityWeather['weather'][0]['description'];
      int temperature = cityWeather['main']['temp'].toInt();
      double windSpeed = cityWeather['wind']['speed'] * 3.6.round();

      // This generates bangla name if available in GEOCODING
      String banglaLocation = '';
      try {
        List<Location> locations = await locationFromAddress(typedCityName);

        double lat = locations[0].latitude;
        double lon = locations[0].longitude;

        List<Placemark> placemarks =
            await placemarkFromCoordinates(lat, lon, localeIdentifier: 'bn_BN');
        banglaLocation = placemarks[0].locality;
        // print(banglaLocation);
      } catch (e) {
        print(e);
      }

      String banglaWeatherDescription =
          BanglaWeatherDescription.getBanglaDesc(weatherDescription);

      // Icon To Show
      String icon = WhichIconToShow.iconName(weatherDescription);

      String banglaTemperature =
          BanglaUtility.englishToBanglaDigit(englishDigit: temperature);
      String banglaWindSpeed =
          BanglaUtility.englishToBanglaDigit(englishDigit: windSpeed.toInt());

      searchedCity.value = City(
        cityName: banglaLocation == '' ? cityName : banglaLocation,
        temperature: banglaTemperature,
        windSpeed: banglaWindSpeed,
        weatherDesc: banglaWeatherDescription,
        iconName: icon,
      );
      noCityAvailableCode.value = false;
      progressIndicator.value = false;
      // These print are used for checking
      // print(cityName);
      // print(banglaWeatherDescription);
      // print(banglaTemperature);
      // print(banglaWindSpeed);
      // print(icon);s

    } else {
      progressIndicator.value = false;
      noCityAvailableCode.value = true;
    }
  }
}
