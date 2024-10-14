import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:murobi_beta/keuangan/riwayat.dart';
import 'package:murobi_beta/login/login.dart';
import 'package:murobi_beta/login/sign_up.dart';
import 'package:murobi_beta/payment/PaymentPage.dart';
import 'package:murobi_beta/screen/dashboard.dart';
import 'package:murobi_beta/screen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/dashboard', page: () => Dashboard()),
        GetPage(name: '/login', page: () => LoginWidget()),
        GetPage(name: '/signup', page: () => SignUpWidget()),
        GetPage(name: '/payment', page: () => PaymentPages()),
        GetPage(name: '/riwayat', page: () => RiwayatPages()),
      ],
    );
  }
}
