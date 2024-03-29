import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../enums/category_enum.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Expense> _allExpenses = [];
  final List<Category> _defaultCategorys = [
    Category(name: CategoryEnum.food, imgPath: "food.png"),
    Category(name: CategoryEnum.shopping, imgPath: "shopping.png"),
    Category(name: CategoryEnum.car, imgPath: "car.png"),
    Category(name: CategoryEnum.fun, imgPath: "fun.png"),
    Category(name: CategoryEnum.payments, imgPath: "payments.png"),
    Category(name: CategoryEnum.house, imgPath: "house.png"),
  ];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema, CategorySchema], directory: dir.path);
  }

  List<Expense> get allExpenses => _allExpenses;
  List<Category> get defaultCategorys => _defaultCategorys;

  Future<void> createNewExpense(Expense expense) async {
    await isar.writeTxn(() => isar.expenses.put(expense));
  }

  Future<List<Expense>> getExpenses() async {
    return await isar.expenses.where().findAll();
  }

  Future<List<Expense>> getCurrentDayExpenses() async {
    var allList = await isar.expenses.where().findAll();
    return allList.where((_) => _.date.day == DateTime.now().day && _.date.month == DateTime.now().month && _.date.year == DateTime.now().year).toList();
  }

  void deleteExpense(int id) async {
    await isar.writeTxn(() async {
      await isar.expenses.delete(id);
    });
  }

  Future<void> updateExpense(Expense expense) async {
    await isar.writeTxn(() async {
      await isar.expenses.put(expense);
    });
  }

  Future<List<Expense>> getExpensesBetweenDates(DateTime startDate, DateTime endDate) async {
    var month = await isar.expenses.filter()
    .dateBetween(startDate, endDate)
    .sortByDateDesc()
    .findAll();
    return month;
  }
  
}