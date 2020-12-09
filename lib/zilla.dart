import 'package:abohawa/shared/styling.dart';
import 'package:abohawa/shared/weatherCondition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'component/zillaCard.dart';

class SavedCity extends StatefulWidget {
  @override
  _SavedCityState createState() => _SavedCityState();
}

class _SavedCityState extends State<SavedCity> {
  Future<List> futureZilla;

  // List allZillaWeather = [];

  makeWeatherListZilla() {
    futureZilla = Provider.of<WeatherCondition>(context, listen: false)
        .makeWeatherListZilla();
  }

  @override
  void initState() {
    super.initState();
    makeWeatherListZilla();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          // print('Screen Refreshed');
          return futureZilla;
        },
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(
                'বাংলাদেশের কিছু জেলা এর বর্তমান আবহাওয়া',
                style: kHeaderTitle.copyWith(fontSize: 18),
              ),
              Container(
                width: 100,
                child: Divider(
                  color: Colors.white,
                ),
              ),
              FutureBuilder(
                future: futureZilla,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List allZillaWeather =
                        Provider.of<WeatherCondition>(context).allZillaWeather;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: allZillaWeather.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // You can modify the card at COMPONENT FOLDER
                          return ZillaCard(
                            cityName: allZillaWeather[index].cityName,
                            cityWeather: allZillaWeather[index].temperature,
                            iconName: allZillaWeather[index].iconName,
                            cityWeatherDesc: allZillaWeather[index].weatherDesc,
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
