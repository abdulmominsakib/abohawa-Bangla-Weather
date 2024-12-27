import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as locate;

enum LocationPermissionStatus {
  initial,
  granted,
  denied,
  deniedForever,
  serviceDisabled
}

class LocationPermissionNotifier
    extends StateNotifier<LocationPermissionStatus> {
  LocationPermissionNotifier(this.context)
      : super(LocationPermissionStatus.initial) {
    _init();
  }

  final BuildContext context;
  final locate.Location location = locate.Location();

  Future<void> _init() async {
    await _checkPermissionStatus();
  }

  String getErrorMessage() {
    switch (state) {
      case LocationPermissionStatus.denied:
        return "আবহাওয়ার তথ্য পেতে লোকেশন এর অনুমতি প্রয়োজন।";
      case LocationPermissionStatus.deniedForever:
        return "লোকেশন এর অনুমতি স্থায়ীভাবে অস্বীকৃত। অ্যাপ সেটিংসে এটি অন করুন।";
      case LocationPermissionStatus.serviceDisabled:
        return "লোকেশন এর অনুমতি পরিষেবাগুলি অক্ষম করা হয়েছে। ডিভাইস সেটিংসে এটি অন করুন।";
      default:
        return "অবস্থান পরিষেবাগুলিতে অ্যাক্সেস করা যাচ্ছে না।";
    }
  }

  Future<void> _checkPermissionStatus() async {
    try {
      final isServiceEnabled =
          await Permission.locationWhenInUse.serviceStatus.isEnabled;
      if (!isServiceEnabled) {
        state = LocationPermissionStatus.serviceDisabled;
        return;
      }

      final status = await Permission.locationWhenInUse.status;
      debugPrint('Current permission status: $status');

      if (status.isGranted) {
        state = LocationPermissionStatus.granted;
      } else if (status.isPermanentlyDenied) {
        state = LocationPermissionStatus.deniedForever;
      } else {
        state = LocationPermissionStatus.denied;
      }
    } catch (e) {
      debugPrint('Error checking permission status: $e');
      state = LocationPermissionStatus.denied;
    }
  }

  Future<bool> requestPermission() async {
    try {
      final isServiceEnabled =
          await Permission.locationWhenInUse.serviceStatus.isEnabled;
      if (!isServiceEnabled) {
        if (context.mounted) {
          await openLocationSettings();
        }
        state = LocationPermissionStatus.serviceDisabled;
        return false;
      }

      final status = await Permission.locationWhenInUse.request();
      debugPrint('Permission status after request: $status');

      if (status.isGranted) {
        state = LocationPermissionStatus.granted;
        return true;
      } else if (status.isPermanentlyDenied) {
        state = LocationPermissionStatus.deniedForever;
        return false;
      } else {
        state = LocationPermissionStatus.denied;
        return false;
      }
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      state = LocationPermissionStatus.denied;
      return false;
    }
  }

  Future<bool> checkAndRequestPermission() async {
    try {
      await _checkPermissionStatus();

      if (state == LocationPermissionStatus.granted) {
        return true;
      }

      return await requestPermission();
    } catch (e) {
      debugPrint('Error in checkAndRequestPermission: $e');
      state = LocationPermissionStatus.denied;
      return false;
    }
  }

  Future<locate.LocationData?> getCurrentLocation() async {
    try {
      if (state != LocationPermissionStatus.granted) {
        final hasPermission = await checkAndRequestPermission();
        if (!hasPermission) return null;
      }

      // Double check if we have permission
      final permissionStatus = await Permission.locationWhenInUse.status;
      if (!permissionStatus.isGranted) {
        state = LocationPermissionStatus.denied;
        return null;
      }

      // Check if service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          state = LocationPermissionStatus.serviceDisabled;
          return null;
        }
      }

      // Get location data
      final locationData = await location.getLocation();
      debugPrint(
          'Got location data: ${locationData.latitude}, ${locationData.longitude}');
      return locationData;
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  Future<void> openLocationSettings() async {
    if (state == LocationPermissionStatus.deniedForever) {
      await openAppSettings();
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.location);
    }
  }
}

final locationPermissionProvider = StateNotifierProvider.family<
    LocationPermissionNotifier,
    LocationPermissionStatus,
    BuildContext>((ref, context) {
  return LocationPermissionNotifier(context);
});
