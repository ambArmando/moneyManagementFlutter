import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:money_management/enums/buget_categories_enum.dart';
import 'package:money_management/models/buget.dart';
import 'package:path_provider/path_provider.dart';
import '../enums/category_enum.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Expense> _allExpenses = [];
  final List<Category> _defaultCategorys = [
    Category(name: CategoryEnum.Housing, bugetCategory: BugetEnum.fixedCosts, imgPath: "Housing.png"),
    Category(name: CategoryEnum.Utilities, bugetCategory: BugetEnum.fixedCosts, imgPath: "Utilities.png"),
    Category(name: CategoryEnum.Transportation, bugetCategory: BugetEnum.fixedCosts, imgPath: "Transportation.png"),
    Category(name: CategoryEnum.Groceries, bugetCategory: BugetEnum.fixedCosts, imgPath: "groceries.png"),
    Category(name: CategoryEnum.EmergencyFund, bugetCategory: BugetEnum.savings, imgPath: "emergencyfund.png"),
    Category(name: CategoryEnum.ShortTermGoals, bugetCategory: BugetEnum.savings, imgPath: "shorttermgoals.png"),
    Category(name: CategoryEnum.LongTermGoals, bugetCategory: BugetEnum.savings, imgPath: "longtermgoals.png"),
    Category(name: CategoryEnum.Education, bugetCategory: BugetEnum.investing, imgPath: "education.png"),
    Category(name: CategoryEnum.StockMarket, bugetCategory: BugetEnum.investing, imgPath: "stockmarket.png"),
    Category(name: CategoryEnum.Cryptocurrency, bugetCategory: BugetEnum.investing, imgPath: "cryptocurrency.png"),
    Category(name: CategoryEnum.Travel, bugetCategory: BugetEnum.freeSpendings, imgPath: "travel.png"),
    Category(name: CategoryEnum.Hobbies, bugetCategory: BugetEnum.freeSpendings, imgPath: "hobbies.png"),
    Category(name: CategoryEnum.Gifts, bugetCategory: BugetEnum.freeSpendings, imgPath: "gifts.png"),
    Category(name: CategoryEnum.Shopping, bugetCategory: BugetEnum.freeSpendings, imgPath: "shopping.png"),
    Category(name: CategoryEnum.DiningOut, bugetCategory: BugetEnum.freeSpendings, imgPath: "diningout.png"),
  ];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema, CategorySchema, BugetSchema], directory: dir.path);
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

  Future<Buget?> getBuget (int month, int year) async {
    return await isar.bugets.filter().monthEqualTo(month).yearEqualTo(year).findFirst();
  }

  Future<void> updateBuget (Buget buget) async {
      await isar.writeTxn(() async {
        await isar.bugets.put(buget);
    });
  }
  
}