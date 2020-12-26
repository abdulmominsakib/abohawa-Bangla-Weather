import 'package:abohawa/controller/weatherConditionController.dart';
import 'package:abohawa/views/ui-components/zillaCard.dart';
import 'package:abohawa/views/ui-components/styling.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedCity extends StatefulWidget {
  @override
  _SavedCityState createState() => _SavedCityState();
}

class _SavedCityState extends State<SavedCity> {
  // List allZillaWeather = [];

  // makeWeatherListZilla() {
  //   futureZilla = Provider.of<WeatherCondition>(context, listen: false)
  //       .makeWeatherListZilla();
  // }

  @override
  void initState() {
    super.initState();
    weatherCondition.makeWeatherListZilla();
  }

  final WeatherConditionController weatherCondition = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            GetX<WeatherConditionController>(builder: (controller) {
              if (controller.isZillaLoading.value == false) {
                List allZillaWeather = controller.allZillaWeather;
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
              } else if (controller.isZillaLoading.value == true) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Text(
                        'একটু অপেক্ষা করুন',
                        style: kBanglaFont,
                      ),
                    ],
                  ),
                );
              } else
                return SizedBox();
            })
          ],
        ),
      ),
    );
  }
}
