import 'package:abohawa/zilla.dart';
import 'package:abohawa/searchScreen.dart';
import 'package:abohawa/shared/banglaDateGenerator.dart';
import 'package:abohawa/shared/weatherCondition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homeScreen.dart';

void main() {
  runApp(BanglaWeather());
}

class BanglaWeather extends StatefulWidget {
  @override
  _BanglaWeatherState createState() => _BanglaWeatherState();
}

class _BanglaWeatherState extends State<BanglaWeather> {
  int _selectedIndex = 0;
  Widget defaultHomeScreen = HomeScreen();

  // <-- You can add page swipe functionality in the app -->
  // <-- This page controller was for swipe functionality for the app -->
  // final PageController screenControl = PageController();

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
        if (_selectedIndex == 0) {
          defaultHomeScreen = HomeScreen();
          // you can implement swipe functionality by uncommenting these lines
          // screenControl.jumpToPage(0);
        } else if (_selectedIndex == 1) {
          defaultHomeScreen = SearchScreen();
          // screenControl.jumpToPage(1);
        } else if (_selectedIndex == 2) {
          defaultHomeScreen = SavedCity();
          // screenControl.jumpToPage(2);
        }
        //
      },
    );
  }

  // <-- Needed If you added Swipe Gesture -->
  // List screenList = [
  //   HomeScreen(),
  //   SearchScreen(),
  //   SavedCity(),
  // ];

  @override
  void initState() {
    super.initState();
  }

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
      child: ChangeNotifierProvider(
        create: (_) => Date(),
        child: MaterialApp(
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
                    icon: Icon(Icons.location_city_rounded), label: 'জেলা'),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF32C3DB),
                    Color(0xFF3278E1),
                  ],
                ),
              ),
              // This decides which screen to show based on USER INTERACTIONS
              child: ChangeNotifierProvider(
                  create: (_) => WeatherCondition(), child: defaultHomeScreen),
            ),
          ),
        ),
      ),
    );
  }
}

// <-- Put this code in container child for adding swipe functionality -->
// PageView.builder(
//   itemCount: screenList.length,
//   scrollDirection: Axis.vertical,
//   controller: screenControl,
//   onPageChanged: (value) {
//     setState(() {});
//   },
//   itemBuilder: (context, index) {
//     _selectedIndex = index;
//     return screenList[index];
//   },
// ),
