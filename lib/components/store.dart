import 'package:flutter/material.dart';
import 'package:money_management/enums/buget_categories_enum.dart';


class Store extends ChangeNotifier {
  
  Map<BugetEnum, bool> _isBudgetCategoryValueAboveLimitMap = {};

  Map<BugetEnum, bool> get isBudgetCategoryValueAboveLimitMap => _isBudgetCategoryValueAboveLimitMap;

  void updateData(Map<BugetEnum, bool> isBudgetCategoryValueAboveLimitMapNew) {
    _isBudgetCategoryValueAboveLimitMap = {...isBudgetCategoryValueAboveLimitMapNew};
    notifyListeners();
  }

}