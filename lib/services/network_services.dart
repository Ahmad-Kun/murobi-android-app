import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionManager {
  bool isConnectionToInternet = false;
  StreamController<bool> _connectionChangeController =
      StreamController<bool>.broadcast();
  StreamSubscription<InternetStatus>? _internetConnectionStreamSubscription;

  // Singleton pattern
  static final ConnectionManager _instance = ConnectionManager._internal();
  factory ConnectionManager() => _instance;
  ConnectionManager._internal() {
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          isConnectionToInternet = true;
          _connectionChangeController.add(true);
          break;
        case InternetStatus.disconnected:
          isConnectionToInternet = false;
          _connectionChangeController.add(false);
          break;
        default:
          isConnectionToInternet = false;
          _connectionChangeController.add(false);
      }
    });
  }

  Stream<bool> get connectionChange => _connectionChangeController.stream;

  // Dispose method to clean up resources
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    _connectionChangeController.close();
  }

  // Method to wait for an active internet connection
  Future<void> waitForConnection() async {
    while (!isConnectionToInternet) {
      await Future.delayed(Duration(seconds: 1));
    }
  }
}
