import 'package:bangla_utilities/bangla_utilities.dart';
import 'package:abohawa/shared/banglaDateGenerator.dart';
import 'package:abohawa/shared/styling.dart';
import 'package:abohawa/shared/weatherCondition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'component/dateSlider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // initial Page 1 is for displaying Today's Date
  // Viewportfraction is for 3
  final PageController ctrl =
      PageController(viewportFraction: 1 / 2.9, initialPage: 1);

  final PageController tempCont = PageController(initialPage: 1);

  // This should be change with the Page View Builder initial builder
  int currentPage = 1;

  // This is for getting the current selected Date
  getCurrentPage() {
    currentPage = ctrl.page.round();
    return currentPage;
  }

  // If user on current page show "এখন"
  userOnTodayPage() {
    if (currentPage == 1) {
      return 'এখন ';
    } else if (currentPage == 0) {
      return 'গতকাল ';
    }
    return '';
  }

  maybeFunction() {
    // Ultimately God Decides What Will be the weather, That's why I am adding this
    if (currentPage == 1) {
      return 'রয়েছে';
    } else if (currentPage == 0) {
      return 'ছিল';
    } else
      return '- সম্ভবনা রয়েছে';
  }

  // If user on current page show "আজ"
  isItToday() {
    if (currentPage == 1) {
      return 'আজ ';
    } else
      return '';
  }

  // For Future Builder to know when this is finished
  getWeatherData() {
    return weatherCondition.makeWeatherList();
  }

  // For Checking Connection
  isDataAvailable() async {
    internetAvailable = await DataConnectionChecker().hasConnection;
  }

  bool internetAvailable = true;

  final Date dateController = Get.find();

  final WeatherCondition weatherCondition = Get.put(WeatherCondition());

  @override
  void initState() {
    super.initState();
    // For adding the week at start of the app
    dateController.addBanglaWeek();
    weatherCondition.makeWeatherList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    isDataAvailable();
    print('build done');
    // List of Date
    List<Date> dateGenerator = dateController.dateGenerator;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: height / 20, bottom: height / 20),
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return isDataAvailable();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: GetX<WeatherCondition>(
              builder: (controller) {
                if (controller.isLoading.value == true) {
                  return Container(
                    height: height / 2,
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: internetAvailable
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )
                              : SizedBox(),
                        ),
                        SizedBox(height: 10),
                        Text(
                          internetAvailable
                              ? 'একটু অপেক্ষা করুন'
                              : 'ইন্টারনেট কানেকশন নেই!',
                          style: kHeaderTitle.copyWith(
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else if (controller.isLoading.value == false) {
                  // List of Weather, This is synchronus because the future builder already
                  // knows when to call this list
                  List<WeatherCondition> weatherList =
                      controller.weatherListUpdater.value;

                  // User Location
                  String userLocation = weatherList[currentPage].location;

                  // Weather Description
                  String weatherDescription =
                      weatherList[currentPage].descriptionWeather;

                  String banglaWeatherDescription =
                      controller.getBanglaWeatherDesc(weatherDescription);

                  // Icon To Show
                  String icon = controller.whichIconToShow(weatherDescription);

                  // Temperature
                  int temperature = weatherList[currentPage].temperature;
                  String banglaTemperature = BanglaUtility.englishToBanglaDigit(
                      englishDigit: temperature);

                  // Night Temperature
                  int nightTemperature =
                      weatherList[currentPage].nightTemperature;
                  String banglaNightTemp = BanglaUtility.englishToBanglaDigit(
                      englishDigit: nightTemperature);

                  // Wind Speed
                  int windSpeed = weatherList[currentPage].windSpeed.toInt();
                  String banglaWindSpeed = BanglaUtility.englishToBanglaDigit(
                      englishDigit: windSpeed);

                  // <---
                  // UI Starts Here
                  return Container(
                    margin: EdgeInsets.only(top: height / 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: height / 25,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '$userLocation',
                                    style: kHeaderTitle.copyWith(
                                        fontSize: height / 22),
                                  ),
                                ]),

                            SizedBox(height: 10),
                            Text(
                              '${userOnTodayPage()}$banglaWeatherDescription ${maybeFunction()}',
                              style: kBanglaFont,
                            ),
                            Container(
                              height: height / 4,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Image.asset(
                                'assets/weather-icons/$icon.png',
                                color: icon == 'clear' ? null : Colors.white,
                                width: 300,
                                height: height / 4,
                                fit: BoxFit.contain,
                              ),
                            ),

                            // Temperature Data
                            Container(
                              height: height / 4,
                              child: PageView.builder(
                                controller: tempCont,
                                onPageChanged: (value) {
                                  ctrl.animateToPage(value,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeOutCubic);
                                },
                                itemCount: weatherList.length,
                                itemBuilder: (context, index) {
                                  return AnimatedContainer(
                                    duration: Duration(seconds: 2),
                                    margin: EdgeInsets.only(top: height / 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              '${userOnTodayPage()}তাপমাত্রাঃ',
                                              style: kBanglaFont,
                                            ),
                                            Text(
                                              '$banglaTemperature°',
                                              // '25',
                                              style: kHeaderTitle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: height / 13),
                                            ),
                                          ],
                                        ),
                                        // This will act as a divider
                                        Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 10, left: 5),
                                              color: Colors.white24,
                                              width: 2,
                                              height: height / 5,
                                            )
                                          ],
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${userOnTodayPage()}বাতাসের গতিঃ',
                                                style: kBanglaFont.copyWith(
                                                    fontSize: height / 50),
                                              ),
                                              Text(
                                                '$banglaWindSpeed কি.মি./ঘণ্টা',
                                                style: kBanglaFont.copyWith(
                                                    fontSize: height / 40,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'রাত্রে তাপমাত্রা থাকবেঃ',
                                                style: kBanglaFont.copyWith(
                                                    fontSize: height / 60),
                                              ),
                                              Text(
                                                '$banglaNightTemp°',
                                                style: kBanglaFont.copyWith(
                                                    fontSize: height / 40,
                                                    color: Colors.white),
                                              ),
                                            ]),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Date Slider
                            // You can modify it at COMPONENT FOLDER
                            SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.only(top: height / 30),
                                height: height / 10,
                                child: PageView.builder(
                                  onPageChanged: (value) {
                                    tempCont.animateToPage(value,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeOutCubic);
                                    setState(() {
                                      getCurrentPage();
                                    });
                                  },
                                  scrollDirection: Axis.horizontal,
                                  controller: ctrl,
                                  itemCount: dateGenerator.length,
                                  itemBuilder: (context, int index) {
                                    return TodayWeatherButton(
                                      today: isItToday(),
                                      date: dateGenerator[index],
                                      active:
                                          currentPage == index ? true : false,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else
                  return SizedBox();
              },
            ),
          ),
          // If Future don't have any Data
          // return
        ),
      ),
    );
  }
}
