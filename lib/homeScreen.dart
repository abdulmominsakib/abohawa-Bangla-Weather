import 'package:bangla_utilities/bangla_utilities.dart';
import 'package:abohawa/shared/banglaDateGenerator.dart';
import 'package:abohawa/shared/styling.dart';
import 'package:abohawa/shared/weatherCondition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'component/dateSlider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // initial Page 1 is for displaying Today's Date
  // Viewportfraction is for 3
  final PageController ctrl =
      PageController(viewportFraction: 1 / 2.9, initialPage: 1);
  final String url =
      'https://icons-for-free.com/iconfiles/png/512/cloud+day+forecast+lightning+shine+storm+sun+weather+icon-1320183295537909806.png';

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

  // If user on current page show "আজ"
  isItToday() {
    if (currentPage == 1) {
      return 'আজ ';
    } else
      return '';
  }

  // For Future Builder to know when this is finished
  getWeatherData() {
    return Provider.of<WeatherCondition>(context).makeWeatherList();
  }

  // For Checking Connection
  isDataAvailable() async {
    internetAvailable = await DataConnectionChecker().hasConnection;
  }

  Future<List> weatherFuture;

  bool internetAvailable = true;

  @override
  void initState() {
    super.initState();
    // For adding the week at start of the app
    Provider.of<Date>(context, listen: false).addBanglaWeek();
    weatherFuture =
        Provider.of<WeatherCondition>(context, listen: false).makeWeatherList();
    Provider.of<WeatherCondition>(context, listen: false)
        .makeWeatherListZilla();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    isDataAvailable();
    // List of Date
    List<Date> dateGenerator = Provider.of<Date>(context).dateGenerator;

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: height / 20, bottom: height / 20),
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              Provider.of<Date>(context, listen: false).addBanglaWeek();
              weatherFuture =
                  Provider.of<WeatherCondition>(context, listen: false)
                      .makeWeatherList();
              Provider.of<WeatherCondition>(context, listen: false)
                  .makeWeatherListZilla();
            });
            return isDataAvailable();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: FutureBuilder(
              future: weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // List of Weather, This is synchronus because the future builder already
                  // knows when to call this list
                  List<WeatherCondition> weatherList =
                      Provider.of<WeatherCondition>(context).weatherList;

                  // User Location
                  String userLocation = weatherList[currentPage].location;

                  // Weather Description
                  String weatherDescription =
                      weatherList[currentPage].descriptionWeather;

                  String banglaWeatherDescription =
                      Provider.of<WeatherCondition>(context)
                          .getBanglaWeatherDesc(weatherDescription);

                  // Icon To Show
                  String icon = Provider.of<WeatherCondition>(context)
                      .whichIconToShow(weatherDescription);

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
                    margin: EdgeInsets.only(top: height / 35),
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
                              '${userOnTodayPage()}$banglaWeatherDescription',
                              style: kBanglaFont,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
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
                              margin: EdgeInsets.only(top: height / 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        margin:
                                            EdgeInsets.only(right: 10, left: 5),
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
                            ),

                            // Date Slider
                            // You can modify it at COMPONENT FOLDER
                            SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.only(top: height / 30),
                                height: height / 10,
                                child: PageView.builder(
                                  onPageChanged: (value) {
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
                }
                // If Future don't have any Data
                return Container(
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
