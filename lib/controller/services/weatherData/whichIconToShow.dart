class WhichIconToShow {
  static String iconName({String weatherDesc}) {
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
