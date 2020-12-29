import 'package:abohawa/controller/searchController.dart';
import 'package:abohawa/controller/weatherConditionController.dart';
import 'package:abohawa/modal/City.dart';
import 'package:abohawa/views/ui-components/styling.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchCity searchCity = Get.put(SearchCity());

  String typedCityName;
  String counterTextUpdator = '';
  Color inputBorder = Colors.white;
  TextEditingController inputController = TextEditingController();

  final WeatherConditionController weatherCondition = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        margin: EdgeInsets.all(20),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SearchBox(
                controller: inputController,
                onChanged: (value) {},
                counterTextUpdator: counterTextUpdator,
                inputBorder: inputBorder),
            SizedBox(
              height: 10,
            ),
            SearchButton(
              onTap: () {
                if (!inputController.text.isNullOrBlank) {
                  searchCity.searchWeather(inputController.text);
                  searchCity.userPressedSearch.value = true;
                  searchCity.progressIndicator.value = true;
                  if (inputBorder == Colors.redAccent) {
                    // If user typed after the error is shown
                    setState(() {
                      counterTextUpdator = '';
                      inputBorder = Colors.white;
                    });
                  }
                } else if (inputController.text.isNullOrBlank) {
                  setState(() {
                    inputBorder = Colors.redAccent;
                    counterTextUpdator = 'একটা শহরের নাম লিখুন';
                  });
                }
              },
            ),
            SizedBox(height: 30),
            GetX<SearchCity>(builder: (controller) {
              return SearchResultCard(
                city: controller.searchedCity.value,
              );
            }),
            // NoCityAvailable(),
          ],
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key key,
    @required this.counterTextUpdator,
    @required this.inputBorder,
    @required this.onChanged,
    @required this.controller,
  }) : super(key: key);

  final String counterTextUpdator;
  final Color inputBorder;
  final Function onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
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
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onTap,
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
    );
  }
}

// Result will be shown in this card
class SearchResultCard extends StatefulWidget {
  SearchResultCard({@required this.city});

  final City city;

  @override
  _SearchResultCardState createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  @override
  Widget build(BuildContext context) {
    return GetX<SearchCity>(
      builder: (searchCity) {
        // If user pressed the button show the result card
        if (searchCity.userPressedSearch.value == true) {
          // If the function is running then show the progress indicator
          if (searchCity.progressIndicator.value == true) {
            return Container(
              padding: EdgeInsets.all(20),
              height: 200,
              width: 500,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              )),
            );
          } else if (searchCity.noCityAvailableCode.value == true) {
            // If there is not city available then we will show this
            return NoCityAvailable();
          } else if (searchCity.progressIndicator.value == false) {
            // If there is city available we will show this
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.3),
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
                              '${widget.city.windSpeed} কি.মি.',
                              style: kBanglaFont.copyWith(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return SizedBox();
      },
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
            color: Colors.red.withOpacity(0.3),
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
