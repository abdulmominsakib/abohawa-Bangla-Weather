import 'package:abohawa/controller/dateController.dart';
import 'package:abohawa/controller/weatherConditionController.dart';
import 'package:abohawa/views/ui-components/dateSlider.dart';
import 'package:bangla_utilities/bangla_utilities.dart';
import 'package:abohawa/modal/Date.dart';
import 'package:abohawa/views/ui-components/styling.dart';
import 'package:abohawa/modal/Weather.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// This should be change with the Page View Builder initial builder
var currentPage = 1.obs;

class _HomeScreenState extends State<HomeScreen> {
  // initial Page 1 is for displaying Today's Date
  // Viewportfraction is for 3
  final PageController ctrl =
      PageController(viewportFraction: 1 / 2.9, initialPage: 1);

  final PageController tempCont = PageController(initialPage: 1);

  // For Checking Connection
  isDataAvailable() async {
    internetAvailable = await DataConnectionChecker().hasConnection;
  }

  bool internetAvailable = true;

  final DateController dateController = Get.find();
  final WeatherConditionController weatherCondition = Get.find();

  @override
  void initState() {
    super.initState();
    currentPage.value = 1;
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
    List<Date> dateGenerator = dateController.generatedWeek;
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
            child: GetX<WeatherConditionController>(
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
                  // If makeWeather List is finished Completing

                  List<WeatherCondition> weatherList =
                      // ignore: invalid_use_of_protected_member
                      controller.weatherListUpdater.value;

                  // User Location
                  String userLocation = weatherList[currentPage.value].location;

                  // Weather Description
                  String weatherDescription =
                      weatherList[currentPage.value].descriptionWeather;

                  String banglaWeatherDescription =
                      controller.getBanglaWeatherDesc(weatherDescription);

                  // Icon To Show
                  String icon = controller.whichIconToShow(weatherDescription);

                  // Temperature
                  int temperature = weatherList[currentPage.value].temperature;
                  String banglaTemperature = BanglaUtility.englishToBanglaDigit(
                      englishDigit: temperature);

                  // Night Temperature
                  int nightTemperature =
                      weatherList[currentPage.value].nightTemperature;
                  String banglaNightTemp = BanglaUtility.englishToBanglaDigit(
                      englishDigit: nightTemperature);

                  // Wind Speed
                  int windSpeed =
                      weatherList[currentPage.value].windSpeed.toInt();
                  String banglaWindSpeed = BanglaUtility.englishToBanglaDigit(
                      englishDigit: windSpeed);

                  // And some Words that make it complete
                  String isItToday =
                      dateController.isItToday(currentPage.value);

                  String userOnTodayPage =
                      dateController.userOnTodayPage(currentPage.value);

                  String traillingWord =
                      dateController.traillingWord(currentPage.value);

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
                              '$userOnTodayPage$banglaWeatherDescription $traillingWord',
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
                            TemperatureData(
                                height: height,
                                tempCont: tempCont,
                                ctrl: ctrl,
                                weatherList: weatherList,
                                userOnTodayPage: userOnTodayPage,
                                banglaTemperature: banglaTemperature,
                                banglaWindSpeed: banglaWindSpeed,
                                banglaNightTemp: banglaNightTemp),

                            // Date Slider
                            // You can modify the Style at Views Component
                            DateSlider(
                              height: height,
                              tempCont: tempCont,
                              ctrl: ctrl,
                              dateGenerator: dateGenerator,
                              isItToday: isItToday,
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

class TemperatureData extends StatelessWidget {
  const TemperatureData({
    Key key,
    @required this.height,
    @required this.tempCont,
    @required this.ctrl,
    @required this.weatherList,
    @required this.userOnTodayPage,
    @required this.banglaTemperature,
    @required this.banglaWindSpeed,
    @required this.banglaNightTemp,
  }) : super(key: key);

  final double height;
  final PageController tempCont;
  final PageController ctrl;
  final List<WeatherCondition> weatherList;
  final String userOnTodayPage;
  final String banglaTemperature;
  final String banglaWindSpeed;
  final String banglaNightTemp;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$userOnTodayPageতাপমাত্রাঃ',
                      style: kBanglaFont,
                    ),
                    Text(
                      '$banglaTemperature°',
                      // '25',
                      style: kHeaderTitle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: height / 13),
                    ),
                  ],
                ),
                // This will act as a divider
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10, left: 5),
                      color: Colors.white24,
                      width: 2,
                      height: height / 5,
                    )
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$userOnTodayPageবাতাসের গতিঃ',
                        style: kBanglaFont.copyWith(fontSize: height / 50),
                      ),
                      Text(
                        '$banglaWindSpeed কি.মি./ঘণ্টা',
                        style: kBanglaFont.copyWith(
                            fontSize: height / 40, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'রাত্রে তাপমাত্রা থাকবেঃ',
                        style: kBanglaFont.copyWith(fontSize: height / 60),
                      ),
                      Text(
                        '$banglaNightTemp°',
                        style: kBanglaFont.copyWith(
                            fontSize: height / 40, color: Colors.white),
                      ),
                    ]),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DateSlider extends StatelessWidget {
  const DateSlider({
    Key key,
    @required this.height,
    @required this.tempCont,
    @required this.ctrl,
    @required this.dateGenerator,
    @required this.isItToday,
  }) : super(key: key);

  final double height;
  final PageController tempCont;
  final PageController ctrl;
  final List<Date> dateGenerator;
  final String isItToday;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: height / 30),
        height: height / 10,
        child: PageView.builder(
          onPageChanged: (value) {
            tempCont.animateToPage(value,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutCubic);
            currentPage.value = ctrl.page.round();
          },
          scrollDirection: Axis.horizontal,
          controller: ctrl,
          itemCount: dateGenerator.length,
          itemBuilder: (context, int index) {
            return TodayWeatherButton(
              today: isItToday,
              date: dateGenerator[index],
              active: currentPage.value == index ? true : false,
            );
          },
        ),
      ),
    );
  }
}
