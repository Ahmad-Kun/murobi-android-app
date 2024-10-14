import 'package:flutter/material.dart';
import 'package:murobi_beta/home/home_pages.dart';
import 'package:murobi_beta/edukasi/edukasi_pages.dart';
import 'package:murobi_beta/qiblah_kompas/qiblah_pages.dart';
import 'package:murobi_beta/ziswaf/ziswaf_pages.dart';
import 'package:murobi_beta/qurban/qurban_pages.dart';
import 'package:murobi_beta/keuangan/keuangan_pages.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // Define the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Handle item selection here
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const HomeWidget(),
      const EdukasiWidget(),
      const QiblahPages(),
      const ZiswafPages(),
      const QurbanPages(),
      const KeuanganPages(),
    ];
    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cast_for_education_rounded),
            label: 'Edukasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mosque_outlined),
            label: 'qiblat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_outlined),
            label: 'Ziswaf',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory_outlined),
            label: 'Qurban',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }
}
