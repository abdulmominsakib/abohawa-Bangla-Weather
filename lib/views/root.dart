import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/zilla_screen.dart';
import 'screens/search_screen.dart';
import 'ui-components/styling.dart';

class BanglaWeather extends StatefulWidget {
  @override
  _BanglaWeatherState createState() => _BanglaWeatherState();
}

class _BanglaWeatherState extends State<BanglaWeather> {
  int _selectedIndex = 0;
  late Widget _currentScreen;

  @override
  void initState() {
    super.initState();
    _currentScreen = HomeScreen();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _currentScreen = HomeScreen();
          break;
        case 1:
          _currentScreen = SearchScreen();
          break;
        case 2:
          _currentScreen = SavedCity();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'হোম'),
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
          child: _currentScreen,
        ),
      ),
    );
  }
}
