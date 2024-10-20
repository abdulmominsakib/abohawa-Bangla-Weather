import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/weather_model.dart';
import '../../providers/date_provider.dart';
import '../../providers/weather_home_provider.dart';
import 'components/error_home_screen.dart';
import 'components/home_header.dart';
import 'components/home_loading.dart';
import 'components/today_weather_button.dart';
import 'components/weather_page.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
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
      return HomeLoading();
    }
    if (weatherState.currentWeather == null) {
      return ErrorHomeScreen(
          errorMessage: weatherState.error ?? "No weather data available");
    }
    final WeatherCondition currentWeather = weatherState.currentWeather!;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(weatherHomeProvider.notifier).fetchCurrentWeather();
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
                    return WeatherPage(
                      currentWeather: currentWeather,
                      isToday: true,
                    );
                  } else {
                    return WeatherPage(
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
                    today: currentPage.value == 1 ? 'আজ ' : '',
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
}
