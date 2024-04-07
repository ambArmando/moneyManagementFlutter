// ignore_for_file: non_constant_identifier_names, prefer_final_fields

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_management/components/store.dart';
import 'package:money_management/database/expense_database.dart';
import 'package:money_management/enums/buget_categories_enum.dart';
import 'package:money_management/models/budget.dart';
import 'package:money_management/models/expense.dart';
import 'package:provider/provider.dart';

class BugetView extends StatefulWidget {
  const BugetView({super.key});

  @override
  State<StatefulWidget> createState() => BugetState();
}

class BugetState extends State<BugetView> {
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
  late Budget? currentBuget;

  @override
  void initState() {
    super.initState();
    _initFuture = InitBarChart();
  }

  Future<void> InitBarChart() async {
    var firstDayOfCurrentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    var lastDayOfCurrentMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(const Duration(days: 1));
    selectedMonthExpenses = await localDb.getExpensesBetweenDates(firstDayOfCurrentMonth, lastDayOfCurrentMonth);
    currentBuget = await localDb.getBuget(DateTime.now().month, DateTime.now().year);
    currentBuget != null ? _bugetController.text = currentBuget!.value.toString() : "";
    BuildBugetMap();
    PopulateChart();
  }

  void BuildBugetMap() {
    ClearBugetMap();
    for (var expense in selectedMonthExpenses) {
      switch (expense.category.value!.bugetCategory){
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
        case null:
          // TODO: Handle this case.
      }
    }
  }

  void ClearBugetMap() {
    _bugetMap[BugetEnum.fixedCosts] = 0;
    _bugetMap[BugetEnum.savings] = 0;
    _bugetMap[BugetEnum.investing] = 0;
    _bugetMap[BugetEnum.freeSpendings] = 0;
  }

  void PopulateChart() {
    _barChartData.clear();
    _bugetMap.forEach((key, value) {
      _barChartData.add(
        BarChartGroupData(
          x: key.index,
          barRods: [
            BarChartRodData(
              toY: GetToYRodData(key, value),
              width: 45,
              borderRadius: BorderRadius.circular(4),
              color: GetRodColor(key),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: GetBarRodMaxY(key),
                color: Colors.grey[300],
              )
            ),
          ]
        )
      );
    });
  }

  double GetToYRodData(BugetEnum key, double value) {
    var storeModel = Provider.of<Store>(context, listen: false);
    if (value > GetBarRodMaxY(key)) {
      storeModel.isBudgetCategoryValueAboveLimitMap[key] = true;
      storeModel.updateData(storeModel.isBudgetCategoryValueAboveLimitMap);
      return GetBarRodMaxY(key);
    } 
    else {
      if (storeModel.isBudgetCategoryValueAboveLimitMap.containsKey(key)) {
        storeModel.isBudgetCategoryValueAboveLimitMap[key] = false;
        storeModel.updateData(storeModel.isBudgetCategoryValueAboveLimitMap);
      }
      return value;
    }
  }

  Color GetRodColor(BugetEnum bugetEnum) {
    switch(bugetEnum){
      case BugetEnum.fixedCosts:
        return const Color.fromARGB(255, 124, 155, 255);
      case BugetEnum.freeSpendings:
        return const Color.fromARGB(255, 152, 255, 152);
      case BugetEnum.savings:
        return const Color.fromARGB(255, 213, 178, 248);
      case BugetEnum.investing:
        return const Color.fromARGB(255, 255, 215, 152);
    }
  }

  double GetBarRodMaxY(BugetEnum bugetEnum) {
    if (currentBuget == null) {
      return 0;
    }
    var percentage = GetPercentage(bugetEnum);

    return (currentBuget!.value * percentage) / 100;
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

  @override
  Widget build(BuildContext context){
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child:  Text("RON", style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]
                  ),),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _bugetController,     
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800]
                    ),
                    decoration: const InputDecoration(
                      hintText: "buget..."
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {
                  if (_bugetController.text.isEmpty) {
                    return;
                  }
                  _updateBuget(context);
                }, child: const Text("Change buget"),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: currentBuget == null || currentBuget!.value == 0 ? const Center(child: Text("Please save a buget first!"),) : BarChart(             
              BarChartData(
                maxY: GetMaxY(),
                minY: 0,
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTopTitles, reservedSize: 50)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getBottomTitles)),
                ),
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideHorizontally: true,
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      var bugetMapKeys = _bugetMap.keys.toList();
                      var tip = "Available buget for ${bugetMapKeys.elementAt(groupIndex).name} is ${group.barRods[0].backDrawRodData.toY} RON; ${GetPercentage(bugetMapKeys.elementAt(groupIndex))}% from the total of ${currentBuget!.value} RON";
                      return BarTooltipItem(tip, const TextStyle(color: Colors.white));
                    },
                  )
                ),
                barGroups: _barChartData,
              )
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }  

  double GetMaxY() {
    if (currentBuget == null) {
      return 0;
    }
    return currentBuget!.value / 2;
  }

  void _updateBuget(context) {
    showDialog(context: context,
     builder: (BuildContext context) {
      return AlertDialog (
          title: const Text("Change buget confirmation"),
          content: const Text("Are you sure you want to continue?"),
          actions: [
            TextButton(onPressed: () {
              if (_bugetController.text.isNotEmpty) {
                currentBuget ??= Budget(
                  value: double.tryParse(_bugetController.text)!,
                  month: DateTime.now().month,
                  year: DateTime.now().year
                );
                setState(() {
                  currentBuget!.value = double.tryParse(_bugetController.text)!;
                  BuildBugetMap();
                  PopulateChart();
                  localDb.updateBuget(currentBuget!);
                  Navigator.of(context).pop();
                });
              }
            }, 
            child: const Text("Yes")),
            TextButton(onPressed: () => {
              Navigator.of(context).pop()
            }, 
            child: const Text("No"))
          ],
        );
      }
    );
  }

  Widget getTopTitles(double value, TitleMeta meta) {
  var style = TextStyle(
    color:  Colors.grey[600],
    fontWeight: FontWeight.bold,
    fontSize: 11.5,
  );
  Widget child;
  switch (value.toInt()) {
    case 0:
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("RON ${GetRemainingBuget(BugetEnum.fixedCosts)} left", style: TextStyle(
            color: double.parse(GetRemainingBuget(BugetEnum.fixedCosts)) < 0 ? Colors.red[400] : Colors.green[400],
            fontWeight: FontWeight.bold,
            fontSize: 11.5,
          ),),
          Text("of ${GetBarRodMaxY(BugetEnum.fixedCosts).toString()} RON", style: style)
        ],);
      break;
    case 1:
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("RON ${GetRemainingBuget(BugetEnum.savings)} left ", style: TextStyle(
            color: double.parse(GetRemainingBuget(BugetEnum.savings)) < 0 ? Colors.red[400] : Colors.green[400],
            fontWeight: FontWeight.bold,
            fontSize: 11.5,
          ),),
          Text("of ${GetBarRodMaxY(BugetEnum.savings).toString()} RON", style: style)
        ],);
      break;
    case 2:
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("RON ${GetRemainingBuget(BugetEnum.investing)} left ", style: TextStyle(
            color: double.parse(GetRemainingBuget(BugetEnum.investing)) < 0 ? Colors.red[400] : Colors.green[400],
            fontWeight: FontWeight.bold,
            fontSize: 11.5,
          ),),
          Text("of ${GetBarRodMaxY(BugetEnum.investing).toString()} RON", style: style)
        ],);
      break;
    case 3:
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("RON ${GetRemainingBuget(BugetEnum.freeSpendings)} left ", style: TextStyle(
            color: double.parse(GetRemainingBuget(BugetEnum.freeSpendings)) < 0 ? Colors.red[400] : Colors.green[400],
            fontWeight: FontWeight.bold,
            fontSize: 11.5,
          ),),
          Text("of ${GetBarRodMaxY(BugetEnum.freeSpendings).toString()} RON", style: style)
        ],);
        break;
    default: 
      child = const Text("");
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: child);
  }

  String GetRemainingBuget(BugetEnum bugetEnum) {
    var remainingValue = GetBarRodMaxY(bugetEnum) - _bugetMap[bugetEnum]!;

    return remainingValue.toString();
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
      text = Text("Fixed Costs", style: style,);
      break;
    case 1:
      text = Text("Savings", style: style,);
      break;
    case 2:
      text = Text("Investings", style: style,);
      break;
    case 3:
      text = Text("Free Spendings", style: style,);
      break;
    default:
      text = const Text("");
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}