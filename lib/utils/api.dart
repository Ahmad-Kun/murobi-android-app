// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  static String baseUrl = 'https://murobi-beta.xyz/';
  static String endPointLapkeu = 'api/lapkeu/';
  static String endPointDataMasjid = 'api/dataMasjid/';
  static String endPointLogin = 'api/login';
  static String endPointForm = "api/formDonation";
  static String endPointQurban = "api/qurban";
  static String endPointSubmit = "api/donation";
  static String endPointRiwayat = "api/riwayat";

  // static String _getBaseUrl() {
  //   if (kIsWeb) {
  //     return 'http://127.0.0.1:8000/'; //webbrowser
  //   }
  //   if (Platform.isAndroid) {
  //     return _isEmulator() ? 'http://10.0.2.2:8000/' : 'http://192.168.1.102:8000/';
  //   }
  //   return 'http://127.0.0.1:8000/'; //Ios
  // }

  // static bool _isEmulator() {
  //   // Basic check for emulator
  //   return !Platform.environment.containsKey('ANDROID_BOOTLOGO');
  // }
}
