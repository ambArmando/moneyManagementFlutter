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
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(const Duration(days: 1));
  String totalSpendingsBetweenDates = "0";
  List<Expense> _currentDatesExpensesCopy = [];
  int? touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _initFuture = InitChart();
  }

  Future<void> InitChart() async {
    _currentDatesExpenses = await localDb.getExpensesBetweenDates(startDate, endDate);
    _currentDatesExpensesCopy = List.from(_currentDatesExpenses);
    totalSpendingsBetweenDates = CurrentDaySpendings();
    BuildExpensesMap();
    UpdatePieChartWithExpensesData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snaphot) {
        if (snaphot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
          const SizedBox(height: 10),
          Row ( 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${DateFormat('d.MMMM.yyyy').format(startDate)} - ${DateFormat('d.MMMM.yyyy').format(endDate)}",
                style:const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
              ),
              ElevatedButton(onPressed: () { ChangeDates(); },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
                child: const Icon(Icons.date_range),
              ),
            ],
          ),
          Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey[100],
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _pieData.isEmpty ? const Text("No data available...") :
                          PieChart(
                            swapAnimationDuration: const Duration(milliseconds: 1000),
                            swapAnimationCurve: Curves.easeInOutQuint,
                            PieChartData(
                              sectionsSpace: 2.5,
                              centerSpaceRadius: 60,
                              sections: _pieData,
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions || pieTouchResponse?.touchedSection == null) {
                                      touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                                      return;
                                    }
                                    else {
                                      touchedIndex = pieTouchResponse?.touchedSection!.touchedSectionIndex;
                                      UpdatePieChartWithExpensesData();
                                      FilterExpensesOnPieChartTouch(touchedIndex);
                                    }
                                  });
                                }, 
                              )
                            )
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _pieData.isNotEmpty ? Column(
                                children: [
                                  const Text("Total:"),
                                  Text("$totalSpendingsBetweenDates RON", style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ) 
                              :
                              Container(),
                            ]
                          ),
                          Positioned(
                            bottom: 3,
                            left: 5,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: _pieLegend()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: _currentDatesExpensesCopy.length,
                      itemBuilder: (context, int index) {
                        Expense individualExpense = _currentDatesExpensesCopy[index];
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

  Future<dynamic> ChangeDates() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(title: const Text("Change dates"), 
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
                  Text(DateFormat('dd MMM yyyy').format(startDate), style: const TextStyle(fontSize: 16),)
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
                      child: Text(DateFormat('dd MMM yyyy').format(endDate), style: const TextStyle(fontSize: 16)),
                  )
                ]
              ),
            ],
          );
        }), 
        actions: [
          _saveButton(),
          _cancelButton(),
        ],
      ),
    );
  }

  void BuildExpensesMap() {
    _expensesMap.clear();
    for (var expense in _currentDatesExpenses) {
      if (_expensesMap.containsKey(expense.category.value!.name)) {
        _expensesMap[expense.category.value!.name] = _expensesMap[expense.category.value!.name]! + expense.spendedValue;
      }
      else 
      {
        _expensesMap[expense.category.value!.name] = expense.spendedValue;
      }
    }
  }

  void UpdatePieChartWithExpensesData() {
    _pieData.clear();
    var expensesMapKeys = _expensesMap.keys.toList();
    _expensesMap.forEach((key, value) {
      _pieData.add(PieChartSectionData(
        value: value,
        showTitle: true,
        title: value.toString(),
        radius: expensesMapKeys.indexOf(key) == touchedIndex ? 70 : 60,
        titleStyle: TextStyle(
          fontSize: expensesMapKeys.indexOf(key) == touchedIndex ? 25 : 15,
          fontWeight: expensesMapKeys.indexOf(key) == touchedIndex ? FontWeight.bold : FontWeight.normal,
        ),
        color: GetCategoryColor(key),
      ));
    });
  }

  void DeleteExpense(int index) {
    var deletedExpense = _currentDatesExpensesCopy[index];
    var deletedExpenseCategory = deletedExpense.category.value!.name;
    if (_currentDatesExpensesCopy.contains(deletedExpense)) {
      localDb.deleteExpense(deletedExpense.id);
    } 
    _currentDatesExpenses.remove(deletedExpense);
    _currentDatesExpensesCopy.removeAt(index);
    _expensesMap[deletedExpenseCategory] = _expensesMap[deletedExpenseCategory]! - deletedExpense.spendedValue;
    
    if (_expensesMap[deletedExpenseCategory] == 0) {
      _expensesMap.remove(deletedExpenseCategory);
    }

    if (_currentDatesExpensesCopy.isEmpty) {
      touchedIndex = -1;
    }

    if (_currentDatesExpensesCopy.isNotEmpty && touchedIndex != -1){
      touchedIndex = _expensesMap.keys.toList().indexOf(deletedExpenseCategory);
    }

    UpdatePieChartWithExpensesData();
    FilterExpensesOnPieChartTouch(touchedIndex);
    setState(() { 
      totalSpendingsBetweenDates = CurrentDaySpendings();
    });
  }

  EditExpense(int index) {
    var editedExpense = _currentDatesExpensesCopy[index];
    var editedExpenseCategory = editedExpense.category.value!.name;
    _expensesMap[editedExpenseCategory] = _expensesMap[editedExpenseCategory]! - editedExpense.spendedValue;
    var popup = MyPopup(title: "Edit expense", localDb: localDb, expense: editedExpense);
    showDialog (context: context, builder: (context) => popup)
    .then((value) {
      if (popup.getExpense!.date.isBefore(startDate) || popup.getExpense!.date.isAfter(endDate)) {
        _currentDatesExpensesCopy.removeAt(index);
        _currentDatesExpenses.remove(editedExpense);
      }
      else 
      {
        _expensesMap.containsKey(editedExpense.category.value!.name) ? _expensesMap[editedExpense.category.value!.name] = _expensesMap[editedExpense.category.value!.name]! + editedExpense.spendedValue : _expensesMap[editedExpense.category.value!.name] = editedExpense.spendedValue;
      }

      if (_expensesMap[editedExpenseCategory] == 0) {
        _expensesMap.remove(editedExpenseCategory);
        touchedIndex = _expensesMap.keys.toList().indexOf(editedExpense.category.value!.name);
      }

      UpdatePieChartWithExpensesData();
      FilterExpensesOnPieChartTouch(touchedIndex);
      setState(() {
        totalSpendingsBetweenDates = CurrentDaySpendings();
      }); 
    });
  }

  void FilterExpensesOnPieChartTouch(int? touchedIndex) {
    if (touchedIndex == null) return;
    if (touchedIndex < 0) {
      _currentDatesExpensesCopy = List.from(_currentDatesExpenses);
      return;
    }
    var keysIndex = _expensesMap.keys.toList();
    _currentDatesExpensesCopy = _currentDatesExpenses.where((element) => keysIndex.elementAt(touchedIndex) == element.category.value!.name).toList();
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
          _currentDatesExpensesCopy = List.from(_currentDatesExpenses);
          setState(() {
            BuildExpensesMap();
            UpdatePieChartWithExpensesData();
            totalSpendingsBetweenDates = CurrentDaySpendings();
          });
        },
        child: const Text("Save"),
      );
  }

  String CurrentDaySpendings() {
    if (_currentDatesExpenses.isNotEmpty) {
      return totalSpendingsBetweenDates = _currentDatesExpenses.map((_) => _.spendedValue).reduce((value, element) => value + element).toString();
    }
    return '0';
  }

  Widget _pieLegend() {
    List<Widget> legend = [];
    for(var key in _expensesMap.keys) {
      legend.add(Row(
        children: [
          Container(width: 20, height: 20, color: GetCategoryColor(key), margin: const EdgeInsets.only(bottom: 3),),
          Container(
            margin: const EdgeInsets.only(left: 5, bottom: 5),
            child: Text(key.name)
          ),
          const SizedBox(width: 15)
        ],
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: legend
      ),
    );
  }

  Color GetCategoryColor(CategoryEnum category) {
    switch(category){
      case CategoryEnum.Housing:
        return Colors.blue[300]!;
      case CategoryEnum.Utilities:
        return Colors.blue[400]!;
      case CategoryEnum.Transportation:
        return Colors.blue[500]!;
      case CategoryEnum.Groceries:
        return Colors.blue[600]!;
      case CategoryEnum.EmergencyFund:
        return Colors.purple[200]!;
      case CategoryEnum.ShortTermGoals:
        return Colors.purple[300]!;
      case CategoryEnum.LongTermGoals:
        return Colors.purple[500]!;
      case CategoryEnum.Education:
        return Colors.yellow[400]!;
      case CategoryEnum.StockMarket:
        return Colors.yellow[500]!;
      case CategoryEnum.Cryptocurrency:
        return Colors.yellow[600]!;
      case CategoryEnum.Travel:
        return Colors.lightGreen[200]!;
      case CategoryEnum.Hobbies:
        return Colors.lightGreen[300]!;
      case CategoryEnum.Gifts:
        return Colors.lightGreen[400]!;
      case CategoryEnum.Shopping:
        return Colors.lightGreen[500]!;
      case CategoryEnum.DiningOut:
        return Colors.lightGreen[600]!;
      default: 
        return Colors.transparent;
    }
  }

}
