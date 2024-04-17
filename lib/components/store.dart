import 'package:flutter/material.dart';


class Store extends ChangeNotifier {
  
  DateTime? _firstDayOfSelectedMonth;
  DateTime? _lastDayOfSelectedMonth;

  DateTime? get firstDayOfSelectedMonth => _firstDayOfSelectedMonth;
  DateTime? get lastDayOfSelectedMonth => _lastDayOfSelectedMonth;

  set firstDayOfSelectedMonth(DateTime? value) {
    _firstDayOfSelectedMonth = value;
    notifyListeners();
  }

  set lastDayOfSelectedMonth(DateTime? value) {
    _lastDayOfSelectedMonth = value;
    notifyListeners();
  }

}