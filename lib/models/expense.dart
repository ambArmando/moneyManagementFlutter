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

  @override
  bool operator ==(Object other) =>
      other is Expense &&
      other.runtimeType == runtimeType &&
      other.category.value == category.value;

  @override
  int get hashCode => category.value.hashCode;

  Expense({
    required this.spendedValue,
    Category? category,
    required this.date,
    required this.note,
  }) {
    this.category.value = category;
  }
}

