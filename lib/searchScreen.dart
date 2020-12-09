import 'package:bangla_utilities/bangla_utilities.dart';
import 'package:abohawa/connection/getWeather.dart';
import 'package:abohawa/shared/cityObject.dart';
import 'package:abohawa/shared/styling.dart';
import 'package:abohawa/shared/weatherCondition.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool userPressedSearch = false;
  City searchedCity;
  String typedCityName;
  Future<City> futureCity;
  String counterTextUpdator = '';
  Color inputBorder = Colors.white;

  @override
  Widget build(BuildContext context) {
    getWeatherByCityName() async {
      Map<String, dynamic> cityWeather =
          await GetWeatherData.getWeatherByCityName(typedCityName);

      if (cityWeather['cod'] == 200) {
        String cityName = cityWeather['name'];
        String weatherDescription = cityWeather['weather'][0]['description'];
        int temperature = cityWeather['main']['temp'].toInt();
        double windSpeed = cityWeather['wind']['speed'] * 3.6.round();

        // This generates bangla name if available in GEOCODING
        List<Location> locations = await locationFromAddress(typedCityName);
        double lat = locations[0].latitude;
        double lon = locations[0].longitude;

        List<Placemark> placemarks =
            await placemarkFromCoordinates(lat, lon, localeIdentifier: 'bn_BN');
        String banglaLocation = placemarks[0].locality;
        // print(banglaLocation);

        String banglaWeatherDescription =
            Provider.of<WeatherCondition>(context, listen: false)
                .getBanglaWeatherDesc(weatherDescription);

        // Icon To Show
        String icon = Provider.of<WeatherCondition>(context, listen: false)
            .whichIconToShow(weatherDescription);

        String banglaTemperature =
            BanglaUtility.englishToBanglaDigit(englishDigit: temperature);
        String banglaWindSpeed =
            BanglaUtility.englishToBanglaDigit(englishDigit: windSpeed.toInt());

        searchedCity = City(
          cityName: banglaLocation == '' ? cityName : banglaLocation,
          temperature: banglaTemperature,
          windSpeed: banglaWindSpeed,
          weatherDesc: banglaWeatherDescription,
          iconName: icon,
        );
        // These print are used for checking
        // print(cityName);
        // print(banglaWeatherDescription);
        // print(banglaTemperature);
        // print(banglaWindSpeed);
        // print(icon);
        return searchedCity;
      } else
        userPressedSearch = true;
      // This will trigger the error to show up
      // print('no data');
    }

    return SafeArea(
      child: AnimatedContainer(
        margin: EdgeInsets.all(20),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onChanged: (value) {
                typedCityName = value;
              },
              maxLength: 30,
              cursorColor: Colors.white,
              // autofocus: true,
              decoration: InputDecoration(
                counterText: counterTextUpdator,
                counterStyle: kBanglaFont,
                labelStyle: kBanglaFont,
                labelText: 'উপজেলা বা শহর এর আবহাওয়া',
                hintText: 'আপাতত শুধু ইংরেজি সাপোর্টেড',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: inputBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              onPressed: () {
                if (typedCityName == null) {
                  setState(() {
                    counterTextUpdator = 'নাম লিখুন';
                    inputBorder = Colors.redAccent;
                  });
                } else {
                  futureCity = getWeatherByCityName();
                  setState(() {});
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: Text(
                  'সার্চ',
                  style: kBanglaFont.copyWith(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 30),
            FutureBuilder(
                future: futureCity,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SearchResultCard(
                      city: searchedCity,
                    );
                  } else if (!snapshot.hasData) {
                    // If there is no city available
                    Widget thisWillBeReturned = NoCityAvailable();
                    // If user pressed unnecessarily
                    void whatToReturn() {
                      if (userPressedSearch == true) {
                        thisWillBeReturned = NoCityAvailable();
                      } else
                        thisWillBeReturned = SizedBox();
                    }

                    whatToReturn();
                    return thisWillBeReturned;
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return SizedBox();
                }),
          ],
        ),
      ),
    );
  }
}

// Result will be shown in this card
class SearchResultCard extends StatefulWidget {
  SearchResultCard({this.city});

  final City city;

  @override
  _SearchResultCardState createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 300,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.city.cityName,
            style: kHeaderTitle.copyWith(fontSize: 35),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 2,
            color: Colors.white10,
            width: double.maxFinite,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/weather-icons/${widget.city.iconName}.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ]),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'এখন তাপমাত্রাঃ',
                    style: kBanglaFont.copyWith(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${widget.city.temperature}°',
                    style: kHeaderTitle,
                  ),
                  Text(
                    '${widget.city.weatherDesc},',
                    style: kBanglaFont.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'বাতাসের গতিঃ',
                    style: kBanglaFont.copyWith(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '৬ কি.মি.',
                    style: kBanglaFont.copyWith(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

// ERROR Card, This will show up if no city is available
class NoCityAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Center(
        child: Text(
          'কোন শহর খোঁজে পাওয়া যায়নি!',
          style: kHeaderTitle.copyWith(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
