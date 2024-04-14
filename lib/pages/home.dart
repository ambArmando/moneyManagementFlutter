import 'package:flutter/material.dart';
import 'package:money_management/pages/budget.dart';
import 'package:money_management/pages/home_page.dart';
import 'package:money_management/pages/statistics.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentBottomBarNavigationIndex = 0;
  final List<Widget> _navigationPages = [
    HomePage(),
    Statistics(),
    BugetView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navigationPages[_currentBottomBarNavigationIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentBottomBarNavigationIndex,
        height: 60,
        onDestinationSelected: (value) {
          setState(() {
            _currentBottomBarNavigationIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.timeline), label: "Timeline"),
          NavigationDestination(icon: Icon(Icons.pie_chart), label: "Statistics"),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "Budget"),
        ],
      ),  
    );
  }
}
