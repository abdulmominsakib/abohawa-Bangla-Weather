import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum AppConnectionStatus {
  loading,
  online,
  offline,
}

class ConnectionStatusNotifier extends StateNotifier<AppConnectionStatus> {
  ConnectionStatusNotifier() : super(AppConnectionStatus.loading) {
    _init();
  }

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late StreamSubscription<InternetStatus> _internetCheckerSubscription;

  Future<void> _init() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((_) {
      _checkInternetAccess();
    });

    _internetCheckerSubscription =
        InternetConnection().onStatusChange.listen((status) {
      state = status == InternetStatus.connected
          ? AppConnectionStatus.online
          : AppConnectionStatus.offline;
    });

    // Perform initial check
    await _checkInternetAccess();
  }

  Future<void> _checkInternetAccess() async {
    try {
      final isConnected = await InternetConnection().hasInternetAccess;
      state = isConnected
          ? AppConnectionStatus.online
          : AppConnectionStatus.offline;
    } catch (e) {
      state = AppConnectionStatus.offline;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _internetCheckerSubscription.cancel();
    super.dispose();
  }
}

final connectionStatusProvider =
    StateNotifierProvider<ConnectionStatusNotifier, AppConnectionStatus>((ref) {
  return ConnectionStatusNotifier();
});
