class BDWeatherUtils {
  static String convertToBanglaNumber(String englishNumber) {
    // Implementation for converting English numbers to Bangla
    // This is a placeholder and needs to be implemented
    Map<String, String> numberMap = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯'
    };
    return englishNumber
        .split('')
        .map((char) => numberMap[char] ?? char)
        .join();
  }

  // This function will return Bangla Weather Description
  static getBanglaDesc(String weatherDesc) {
    String banglaWeatherDesc;
    // Function Goes here
    switch (weatherDesc) {
      // Follows Openweather Condition Standard

      // <-- Thunderstorm -->

      case "thunderstorm with light rain":
        {
          banglaWeatherDesc = 'হালকা বৃষ্টি সহ বজ্রপাত';
        }
        break;
      case "thunderstorm with rain":
        {
          banglaWeatherDesc = 'বৃষ্টি সহ বজ্রপাত';
        }
        break;
      case "thunderstorm with heavy rain":
        {
          banglaWeatherDesc = 'ভারী বৃষ্টি সহ ঝড়ো হাওয়া';
        }
        break;
      case "light thunderstorm":
        {
          banglaWeatherDesc = 'হালকা বজ্রপাত';
        }
        break;
      case "thunderstorm":
        {
          banglaWeatherDesc = 'বজ্রপাত';
        }
        break;
      case "heavy thunderstorm":
        {
          banglaWeatherDesc = 'ভারী বজ্রপাত';
        }
        break;
      case "ragged thunderstorm":
        {
          banglaWeatherDesc = 'কর্কশ বজ্রপাত';
        }
        break;
      case "thunderstorm with light drizzle":
        {
          banglaWeatherDesc = 'হালকা গুঁড়ি গুঁড়ি ব্রষ্টি সহ বজ্রপাত';
        }
        break;

      case "thunderstorm with drizzle":
        {
          banglaWeatherDesc = 'গুঁড়ি গুঁড়ি ব্রষ্টি সহ বজ্রপাত';
        }
        break;
      case " thunderstorm with heavy drizzle":
        {
          banglaWeatherDesc = 'ভারী ঝরঝির বৃষ্টি সহ বজ্রপাত';
        }
        break;

      // <-- Drizzle -->

      case "light intensity drizzle":
        {
          banglaWeatherDesc = 'হালকা তীব্রতা বৃষ্টি';
        }
        break;
      case "drizzle":
        {
          banglaWeatherDesc = 'ঝরঝরে বৃষ্টি';
        }
        break;
      case "heavy intensity drizzle":
        {
          banglaWeatherDesc = 'ভারী তীব্রতা বৃষ্টি';
        }
        break;
      case "light intensity drizzle rain":
        {
          banglaWeatherDesc = 'হালকা তীব্রতা বৃষ্টি বৃষ্টি';
        }
        break;
      case "drizzle rain":
        {
          banglaWeatherDesc = 'গুঁড়ি গুঁড়ি বৃষ্টি';
        }
        break;
      case "heavy intensity drizzle rain":
        {
          banglaWeatherDesc = 'ভারী এবং তীব্রতা বৃষ্টি';
        }
        break;
      case "shower rain and drizzle":
        {
          banglaWeatherDesc = 'ঝরনা বৃষ্টি এবং ঝরঝির বৃষ্টি';
        }
        break;
      case "heavy shower rain and drizzle":
        {
          banglaWeatherDesc = 'ভারী ঝরনা বৃষ্টি এবং ঝরঝির বৃষ্টি';
        }
        break;
      case "shower drizzle":
        {
          banglaWeatherDesc = 'ঝরনা বৃষ্টি';
        }
        break;

      // <-- Rain -->

      case "light rain":
        {
          banglaWeatherDesc = 'হালকা বৃষ্টি';
        }
        break;
      case "moderate rain":
        {
          banglaWeatherDesc = 'মাঝারি বৃষ্টি';
        }
        break;
      case "heavy intensity rain":
        {
          banglaWeatherDesc = '';
        }
        break;
      case "very heavy rain":
        {
          banglaWeatherDesc = 'ভারী তীব্রতা বৃষ্টি';
        }
        break;
      case "extreme rain":
        {
          banglaWeatherDesc = 'চরম বৃষ্টি';
        }
        break;
      case "freezing rain":
        {
          banglaWeatherDesc = 'হিমশীতল বৃষ্টি';
        }
        break;
      case "light intensity shower rain":
        {
          banglaWeatherDesc = 'হালকা তীব্রতা ঝরনা বৃষ্টি';
        }
        break;
      case "shower rain":
        {
          banglaWeatherDesc = 'ঝরনা বৃষ্টি';
        }
        break;
      case "heavy intensity shower rain":
        {
          banglaWeatherDesc = 'ভারী তীব্রতা ঝরনা বৃষ্টি';
        }
        break;
      case "ragged shower rain":
        {
          banglaWeatherDesc = 'কর্কশ ঝরনা বৃষ্টি';
        }
        break;

      // <-- Snow -->

      case "light snow":
        {
          banglaWeatherDesc = 'হালকা তুষারপাত';
        }
        break;
      case "snow":
        {
          banglaWeatherDesc = 'তুষার';
        }
        break;
      case "heavy snow":
        {
          banglaWeatherDesc = 'ভারি তুষারপাত';
        }
        break;
      case "Sleet":
        {
          banglaWeatherDesc = 'এক সঙ্গে তুষার ও বৃষ্টিপাত';
        }
        break;
      case "Light shower sleet":
        {
          banglaWeatherDesc = 'এক সঙ্গে তুষার ও হালকা বৃষ্টিপাত';
        }
        break;
      case "Shower sleet":
        {
          banglaWeatherDesc = 'এক সঙ্গে তুষার ও ঝর্ণা বৃষ্টি';
        }
        break;
      case "Light rain and snow":
        {
          banglaWeatherDesc = 'এক সঙ্গে তুষার ও হালকা বৃষ্টি';
        }
        break;
      case "Rain and snow":
        {
          banglaWeatherDesc = 'তুষার এবং বৃষ্টি';
        }
        break;
      case "Light shower snow":
        {
          banglaWeatherDesc = 'হালকা তুষার';
        }
        break;
      case "Shower snow":
        {
          banglaWeatherDesc = 'ঝরনা তুষারপাত';
        }
        break;
      case "Heavy shower snow":
        {
          banglaWeatherDesc = 'ভারি ঝরনা তুষারপাত';
        }
        break;

      // <-- Atmosphere -->

      case "mist":
        {
          banglaWeatherDesc = 'কুয়াশা';
        }
        break;
      case "haze":
        {
          banglaWeatherDesc = 'হালকা কুয়াশা';
        }
        break;
      case "Smoke":
        {
          banglaWeatherDesc = 'ধোঁয়া';
        }
        break;
      case "sand":
        {
          banglaWeatherDesc = 'ধুলো ঘূর্ণি';
        }
        break;
      case "dust whirls":
        {
          banglaWeatherDesc = 'ধুলো ঘূর্ণি';
        }
        break;
      case "fog":
        {
          banglaWeatherDesc = 'ঘন কুয়াশা';
        }
        break;
      case "dust":
        {
          banglaWeatherDesc = 'ধূলা';
        }
        break;
      case "volcanic ash":
        {
          banglaWeatherDesc = 'আগ্নেয় ছাই';
        }
        break;
      case "squalls":
        {
          banglaWeatherDesc = 'ঝাঁকুনি';
        }
        break;
      case "tornado":
        {
          banglaWeatherDesc = 'টর্নেডো';
        }
        break;

      // <-- Clear -->

      case "clear sky":
        {
          banglaWeatherDesc = 'পরিষ্কার আকাশ';
        }
        break;

      // <-- Clouds -->

      case "few clouds":
        {
          banglaWeatherDesc = 'কিছু মেঘ';
        }
        break;
      case "scattered clouds":
        {
          banglaWeatherDesc = 'বিক্ষিপ্ত মেঘ';
        }
        break;
      case "broken clouds":
        {
          banglaWeatherDesc = 'ভাঙা মেঘ';
        }
        break;
      case "overcast clouds":
        {
          banglaWeatherDesc = 'মেঘাচ্ছন্ন মেঘ';
        }
        break;

      // <-- If Everything Fails -->
      // Then it will show the english one

      default:
        {
          banglaWeatherDesc = weatherDesc;
        }
    }
    return banglaWeatherDesc;
  }

  static String iconName(String weatherDesc) {
    String iconName = 'na';

    // Function Goes Here
    switch (weatherDesc) {
      // Follows Openweather Condition Standard

      // <-- Thunderstorm -->

      case "thunderstorm with light rain":
        {
          iconName = 'thunderstorm-with-light-rain';
        }
        break;
      case "thunderstorm with rain":
        {
          iconName = 'thunderstorm-with-heavy-rain';
        }
        break;
      case "thunderstorm with heavy rain":
        {
          iconName = 'thunderstorm-with-heavy-rain';
        }
        break;
      case "light thunderstorm":
        {
          iconName = 'thunderstorm';
        }
        break;
      case "thunderstorm":
        {
          iconName = 'thunderstorm';
        }
        break;
      case "heavy thunderstorm":
        {
          iconName = 'thunderstorm';
        }
        break;
      case "ragged thunderstorm":
        {
          iconName = 'thunderstorm';
        }
        break;
      case "thunderstorm with light drizzle":
        {
          iconName = 'thunderstorm-with-light-rain';
        }
        break;

      case "thunderstorm with drizzle":
        {
          iconName = 'thunderstorm-with-light-rain';
        }
        break;
      case " thunderstorm with heavy drizzle":
        {
          iconName = 'thunderstorm-with-light-rain';
        }
        break;

      // <-- Drizzle -->

      case "light intensity drizzle":
        {
          iconName = 'light-intensity-drizzle';
        }
        break;
      case "drizzle":
        {
          iconName = 'drizzle';
        }
        break;
      case "heavy intensity drizzle":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;
      case "light intensity drizzle rain":
        {
          iconName = 'light-intensity-drizzle';
        }
        break;
      case "drizzle rain":
        {
          iconName = 'drizzle-rain';
        }
        break;
      case "heavy intensity drizzle rain":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;
      case "shower rain and drizzle":
        {
          iconName = 'light-intensity-shower-rain';
        }
        break;
      case "heavy shower rain and drizzle":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;
      case "shower drizzle":
        {
          iconName = 'drizzle-rain';
        }
        break;

      // <-- Rain -->

      case "light rain":
        {
          iconName = 'light-rain';
        }
        break;
      case "moderate rain":
        {
          iconName = 'rain';
        }
        break;
      case "heavy intensity rain":
        {
          iconName = 'thunderstorm-with-heavy-rain';
        }
        break;
      case "very heavy rain":
        {
          iconName = 'rain';
        }
        break;
      case "extreme rain":
        {
          iconName = 'rain';
        }
        break;
      case "freezing rain":
        {
          iconName = 'sleet';
        }
        break;
      case "light intensity shower rain":
        {
          iconName = 'light-intensity-shower-rain';
        }
        break;
      case "shower rain":
        {
          iconName = 'showers-with-rain';
        }
        break;
      case "heavy intensity shower rain":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;
      case "ragged shower rain":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;

      // <-- Snow -->

      case "light snow":
        {
          iconName = 'snow';
        }
        break;
      case "snow":
        {
          iconName = 'snow';
        }
        break;
      case "heavy snow":
        {
          iconName = 'heavy-snow';
        }
        break;
      case "Sleet":
        {
          iconName = 'sleet';
        }
        break;
      case "Light shower sleet":
        {
          iconName = 'sleet';
        }
        break;
      case "Shower sleet":
        {
          iconName = 'sleet';
        }
        break;
      case "Light rain and snow":
        {
          iconName = 'sleet';
        }
        break;
      case "Rain and snow":
        {
          iconName = 'sleet';
        }
        break;
      case "Light shower snow":
        {
          iconName = 'snow';
        }
        break;
      case "Shower snow":
        {
          iconName = 'snow';
        }
        break;
      case "Heavy shower snow":
        {
          iconName = 'snow';
        }
        break;

      // <-- Atmosphere -->

      case "mist":
        {
          iconName = 'mist';
        }
        break;
      case "haze":
        {
          iconName = 'haze';
        }
        break;
      case "Smoke":
        {
          iconName = 'smoke';
        }
        break;
      case "sand":
        {
          iconName = 'dust';
        }
        break;
      case "dust whirls":
        {
          iconName = 'dust';
        }
        break;
      case "fog":
        {
          iconName = 'fog';
        }
        break;
      case "dust":
        {
          iconName = 'dust';
        }
        break;
      case "volcanic ash":
        {
          iconName = 'volcanic-ash';
        }
        break;
      case "squalls":
        {
          iconName = 'squalls';
        }
        break;
      case "tornado":
        {
          iconName = 'tornado';
        }
        break;

      // <-- Clear -->

      case "clear sky":
        {
          iconName = 'clear';
        }
        break;

      // <-- Clouds -->

      case "few clouds":
        {
          iconName = 'few-clouds';
        }
        break;
      case "scattered clouds":
        {
          iconName = 'scattered-clouds';
        }
        break;
      case "broken clouds":
        {
          iconName = 'broken-clouds';
        }
        break;
      case "overcast clouds":
        {
          iconName = 'overcast-clouds';
        }
        break;

      // <-- If Everything Fails -->
      default:
        {
          iconName = 'na';
        }
    }

    return iconName;
  }
}
