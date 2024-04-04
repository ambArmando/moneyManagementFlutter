import 'dart:io';

import 'package:isar/isar.dart';
import 'package:money_management/enums/category_enum.dart';
import 'package:money_management/models/category.dart';

part 'expense.g.dart';

@Collection()
class Expense {
  Id id = Isar.autoIncrement;
  
  double spendedValue;

  @enumerated
  CategoryEnum category;

  DateTime date;

  String? note;

  Expense({
    required this.spendedValue,
    required this.category,
    required this.date,
    required this.note,
  }) ;
}

