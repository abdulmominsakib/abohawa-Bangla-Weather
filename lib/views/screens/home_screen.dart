// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/date_model.dart';
import '../../models/weather_model.dart';
import '../../providers/date_provider.dart';
import '../../providers/weather_home_provider.dart';
import '../ui-components/styling.dart';

class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherHomeProvider);
    final height = MediaQuery.of(context).size.height;
    final dateGenerator = ref.watch(dateProvider);
    final dateController =
        usePageController(viewportFraction: 1 / 2.9, initialPage: 0);
    final pageCtrl = usePageController(initialPage: 0);

    final currentPage = useState(0);

    if (weatherState.isLoading) {
      return _buildLoadingScreen(weatherState.isInternetAvailable);
    }

    if (weatherState.currentWeather == null) {
      return _ErrorHomeScreen(
          errorMessage: weatherState.error ?? "No weather data available");
    }

    final WeatherCondition currentWeather = weatherState.currentWeather!;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(weatherHomeProvider.notifier)
              .checkInternetAndLoadWeather();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeHeader(location: currentWeather.location, height: height),
            Expanded(
              child: PageView.builder(
                controller: pageCtrl,
                onPageChanged: (v) {
                  dateController.animateToPage(
                    v,
                    duration: Durations.medium2,
                    curve: Curves.easeInOut,
                  );
                },
                itemCount: weatherState.forecast!.length,
                itemBuilder: (context, index) {
                  final currentWeatherNow = weatherState.forecast![index];
                  if (index == 0) {
                    return _WeatherPage(
                      currentWeather: currentWeather,
                      isToday: true,
                    );
                  } else {
                    return _WeatherPage(
                      currentWeather: currentWeatherNow,
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 90,
              child: PageView.builder(
                controller: dateController,
                itemCount: dateGenerator.length,
                onPageChanged: (v) {
                  currentPage.value = v;
                  pageCtrl.animateToPage(
                    v,
                    duration: Durations.medium2,
                    curve: Curves.easeInOut,
                  );
                },
                itemBuilder: (context, int index) {
                  return TodayWeatherButton(
                    today: currentPage == 1 ? 'আজ ' : '',
                    date: dateGenerator[index],
                    isActive: currentPage.value == index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(bool isInternetAvailable) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isInternetAvailable)
            CircularProgressIndicator(backgroundColor: Colors.white)
          else
            Icon(Icons.wifi_off, size: 50, color: Colors.white),
          SizedBox(height: 10),
          Text(
            isInternetAvailable
                ? 'একটু অপেক্ষা করুন'
                : 'ইন্টারনেট কানেকশন নেই!',
            style: kHeaderTitle.copyWith(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TodayWeatherButton extends StatelessWidget {
  TodayWeatherButton({
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
          '${isActive ? today + date.fullDate : date.onlyDate}',
          style: kBanglaFont.copyWith(
              color: isActive ? Color(0xFF263B7E) : null,
              fontSize: isActive ? 15 : 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _WeatherPage extends StatelessWidget {
  const _WeatherPage({
    Key? key,
    required this.currentWeather,
    this.isToday = false,
  }) : super(key: key);

  final WeatherCondition currentWeather;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _WeatherDescription(weather: currentWeather),
        _WeatherIcon(weather: currentWeather),
        _TemperatureData(
          weather: currentWeather,
          isToday: isToday,
        ),
        _AdditionalInfo(weather: currentWeather),
      ],
    );
  }
}

class _AdditionalInfo extends ConsumerWidget {
  const _AdditionalInfo({
    required this.weather,
  });

  final WeatherCondition weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banglaWindSpeed = ref
        .read(weatherHomeProvider.notifier)
        .convertToBanglaNumber(weather.windSpeed.round());
    final banglaHumidity = ref
        .read(weatherHomeProvider.notifier)
        .convertToBanglaNumber(weather.humidity);
    final banglaPressure = ref
        .read(weatherHomeProvider.notifier)
        .convertToBanglaNumber(weather.pressure);
    final height = MediaQuery.sizeOf(context).height;

    return Container(
      margin: EdgeInsets.symmetric(vertical: height / 30),
      child: Column(
        children: [
          Text('অতিরিক্ত তথ্য',
              style: kBanglaFont.copyWith(fontSize: height / 40)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('বাতাসের গতি', '$banglaWindSpeed কি.মি./ঘণ্টা'),
              _buildInfoItem('আর্দ্রতা', '$banglaHumidity%'),
              _buildInfoItem('চাপ', '$banglaPressure hPa'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: kBanglaFont.copyWith(fontSize: 14)),
        Text(value,
            style: kBanglaFont.copyWith(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}

class _ErrorHomeScreen extends StatelessWidget {
  const _ErrorHomeScreen({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.red),
          SizedBox(height: 10),
          Text(
            errorMessage,
            style: kHeaderTitle.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TemperatureData extends ConsumerWidget {
  const _TemperatureData({
    required this.weather,
    required this.isToday,
  });

  final WeatherCondition weather;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banglaTemperature = ref
        .read(weatherHomeProvider.notifier)
        .convertToBanglaNumber(weather.temperature.round());
    final banglaFeelsLike = ref
        .read(weatherHomeProvider.notifier)
        .convertToBanglaNumber(weather.feelsLike.round());
    final height = MediaQuery.sizeOf(context).height;

    return Container(
      height: height / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${isToday ? 'আজ ' : ''}তাপমাত্রাঃ', style: kBanglaFont),
          Text(
            '$banglaTemperature°',
            style: kHeaderTitle.copyWith(
                fontWeight: FontWeight.bold, fontSize: height / 13),
          ),
          SizedBox(height: 10),
          Text('অনুভূত তাপমাত্রাঃ $banglaFeelsLike°',
              style: kBanglaFont.copyWith(fontSize: height / 40)),
        ],
      ),
    );
  }
}

class _WeatherIcon extends ConsumerWidget {
  const _WeatherIcon({
    required this.weather,
  });

  final WeatherCondition weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = ref
        .read(weatherHomeProvider.notifier)
        .whichIconToShow(weather.descriptionWeather);
    final height = MediaQuery.sizeOf(context).height;

    return Container(
      height: height / 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Image.asset(
        'assets/weather-icons/$icon.png',
        color: icon == 'clear' ? null : Colors.white,
        width: 300,
        height: height / 4,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _WeatherDescription extends ConsumerWidget {
  const _WeatherDescription({
    required this.weather,
  });

  final WeatherCondition weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banglaDesc = ref
        .read(weatherHomeProvider.notifier)
        .getBanglaWeatherDesc(weather.descriptionWeather);
    return Text(banglaDesc, style: kBanglaFont);
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.location,
    required this.height,
  });

  final String location;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height / 15,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, color: Colors.white, size: height / 25),
          SizedBox(width: 5),
          Text(
            location,
            style: kHeaderTitle.copyWith(fontSize: height / 22),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
