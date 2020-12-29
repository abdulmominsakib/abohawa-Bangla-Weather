import 'package:abohawa/controller/allZillaScreenController.dart';
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
  final AllZilla allZilla = Get.find();
  final WeatherConditionController weatherCondition = Get.find();

  @override
  Widget build(BuildContext context) {
    var listController = allZilla.scrollController.value;
    return SafeArea(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              'বাংলাদেশের সব জেলা এর বর্তমান আবহাওয়া',
              style: kHeaderTitle.copyWith(fontSize: 18),
            ),
            Container(
              width: 100,
              child: Divider(
                color: Colors.white,
              ),
            ),
            GetX<AllZilla>(builder: (controller) {
              if (controller.isZillaLoading.value == false) {
                List allZillaWeather = controller.allZillaWeather;

                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: listController,
                          itemCount: allZillaWeather.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == allZillaWeather.length) {
                              return controller.allZillaLoaded.value == true
                                  ? NoMoreZilla()
                                  : SizedBox();
                            }
                            // You can modify the card at COMPONENT FOLDER
                            return ZillaCard(
                              cityName: allZillaWeather[index].cityName,
                              cityWeather: allZillaWeather[index].temperature,
                              iconName: allZillaWeather[index].iconName,
                              cityWeatherDesc:
                                  allZillaWeather[index].weatherDesc,
                            );
                          },
                        ),
                      ),
                      controller.paginationLoading.value == true
                          ? Container(
                              margin: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: LinearProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ))
                          : SizedBox(),
                    ],
                  ),
                );
              } else if (controller.isZillaLoading.value == true) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: weatherCondition.isInternetAvailable.value == false
                      ? NoInternet()
                      : LoadingIndicator(),
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

class NoMoreZilla extends StatelessWidget {
  const NoMoreZilla({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: Get.size.width / 5),
          child: Divider(
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Text(
            'বাংলাদেশে আর জেলা নেই!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class NoInternet extends StatelessWidget {
  const NoInternet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off,
          size: 50,
          color: Colors.white,
        ),
        Text(
          'ইন্টারনেট নেই',
          style: kBanglaFont,
        ),
      ],
    );
  }
}
