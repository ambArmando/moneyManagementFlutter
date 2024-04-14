// ignore_for_file: non_constant_identifier_names, prefer_final_fields

import 'package:carbon_icons/carbon_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:money_management/database/expense_database.dart';
import 'package:money_management/enums/buget_categories_enum.dart';
import 'package:money_management/models/budget.dart';
import 'package:money_management/models/expense.dart';

class BugetView extends StatefulWidget {
  const BugetView({super.key});

  @override
  State<StatefulWidget> createState() => BugetState();
}

class BugetState extends State<BugetView> {
  final TextEditingController _budgetAmountController = TextEditingController();
  final TextEditingController _freeSpendingsController = TextEditingController();
  final TextEditingController _fixedCostsController = TextEditingController();
  final TextEditingController _investingController = TextEditingController();
  final TextEditingController _savingsController = TextEditingController();
  late Future<void> _initFuture;
  late Budget? currentBuget;
  ExpenseDatabase localDb = ExpenseDatabase();
  List<Expense> selectedMonthExpenses = []; 
  List<BarChartGroupData> _barChartData = [];
  Map<BugetEnum, double> _bugetMap = {};
  bool? _changeBudgetCategoryProcents = false;
  bool isEditProcentsEnabled = true;
  String? errorTextBudgetAmount;
  String? errorTextFixedCosts;
  String? errorTextFreeSpendings;
  String? errorTextSavings;
  String? errorTextInvesting;
  int procentsLeft = 0;
  bool isProcentsInfoVisible = false;
  var _statefullBuilderSetState;

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
    BuildBugetMap();
    PopulateChart();
  }

  void BuildBugetMap() {
    _bugetMap.clear();
    for (var expense in selectedMonthExpenses) {
      var expenseBudgetCategory = expense.category.value!.bugetCategory;
      if (_bugetMap.containsKey(expenseBudgetCategory)) {
        _bugetMap[expenseBudgetCategory] = _bugetMap[expenseBudgetCategory]! + expense.spendedValue;
      }
      else 
      {
        _bugetMap[expenseBudgetCategory] = expense.spendedValue;
      }
    }
  }

  void PopulateChart() {
    _barChartData.clear();
    _bugetMap.forEach((key, value) {
      _barChartData.add(
        BarChartGroupData(
          x: key.index,
          barRods: [
            BarChartRodData(
              toY: value > GetBarRodMaxY(key) ? GetBarRodMaxY(key) : value,
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
    return currentBuget == null ? 0 : (currentBuget!.value * GetPercentage(bugetEnum)) / 100;
  }

  int GetPercentage(BugetEnum bugetEnum) {
    switch(bugetEnum){
      case BugetEnum.fixedCosts:
        return currentBuget!.fixedCosts!;
      case BugetEnum.freeSpendings:
        return currentBuget!.freeSpendings!;
      case BugetEnum.savings:
        return currentBuget!.savings!;
      case BugetEnum.investing:
        return currentBuget!.investing!;
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: currentBuget?.value != null,
                  child: Text("RON", style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]
                  ),),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: Text(currentBuget?.value.toString() ?? "" ,  
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800]
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              CreateNewBudget(context);
            },
            child: const Text("Create a New Budget"),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: currentBuget == null || currentBuget!.value == 0 ? const Center(child: Text("Create a buget first!"),) : BarChart(             
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

  CreateNewBudget(context) {
    _budgetAmountController.text = "";
    _freeSpendingsController.text = "";
    _fixedCostsController.text = "";
    _savingsController.text = "";
    _investingController.text = "";
    _changeBudgetCategoryProcents = false;
    isEditProcentsEnabled = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            _statefullBuilderSetState = setState;
            return AlertDialog(
              title: const FittedBox(
                fit: BoxFit.scaleDown,
                child:
                  Text("Create New Budget", maxLines: 1, textAlign: TextAlign.start,)
              ),
              content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Budget value", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                        ),)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _budgetAmountController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.attach_money),
                            hintText: "Amount", 
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Categories procents", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                        ),)),       
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,                                
                                LengthLimitingTextInputFormatter(3),
                              ],
                              enabled: isEditProcentsEnabled,
                              controller: _fixedCostsController,
                              onChanged: (value) => LimitProcentInput(value, _fixedCostsController),
                              decoration: InputDecoration(
                                icon: const Icon(CarbonIcons.home),
                                hintText: "Fixed costs",
                                errorText: errorTextFixedCosts,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _savingsController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              onChanged: (value) => LimitProcentInput(value, _savingsController),
                              enabled: isEditProcentsEnabled,
                              decoration: InputDecoration(
                                icon: const Icon(CarbonIcons.piggy_bank),
                                hintText: "Savings",
                                errorText: errorTextSavings
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _investingController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              enabled: isEditProcentsEnabled,
                              onChanged: (value) => LimitProcentInput(value, _investingController),
                              decoration: InputDecoration(
                                icon: const Icon(CarbonIcons.chart_line_smooth),
                                hintText: "Investing",
                                errorText: errorTextInvesting
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _freeSpendingsController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              enabled: isEditProcentsEnabled,
                              onChanged: (value) => LimitProcentInput(value, _freeSpendingsController),
                              decoration: InputDecoration(
                                icon: const Icon(CarbonIcons.brush_freehand),
                                hintText: "Free spendings",
                                errorText: errorTextFreeSpendings
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Visibility(
                              visible: isProcentsInfoVisible,
                              child: Text("*Procents sum is ${procentsLeft} it must equal 100", style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[400]
                              ),),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: _changeBudgetCategoryProcents,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _changeBudgetCategoryProcents = value;
                                    if (value == false) {
                                      _fixedCostsController.text = "";
                                      _savingsController.text = "";
                                      _investingController.text = "";
                                      _freeSpendingsController.text = "";
                                      isEditProcentsEnabled = true;
                                    }
                                    else if (value = true) {
                                      _fixedCostsController.text = "50";
                                      _savingsController.text = "5";
                                      _investingController.text = "10";
                                      _freeSpendingsController.text = "35";
                                      isEditProcentsEnabled = false;
                                    }
                                  });
                                }
                              ),
                              const Text("Use default categories procents.")
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              actions: [
              _saveBudget(),
              _cancel(),
              ],
            );
          },
        );
      }
    );
  }

  Widget _saveBudget() {
    return MaterialButton(
      onPressed: () {
        if (_budgetAmountController.text.isEmpty) {
          //adauga errorText pe Amount
          return;
        }

        currentBuget ??= Budget(
          value: double.tryParse(_budgetAmountController.text)!,
          month: DateTime.now().month,
          year: DateTime.now().year
        );

        if (_changeBudgetCategoryProcents!) {
          currentBuget!.value = double.tryParse(_budgetAmountController.text)!;
          currentBuget!.fixedCosts = 50;
          currentBuget!.freeSpendings = 35;
          currentBuget!.savings = 10;
          currentBuget!.investing = 5;
        }

        if (!_changeBudgetCategoryProcents!) {
          if (!AreProcentsValid()) return;
          if (!IsProcentsSumValid()) return;

          currentBuget!.value = double.tryParse(_budgetAmountController.text)!;
          currentBuget!.fixedCosts = int.tryParse(_fixedCostsController.text);
          currentBuget!.freeSpendings = int.tryParse(_freeSpendingsController.text);
          currentBuget!.savings = int.tryParse(_savingsController.text);
          currentBuget!.investing = int.tryParse(_investingController.text);
        }

        localDb.updateBuget(currentBuget!);
        setState(() {
          PopulateChart();        
          Navigator.of(context).pop();
        });
      },
      child: const Text("Save"),
    );
  }

  Widget _cancel() {
    return MaterialButton(
      onPressed: (){
        _budgetAmountController.clear();
        _fixedCostsController.clear();
        _freeSpendingsController.clear();
        _savingsController.clear();
        _investingController.clear();
        _changeBudgetCategoryProcents = true;
        Navigator.of(context).pop();
      },
      child: const Text("Cancel"),
    );
  }

  void LimitProcentInput(String value, TextEditingController controller) {
    if (value.isNotEmpty) {
      if (int.parse(value) > 100) {
        controller.text = value.substring(0, value.length - 1);
      }
    }
  }

  bool AreProcentsValid() {
    var mandatoryField = "This field is mandatory";
    _statefullBuilderSetState(() {
      errorTextFixedCosts = _fixedCostsController.text.isEmpty ? mandatoryField : null;
      errorTextFreeSpendings = _freeSpendingsController.text.isEmpty ? mandatoryField : null;
      errorTextSavings = _savingsController.text.isEmpty ? mandatoryField : null;
      errorTextInvesting = _investingController.text.isEmpty ? mandatoryField : null;
    });
    return errorTextFixedCosts == null && errorTextFreeSpendings == null && errorTextSavings == null && errorTextInvesting == null; 
  }

  bool IsProcentsSumValid() {
    var fixedCosts = int.tryParse(_fixedCostsController.text);
    var freeSpendings = int.tryParse(_freeSpendingsController.text);
    var savings= int.tryParse(_savingsController.text);
    var investing = int.tryParse(_investingController.text);
    var sum = (fixedCosts ?? 0) + (freeSpendings ?? 0) + (savings ?? 0) + (investing ?? 0);
    
    if (sum != 100) {
      _statefullBuilderSetState(() {
        procentsLeft = sum;
        isProcentsInfoVisible = true;
      });
      return false;
    }
    isProcentsInfoVisible = false;
    return true;
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