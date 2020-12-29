import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_settings/app_settings.dart';

class InternetChecker {
  void checkData() async {
    // If the device is connected to internet
    if (await DataConnectionChecker().hasConnection == true) {
      // Do nothing
    } else {
      Get.defaultDialog(
        title: 'ইন্টারনেট নেই',
        titleStyle: TextStyle(fontSize: 30, color: Colors.white),
        backgroundColor: Colors.redAccent,
        content: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Container(
              color: Colors.white,
              width: Get.size.width * 0.5,
              height: 2,
              margin: EdgeInsets.only(bottom: 20),
            ),
            Text(
              'আপনার মোবাইল ডাটা বা ওয়াইফাই চালু করুন',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.wifi,
              color: Colors.white,
              size: 50,
            ),
          ],
        ),
        // Open Wifi Settings

        confirm: ElevatedButton(
            onPressed: () {
              AppSettings.openWIFISettings();
            },
            child: Text('ওয়াইফাই চালু করুন')),

        // Open Data Settings
        cancel: ElevatedButton(
            onPressed: () {
              AppSettings.openDataRoamingSettings();
            },
            child: Text('ডাটা চালু করুন')),
      );
    }
  }
}
