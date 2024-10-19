import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/city_model.dart';
import '../ui-components/styling.dart';

import '../../providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController inputController = TextEditingController();
  String counterTextUpdator = '';
  Color inputBorder = Colors.white;

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SearchBox(
              controller: inputController,
              counterTextUpdator: counterTextUpdator,
              inputBorder: inputBorder,
            ),
            SizedBox(height: 10),
            SearchButton(
              onTap: () {
                if (inputController.text.isNotEmpty) {
                  ref
                      .read(searchProvider.notifier)
                      .searchWeather(inputController.text);
                  setState(() {
                    counterTextUpdator = '';
                    inputBorder = Colors.white;
                  });
                } else {
                  setState(() {
                    inputBorder = Colors.redAccent;
                    counterTextUpdator = 'একটা শহরের নাম লিখুন';
                  });
                }
              },
            ),
            SizedBox(height: 30),
            if (searchState.isLoading)
              CircularProgressIndicator()
            else if (searchState.noCityAvailable)
              NoCityAvailable()
            else if (searchState.searchedCity != null)
              SearchResultCard(city: searchState.searchedCity!),
          ],
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  final String counterTextUpdator;
  final Color inputBorder;
  final TextEditingController controller;

  const SearchBox({
    Key? key,
    required this.counterTextUpdator,
    required this.inputBorder,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: 30,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        counterText: counterTextUpdator,
        counterStyle: kBanglaFont,
        labelStyle: kBanglaFont,
        labelText: 'উপজেলা বা শহর এর আবহাওয়া',
        hintText: 'আপাতত শুধু ইংরেজি সাপোর্টেড',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: inputBorder),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.white),
        ),
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  final VoidCallback onTap;

  const SearchButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text('সার্চ', style: kBanglaFont.copyWith(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  final City city;

  const SearchResultCard({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(city.cityName, style: kHeaderTitle.copyWith(fontSize: 35)),
          Divider(color: Colors.white10, thickness: 2),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/weather-icons/${city.iconName}.png',
                height: 150,
                width: 150,
                fit: BoxFit.contain,
                color: Colors.white,
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('এখন তাপমাত্রাঃ',
                      style: kBanglaFont.copyWith(
                          fontSize: 15, color: Colors.white)),
                  Text('${city.temperature}°', style: kHeaderTitle),
                  Text('${city.weatherDesc},',
                      style: kBanglaFont.copyWith(
                          fontSize: 18, color: Colors.white)),
                  SizedBox(height: 10),
                  Text('বাতাসের গতিঃ',
                      style: kBanglaFont.copyWith(
                          fontSize: 15, color: Colors.white)),
                  Text('${city.windSpeed} কি.মি.',
                      style: kBanglaFont.copyWith(
                          fontSize: 15, color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
          'কোন শহর খোঁজে পাওয়া যায়নি!',
          style: kHeaderTitle.copyWith(fontSize: 25),
        ),
      ),
    );
  }
}
