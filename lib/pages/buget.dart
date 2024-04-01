// ignore_for_file: non_constant_identifier_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_management/database/expense_database.dart';
import 'package:money_management/enums/buget_categories_enum.dart';
import 'package:money_management/enums/category_enum.dart';
import 'package:money_management/models/expense.dart';

class Buget extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => BugetState();
}

class BugetState extends State<Buget> {
  final TextEditingController _bugetController = TextEditingController();
  ExpenseDatabase localDb = ExpenseDatabase();
  late Future<void> _initFuture;
  List<Expense> selectedMonthExpenses = []; 
  Map<BugetEnum, double> _bugetMap = {
    BugetEnum.fixedCosts : 0,
    BugetEnum.savings : 0,
    BugetEnum.investing : 0,
    BugetEnum.freeSpendings : 0,
  };
  List<BarChartGroupData> _barChartData = [];

  @override
  void initState() {
    super.initState();
    _initFuture = InitBarChart();
  }

  Future<void> InitBarChart() async {
    var firstDayOfCurrentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    var lastDayOfCurrentMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(const Duration(days: 1));
    selectedMonthExpenses = await localDb.getExpensesBetweenDates(firstDayOfCurrentMonth, lastDayOfCurrentMonth);
    BuildBugetMap();
    PopulateChart();
  }

  void BuildBugetMap() {
    for (var expense in selectedMonthExpenses) {
      switch (GetExpenseBugetCategory(expense.category)){
        case BugetEnum.fixedCosts:
          _bugetMap[BugetEnum.fixedCosts] = _bugetMap[BugetEnum.fixedCosts]! + expense.spendedValue;
          break;
        case BugetEnum.savings:
          _bugetMap[BugetEnum.savings] = _bugetMap[BugetEnum.savings]! + expense.spendedValue;
          break;
        case BugetEnum.investing:
          _bugetMap[BugetEnum.investing] = _bugetMap[BugetEnum.investing]! + expense.spendedValue;
          break;
        case BugetEnum.freeSpendings:
          _bugetMap[BugetEnum.freeSpendings] = _bugetMap[BugetEnum.freeSpendings]! + expense.spendedValue;
          break;
      }
    }
  }

  void PopulateChart() {
    _bugetMap.forEach((key, value) {
      _barChartData.add(
        BarChartGroupData(
          x: key.index,
          barRods: [
            BarChartRodData(
              toY: value,
              width: 25,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: GetBarRodMaxY(key),
                color: Colors.grey[200],
              )
            ),
          ]
        )
      );
    });
  }

  double GetBarRodMaxY(BugetEnum bugetEnum) {
    var buget = 5000;
    var percentage = GetPercentage(bugetEnum);

    return (buget * percentage) / 100;
  }

  int GetPercentage(BugetEnum bugetEnum) {
    switch(bugetEnum){
      case BugetEnum.fixedCosts:
        return 50;
      case BugetEnum.freeSpendings:
        return 35;
      case BugetEnum.savings:
        return 10;
      case BugetEnum.investing:
        return 5;
    }
  }

  BugetEnum GetExpenseBugetCategory(CategoryEnum expenseCategory) {
    switch(expenseCategory){
      case CategoryEnum.food:
      case CategoryEnum.house:
      case CategoryEnum.payments:
        return BugetEnum.fixedCosts;
      case CategoryEnum.shopping:
      case CategoryEnum.car:
      case CategoryEnum.fun:
        return BugetEnum.freeSpendings;
      case CategoryEnum.savings:
        return BugetEnum.savings;
      case CategoryEnum.stock:
      case CategoryEnum.crypto:
        return BugetEnum.investing;
      default: 
        return BugetEnum.freeSpendings;
    }
  }

  @override
  Widget build(BuildContext context){
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
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.top,
                    controller: _bugetController,
                    decoration: const InputDecoration(
                      label: Text("Buget", style: TextStyle(
                        fontSize: 20
                      ),),
                      hintText: "enter your buget...",
                      helperText: "RON",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const ElevatedButton(onPressed: null, child: Icon(Icons.save)),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: BarChart(
              BarChartData(
                maxY: 2500,
                minY: 0,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTopTitles)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getBottomTitles)),
                ),
                alignment: BarChartAlignment.spaceEvenly,
                barGroups: _barChartData,
              )
            )
          ),
          Expanded(
            flex: 2,
            child: Container())
        ],
      ),
    );
  }  

  Widget getTopTitles(double value, TitleMeta meta) {
  var style = TextStyle(
    color: Colors.grey[600],
    fontWeight: FontWeight.bold,
    fontSize: 11,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text("${GetBarRodMaxY(BugetEnum.fixedCosts).toString()} RON", style: style,);
      break;
    case 1:
      text = Text(GetBarRodMaxY(BugetEnum.savings).toString(), style: style,);
      break;
    case 2:
      text = Text(GetBarRodMaxY(BugetEnum.investing).toString(), style: style,);
      break;
    case 3:
      text = Text(GetBarRodMaxY(BugetEnum.freeSpendings).toString(), style: style,);
      break;
    default:
      text = const Text("");
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
}

Widget getBottomTitles(double value, TitleMeta meta) {
  var style = TextStyle(
    color: Colors.grey[600],
    fontWeight: FontWeight.bold,
    fontSize: 11,
    
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text(BugetEnum.fixedCosts.name, style: style,);
      break;
    case 1:
      text = Text(BugetEnum.savings.name, style: style,);
      break;
    case 2:
      text = Text(BugetEnum.investing.name, style: style,);
      break;
    case 3:
      text = Text(BugetEnum.freeSpendings.name, style: style,);
      break;
    default:
      text = const Text("");
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}