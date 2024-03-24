// ignore_for_file: non_constant_identifier_names, prefer_final_fields

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/components/my_list_tile.dart';
import 'package:money_management/components/my_popup.dart';
import 'package:money_management/database/expense_database.dart';
import 'package:money_management/enums/category_enum.dart';
import 'package:money_management/models/expense.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});
  
  
  @override
  State<StatefulWidget> createState() => StatisticsState();
}

class StatisticsState extends State<Statistics> {
  ExpenseDatabase localDb = ExpenseDatabase();
  late Future<void> _initFuture;
  late List<Expense> _currentDatesExpenses;
  List<PieChartSectionData> _pieData = [];
  Map<CategoryEnum, double> _expensesMap = {};
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String totalSpendingsBetweenDates = "0";

  @override
  void initState() {
    super.initState();
    _initFuture = InitChart();
  }

  Future<void> InitChart() async {
    _currentDatesExpenses = await localDb.getExpensesBetweenDates(startDate, endDate);
    totalSpendingsBetweenDates = CurrentDaySpendings();
    BuildExpensesMap();
    PopulateChart();
  }

  String CurrentDaySpendings() {
    if (_currentDatesExpenses.isNotEmpty) {
      return totalSpendingsBetweenDates = _currentDatesExpenses.map((_) => _.spendedValue).reduce((value, element) => value + element).toString();
    }
    return '0';
  }

  void BuildExpensesMap() {
    _expensesMap.clear();
    for (var expense in _currentDatesExpenses) {
      if (_expensesMap.containsKey(expense.category)) {
        _expensesMap[expense.category] = _expensesMap[expense.category]! + expense.spendedValue;
      }
      else 
      {
        _expensesMap[expense.category] = expense.spendedValue;
      }
    }
  }

  void PopulateChart() {
    _pieData.clear();
    _expensesMap.forEach((key, value) {
      _pieData.add(PieChartSectionData(
        value: value,
        showTitle: true,
        title: key.name + value.toString(),
        color: GetCategoryColor(key),
      ));
    });
  }

  String FormatTitle(double value, CategoryEnum key){
    return "${key.name} $value RON";
  }

  Color GetCategoryColor(CategoryEnum category) {
    switch(category){
      case CategoryEnum.food:
        return Colors.green;
      case CategoryEnum.shopping:
        return Colors.blue;
      case CategoryEnum.car:
        return Colors.red;
      case CategoryEnum.fun:
        return const Color.fromARGB(255, 250, 228, 34);
      case CategoryEnum.payments:
        return Colors.purple[300]!;
      case CategoryEnum.house:
        return Colors.deepOrange[400]!;
      case CategoryEnum.drinks:
        return Colors.cyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snaphot) {
        if (snaphot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snaphot.hasError) {
          return const Center(child: Text("Error occured"),);
        }
        else 
        {
          return _buildMainWidget();
        }
      }
    );
  }  

  Widget _buildMainWidget() {
    return Scaffold(
            body: Column(  
                children: [
                  Expanded(
                    child: Row(children: [
                      Expanded(
                        flex: 5,
                        child: Center(child: Text("Expenses from ${DateFormat('dd.MM.yyyy').format(startDate)} to ${DateFormat('dd.MM.yyyy').format(endDate)}",
                        style: const TextStyle(fontSize: 16))
                        )),
                      Expanded(
                        child: ElevatedButton(onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(title: Text("Change date's"), 
                            content: StatefulBuilder(builder: (context, setState) {
                              return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(onPressed: () async {
                                            final DateTime? pickedStartDate = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(2000),
                                              lastDate: endDate,
                                            );
                                            if (pickedStartDate != null) {
                                              setState(() {
                                                startDate = pickedStartDate;
                                              });
                                            }
                                          }, child: const Text("Pick start date")),
                                          Text(DateFormat('dd MMMM yyyy').format(startDate), style: const TextStyle(fontSize: 16),)
                                        ]
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(onPressed: () async {
                                            final DateTime? pickedEndDate = await showDatePicker(
                                              context: context,
                                              firstDate: startDate,
                                              lastDate: DateTime(2100)
                                            );
                                            if (pickedEndDate != null) {
                                              setState(() {
                                                endDate = pickedEndDate;
                                              });
                                            }
                                          }, child: const Text("Pick end date")),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 18.0),
                                            child: Text(DateFormat('dd MMMM yyyy').format(endDate), style: const TextStyle(fontSize: 16)),
                                          )
                                        ]
                                      ),
                                    ],
                                  );
                            },), 
                                actions: [
                                  _saveButton(),
                                  _cancelButton(),
                                ],
                              ),
                            );
                        }, child: const Icon(Icons.date_range)),
                      ),
                    ],),
                  ),
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          swapAnimationDuration: const Duration(milliseconds: 1000),
                          swapAnimationCurve: Curves.easeInOutQuint,
                          PieChartData(
                            sectionsSpace: 2.5,
                            centerSpaceRadius: 80,
                            sections: _pieData,
                          )
                        ),
                        Text(totalSpendingsBetweenDates, style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: _currentDatesExpenses.length,
                      itemBuilder: (context, int index) {
                        Expense individualExpense = _currentDatesExpenses[index];
                        return MyListTile(
                          expense: individualExpense, 
                          onEditPressed: (context) => {EditExpense(index)}, 
                          onDeletePressed: (context) => {DeleteExpense(index)}
                        );
                      }
                    ),
                  )
                ],
              ),
          ); 
  }

  DeleteExpense(int index) {
    if (_currentDatesExpenses.contains(_currentDatesExpenses[index])) {
      localDb.deleteExpense(_currentDatesExpenses[index].id);
    }
    //SetStateAfterDeleteExpense(index);
    _currentDatesExpenses.removeAt(index);
    BuildExpensesMap();
    PopulateChart();
    totalSpendingsBetweenDates = CurrentDaySpendings();
    setState(() {});
  }

  void SetStateAfterDeleteExpense(int index) {
    setState(() {
      for (int i = 0; i < _pieData.length; i++) {
        if (_pieData[i].title == _currentDatesExpenses[index].category.name) {
          _pieData[i] = _pieData[i].copyWith(value: _pieData[i].value - _currentDatesExpenses[index].spendedValue,
          color: _pieData[i].color,); 
          break;
        }
      }
    });
  }

  EditExpense(int index) {
    var popup = MyPopup(title: "Edit expense", localDb: localDb, expense: _currentDatesExpenses[index]);
    showDialog (context: context, builder: (context) => popup)
    .then((value) {
      popup.getExpense!.date.isBefore(startDate) || popup.getExpense!.date.isAfter(endDate) ? _currentDatesExpenses.removeAt(index) : _currentDatesExpenses[index] = popup.getExpense!;
      BuildExpensesMap();
      PopulateChart();
      totalSpendingsBetweenDates = CurrentDaySpendings();
      setState(() {}); 
    });
  }

  Widget _cancelButton() {
      return MaterialButton(
        onPressed: (){
          Navigator.pop(context);

        },
        child: const Text("Cancel"),
      );
    }

  Widget _saveButton() {
    return MaterialButton(
        onPressed: () async {
          Navigator.pop(context);
          _currentDatesExpenses = await localDb.getExpensesBetweenDates(startDate, endDate);
          setState(() {
            BuildExpensesMap();
            PopulateChart();
            totalSpendingsBetweenDates = CurrentDaySpendings();
          });
        },
        child: const Text("Save"),
      );
    }
}
