import 'package:abohawa/controller/dateController.dart';
import 'package:abohawa/controller/weatherConditionController.dart';
import 'package:abohawa/views/screens/HomeScreen.dart';
import 'package:abohawa/views/screens/ZillaScreen.dart';
import 'package:abohawa/views/screens/SearchScreen.dart';
import 'package:abohawa/views/ui-components/styling.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class BanglaWeather extends StatefulWidget {
  @override
  _BanglaWeatherState createState() => _BanglaWeatherState();
}

class _BanglaWeatherState extends State<BanglaWeather> {
  /* -------->
  This is for bottom navigation */
  int _selectedIndex = 0;
  Widget defaultHomeScreen = HomeScreen();

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
        if (_selectedIndex == 0) {
          defaultHomeScreen = HomeScreen();
        } else if (_selectedIndex == 1) {
          defaultHomeScreen = SearchScreen();
        } else if (_selectedIndex == 2) {
          defaultHomeScreen = SavedCity();
        }
      },
    );
  }

  /* <---------
   So we will create two controller one for the Date and other for the weather.
   
  When The app will run, first the Date Generator will generate 
  a week in Bangla to show the date in the UI and it will contain 9 DATE ITEMS,
  Then weather condition makeWeatherList() will generate 9 WeatherCondition Items.
  --------------> */

  final DateController dateController = Get.put(DateController());
  final WeatherConditionController weatherCondition =
      Get.put(WeatherConditionController());

  @override
  Widget build(BuildContext context) {
    // The Listener Widget is for dismissing the keyboard on any tap
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && currentFocus.children != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Solaiman'),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'হোম',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search_rounded), label: 'সার্চ'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_city_rounded), label: 'সব জেলা'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          body: Container(
            decoration: homeBoxDecoration(),
            child: defaultHomeScreen,
          ),
        ),
      ),
    );
  }
}
