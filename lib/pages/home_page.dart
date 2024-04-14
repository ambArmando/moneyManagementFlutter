// ignore_for_file: non_constant_identifier_names, prefer_final_fields
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_management/components/my_list_tile.dart';
import 'package:money_management/components/my_popup.dart';
import 'package:money_management/database/expense_database.dart';
import 'package:money_management/enums/buget_categories_enum.dart';
import 'package:money_management/models/budget.dart';
import 'package:money_management/models/category.dart';
import 'package:money_management/models/expense.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int? selectedCategoryIndex;
  String displayedValue = "";
  bool isLoading = true;
  late String totalDaySpendings;
  late Budget? setBudget;
  ExpenseDatabase localDb = ExpenseDatabase();
  List<Expense> currentDayExpenses = [];
  List<Expense> currentMonthExpenses = [];
  Map<BugetEnum, double> _expenseCategoryTotalsMap = {};
  TextEditingController spendedValueController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Category> queryDefaultCategories = [];

  @override
  void initState() {
    super.initState();
    totalDaySpendings = "0";
    LoadExpenses();
  }

  void LoadExpenses() async {
    var startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    var endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(const Duration(days: 1));
    setBudget = await localDb.getBuget(DateTime.now().month, DateTime.now().year);
    queryDefaultCategories = await localDb.getCategories();
    currentMonthExpenses = await localDb.getExpensesBetweenDates(startDate, endDate);
    currentDayExpenses = currentMonthExpenses.where((element) => element.date.day == DateTime.now().day && element.date.month == DateTime.now().month && element.date.year == DateTime.now().year).toList();
    CalculateCategoryTotals();
    totalDaySpendings = CalculateCurrentDaySpendingsTotal();
    setState((){
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Visibility(
        visible: true,
        child: TextButton(
          onPressed: () => {localDb.deleteBudget()},
          child: const Text("Delete data")
        ),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Spendings:"),
                    Text(DateFormat('dd.MM.yyyy').format(DateTime.now()))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    totalDaySpendings ?? "0",
                    style:
                      const TextStyle(
                        fontSize: 28
                      ),
                    ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 14, left: 5),
                  child: Text(displayedValue,
                    style: const TextStyle(
                      fontSize: 16
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 60,
              child: Center(
                child: ListView.builder(
                  itemCount: localDb.defaultCategorys.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) => GestureDetector(
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        color: index == selectedCategoryIndex ? Colors.grey[300] : GetColorForCategory(localDb.defaultCategorys[index].bugetCategory),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 0,
                            right: 2,
                            child: Visibility(
                              visible: (setBudget?.value ?? 0) > 0 && (IsBudgetAboveLimit(localDb.defaultCategorys[index])),
                              child: Icon(Icons.warning_amber_rounded, color: Colors.red[600], size: 22,))
                          ),
                          Positioned(
                            top: 10,
                            child: Image.asset("assets/${localDb.defaultCategorys.map((category) => category.name.name.toLowerCase()).toList()[index]}.png", width: 26.0, height: 26.0,)),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 3.0, left: 2, right: 2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(queryDefaultCategories.map((e) => e.name.name).toList()[index],
                                  maxLines: 1,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                  )
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 350,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: currentDayExpenses.length,
                itemBuilder: (context, int index) { 
                  Expense individualExpense = currentDayExpenses[index];
                  return MyListTile(
                    expense: individualExpense,
                    onEditPressed: (context) => {EditExpense(index)},
                    onDeletePressed: (context) => {DeleteExpense(index)},
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: ElevatedButton(onPressed: () => {DisplayValue("1")},
                          style: ElevatedButton.styleFrom(
                          elevation: 1,
                          shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                        ), child: const Text("1", style: TextStyle(
                          ),
                        ),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4.0),
                        child: ElevatedButton(onPressed: () => {DisplayValue("2")},
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                        ), child: const Text("2"),),
                      )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: ElevatedButton(onPressed: () => {DisplayValue("3")},
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                        ), child: const Text("3"),),
                      ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: ElevatedButton(onPressed: () => {DisplayValue("4")}, 
                        style: ElevatedButton.styleFrom(
                            elevation: 1,
                            shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                          ), child: const Text("4"),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4.0),
                        child: ElevatedButton(onPressed: () => {DisplayValue("5")}, 
                        style: ElevatedButton.styleFrom(
                            elevation: 1,
                            shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                          ), child: const Text("5"),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: ElevatedButton(onPressed: () => {DisplayValue("6")}, 
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                        ), child: const Text("6"),),
                      ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: ElevatedButton(onPressed: () => {DisplayValue("7")},
                        style: ElevatedButton.styleFrom(
                            elevation: 1,
                            shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                          ), child: const Text("7"),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4.0),
                        child: ElevatedButton(onPressed: () => {DisplayValue("8")}, style: ElevatedButton.styleFrom(
                            elevation: 1,
                            shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                          ), child: const Text("8"),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: ElevatedButton(onPressed: () => {DisplayValue("9")}, style: ElevatedButton.styleFrom(
                            elevation: 1,
                            shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                          ), child: const Text("9"),),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: ElevatedButton(onPressed: () {NewExpenseFromPopup(context);}, style: ElevatedButton.styleFrom(
                          elevation: 1,
                          shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                        ), child: const Icon(Icons.add_comment),),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4.0),
                        child: ElevatedButton(onPressed: () => {DisplayValue("0")}, 
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                        ), child: const Text("0")),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: ElevatedButton(onPressed: () => {RemoveValue()},
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))
                        ), child: const Icon(Icons.backspace_outlined),),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 125,
                      child: ElevatedButton(onPressed: () => {AddNewExpense()}, style: ElevatedButton.styleFrom(
                        elevation: 1,
                        shape: const ContinuousRectangleBorder(side: BorderSide(color: Colors.grey))   
                      ), child: const Icon(Icons.add),),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  bool IsBudgetAboveLimit(Category category) {
    if (_expenseCategoryTotalsMap.containsKey(category.bugetCategory)) { 
      return _expenseCategoryTotalsMap[category.bugetCategory]! > CalculateMaxBudget(category.bugetCategory);
    }
    // if (store.isBudgetCategoryValueAboveLimitMap.containsKey(category.bugetCategory) && _expenseCategoryTotalsMap.containsKey(category.bugetCategory)) {
    //   return store.isBudgetCategoryValueAboveLimitMap[category.bugetCategory] ?? false;
    // }
    return false;
  }

  void NewExpenseFromPopup(BuildContext context) {
    var popup = MyPopup(
      title: "New expense",
      localDb: localDb,
    );
    showDialog (
      context: context,
      builder: (context) => popup
    ).then((value) {
      if (popup.getExpense != null && popup.getExpense!.date.day == DateTime.now().day && popup.getExpense!.date.month == DateTime.now().month && popup.getExpense!.date.year == DateTime.now().year) {
        currentDayExpenses.add(popup.getExpense!);
        _expenseCategoryTotalsMap[popup.getExpense!.category.value!.bugetCategory] = _expenseCategoryTotalsMap[popup.getExpense!.category.value!.bugetCategory]! + popup.getExpense!.spendedValue;
        displayedValue = "";
        spendedValueController.clear();
        noteController.clear();
        setState(() {
          totalDaySpendings = CalculateCurrentDaySpendingsTotal();
        });
      }
      if (popup.getExpense != null) {
        currentMonthExpenses.add(popup.getExpense!);
      }
    });
  }

  AddNewExpense() {
    if (displayedValue.isEmpty) {
      return;
    }
    var now = DateTime.now();
    selectedCategoryIndex ??= 0;
    Expense expense = Expense(
      spendedValue: double.parse(displayedValue),
      category: queryDefaultCategories[selectedCategoryIndex!],
      date: DateTime(now.year, now.month, now.day),
      note: ""
    );
    localDb.createNewExpense(expense);
    currentDayExpenses.add(expense);
    currentMonthExpenses.add(expense);
    if (_expenseCategoryTotalsMap.containsKey(expense.category.value!.bugetCategory)) {
      _expenseCategoryTotalsMap[expense.category.value!.bugetCategory] = _expenseCategoryTotalsMap[expense.category.value!.bugetCategory]! + expense.spendedValue;
    }
    else
    {
      _expenseCategoryTotalsMap[expense.category.value!.bugetCategory] = expense.spendedValue;
    }
    displayedValue = "";
    setState(() {
      totalDaySpendings = CalculateCurrentDaySpendingsTotal();
    });
    _scrollController.animateTo(
      _scrollController.position.viewportDimension,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
   );
  }

  EditExpense(int index) {
    _expenseCategoryTotalsMap[currentDayExpenses[index].category.value!.bugetCategory] = _expenseCategoryTotalsMap[currentDayExpenses[index].category.value!.bugetCategory]! - currentDayExpenses[index].spendedValue;
    var popup = MyPopup(title: "Edit expense", localDb: localDb, expense: currentDayExpenses[index],);
    showDialog (context: context, builder: (context) => popup)
    .then((value) {
      if (popup.getExpense!.date.day != DateTime.now().day && popup.getExpense!.date.month != DateTime.now().month && popup.getExpense!.date.year != DateTime.now().year) {
        currentMonthExpenses.remove(currentDayExpenses[index]);
        currentDayExpenses.removeAt(index);
      }  
      _expenseCategoryTotalsMap[popup.getExpense!.category.value!.bugetCategory] = _expenseCategoryTotalsMap[popup.getExpense!.category.value!.bugetCategory]! + popup.getExpense!.spendedValue;
      setState(() {
        totalDaySpendings = CalculateCurrentDaySpendingsTotal();
      });
    spendedValueController.clear();
    noteController.clear();
    });
  }

  DeleteExpense(int index) {
    var deletedExpense = currentDayExpenses[index];
    localDb.deleteExpense(deletedExpense.id);
    currentMonthExpenses.remove(deletedExpense);
    currentDayExpenses.removeAt(index);
    _expenseCategoryTotalsMap[deletedExpense.category.value!.bugetCategory] = _expenseCategoryTotalsMap[deletedExpense.category.value!.bugetCategory]! - deletedExpense.spendedValue;
    setState(() {
      totalDaySpendings = CalculateCurrentDaySpendingsTotal();
    });
  }

  CalculateCategoryTotals() {
    if (currentMonthExpenses.isEmpty) {
      for (var budget in BugetEnum.values) {
        _expenseCategoryTotalsMap[budget] = 0;
      }
    }

    for (var expense in currentMonthExpenses) {
      var bugetCategory = expense.category.value!.bugetCategory;
      if (!_expenseCategoryTotalsMap.containsKey(bugetCategory)) {
        _expenseCategoryTotalsMap[bugetCategory] = expense.spendedValue;
      }
      else 
      {
        _expenseCategoryTotalsMap[bugetCategory] = _expenseCategoryTotalsMap[bugetCategory]! + expense.spendedValue;
      }
    }
  }

  String CalculateCurrentDaySpendingsTotal() {
    return currentDayExpenses.isNotEmpty ? currentDayExpenses.map((_) => _.spendedValue).reduce((value, element) => value + element).toString() : "0";
  }

  double CalculateMaxBudget(BugetEnum bugetEnum) {
    return setBudget == null ? 0 : (setBudget!.value * GetPercentage(bugetEnum)) / 100;
  }

  int GetPercentage(BugetEnum bugetEnum) {
    switch(bugetEnum){
      case BugetEnum.fixedCosts:
        return setBudget!.fixedCosts!;
      case BugetEnum.freeSpendings:
        return setBudget!.freeSpendings!;
      case BugetEnum.savings:
        return setBudget!.savings!;
      case BugetEnum.investing:
        return setBudget!.investing!;
    }
  }

  DisplayValue(String value) {
    if (displayedValue.length >= 5) {
      return;
    }
    setState(() {
      displayedValue += value;
    });
  }

  RemoveValue() {
    if (displayedValue.isEmpty) return;
    setState(() {
      displayedValue = displayedValue.substring(0, displayedValue.length - 1);
    });
  }

  Color GetColorForCategory(BugetEnum bugetEnum) {
    switch(bugetEnum) {
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    noteController.dispose();
    spendedValueController.dispose();
  }  
}