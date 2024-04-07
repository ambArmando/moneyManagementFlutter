import 'dart:ffi';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:money_management/models/category.dart';

part 'expense.g.dart';

@Collection()
class Expense {
  Id id = Isar.autoIncrement;
  
  double spendedValue;

  final category = IsarLink<Category>();

  DateTime date;

  String? note;

  Expense({
    required this.spendedValue,
    Category? category,
    required this.date,
    required this.note,
  }) {
    this.category.value = category;
  }
}

