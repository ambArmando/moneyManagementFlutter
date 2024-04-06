// ignore_for_file: non_constant_identifier_names, prefer_final_fields
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_management/components/my_list_tile.dart';
import 'package:money_management/components/my_popup.dart';
import 'package:money_management/components/store.dart';
import 'package:money_management/database/expense_database.dart';
import 'package:money_management/enums/buget_categories_enum.dart';
import 'package:money_management/models/budget.dart';
import 'package:money_management/models/category.dart';
import 'package:money_management/models/expense.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int? selectedCategoryIndex;
  ExpenseDatabase localDb = ExpenseDatabase();
  List<Expense> currentDayExpenses = [];
  List<Expense> monthExpenses = [];
  TextEditingController spendedValueController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String displayedValue = "";
  String? totalDaySpendings;
  bool isLoading = true;
  late Budget? setBudget;
  Map<BugetEnum, double> _categoriesTotal = {
    BugetEnum.fixedCosts : 0,
    BugetEnum.savings : 0,
    BugetEnum.investing : 0,
    BugetEnum.freeSpendings : 0,
  };
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(const Duration(days: 1));

 //figure a way to call the current day expenses only when the app is opened for the first time
  @override
  void initState() {
    super.initState();
    totalDaySpendings = "0";
    LoadExpenses();
  }

  void LoadExpenses() async {
    //var expenses = await localDb.getCurrentDayExpenses();
    monthExpenses = await localDb.getExpensesBetweenDates(startDate, endDate);
    var expenses = monthExpenses.where((element) => element.date.day == DateTime.now().day && element.date.month == DateTime.now().month && element.date.year == DateTime.now().year).toList();
    setBudget = await localDb.getBuget(DateTime.now().month, DateTime.now().year);
    BuildCategoriesTotal();
    totalDaySpendings = expenses.isNotEmpty ? expenses.map((_) => _.spendedValue).reduce((value, element) => value + element).toString() : "0";
    setState((){
      currentDayExpenses = expenses;
      isLoading = false;
    });
  }

  BuildCategoriesTotal() {
    CategoriesTotalReset();
    for (var expense in monthExpenses) {
      _categoriesTotal[expense.category.value!.bugetCategory] = _categoriesTotal[expense.category.value!.bugetCategory]! + expense.spendedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: TextButton(
        onPressed: () => {localDb.deleteAllData()},
        child: const Text("Delete data")
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : Column(
        children: [
          const SizedBox(height: 35),
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
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: Center(
              child: Consumer<Store>(
                builder: (context, store, _)
                {
                  return ListView.builder(
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
                                visible: (setBudget?.value ?? 0) > 0 && (isBudgetAboveLimit(store, localDb.defaultCategorys[index]) || isBudgetAboveLimitHomePage(localDb.defaultCategorys[index])),
                                child: Icon(Icons.warning_amber_rounded, color: Colors.red[600], size: 22,))
                            ),
                            Positioned(
                              top: 10,
                              child: Image.asset("assets/${localDb.defaultCategorys.map((category) => category.name.name.toLowerCase()).toList()[index]}.png", width: 26.0, height: 26.0,)),
                            Positioned(
                              bottom: 3,
                              child: Text(localDb.defaultCategorys.map((e) => e.name.name).toList()[index],
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 12,
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
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
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
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => {DisplayValue("1")},
                    style: ElevatedButton.styleFrom(
                    elevation: 1,
                  ), child: const Text("1", style: TextStyle(
                      color: Colors.black,
                    ),
                  ),),
                  ElevatedButton(onPressed: () => {DisplayValue("2")}, child: const Text("2")),
                  ElevatedButton(onPressed: () => {DisplayValue("3")}, child: const Text("3"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => {DisplayValue("4")}, child: const Text("4")),
                  ElevatedButton(onPressed: () => {DisplayValue("5")}, child: const Text("5")),
                  ElevatedButton(onPressed: () => {DisplayValue("6")}, child: const Text("6"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => {DisplayValue("7")}, child: const Text("7")),
                  ElevatedButton(onPressed: () => {DisplayValue("8")}, child: const Text("8")),
                  ElevatedButton(onPressed: () => {DisplayValue("9")}, child: const Text("9"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {NewExpenseFromPopup(context);}, style: ElevatedButton.styleFrom(
                    elevation: 1,
                  ), child: const Icon(Icons.add_comment),),
                  ElevatedButton(onPressed: () => {DisplayValue("0")}, child: const Text("0")),
                  ElevatedButton(onPressed: () => {RemoveValue()}, child: const Icon(Icons.backspace_outlined)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(onPressed: () => {AddNewExpense()}, style: ElevatedButton.styleFrom(
                      elevation: 1,
                                  
                    ), child: const Icon(Icons.add),),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  bool isBudgetAboveLimit(Store store, Category category) {
    if (store.isBudgetCategoryValueAboveLimitMap.containsKey(category.bugetCategory)) {
      return store.isBudgetCategoryValueAboveLimitMap[category.bugetCategory] ?? false;
    }
    return false;
  }

  bool isBudgetAboveLimitHomePage(Category category) {
    print("category = ${category.name}");
    print("${category.bugetCategory} ${_categoriesTotal[category.bugetCategory]}");
    print("${GetMaxBudget(category.bugetCategory)}");
    return _categoriesTotal[category.bugetCategory]! > GetMaxBudget(category.bugetCategory);
  }

  CategoriesTotalReset () {
    _categoriesTotal = {
      BugetEnum.fixedCosts : 0,
      BugetEnum.savings : 0,
      BugetEnum.investing : 0,
      BugetEnum.freeSpendings : 0,
    };
  } 

  double GetMaxBudget(BugetEnum bugetEnum) {
    if (setBudget == null) {
      return 0;
    }
    var percentage = GetPercentage(bugetEnum);

    return (setBudget!.value * percentage) / 100;
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
        setState(() {
          currentDayExpenses.add(popup.getExpense!);
          totalDaySpendings = CurrentDaySpendings();
        });
      }
      spendedValueController.clear();
      noteController.clear();
    });
  }

  DeleteExpense(int index) {
    var deletedExpenseId = currentDayExpenses[index].id;
    localDb.deleteExpense(deletedExpenseId);
    setState(() {
      monthExpenses.remove(currentDayExpenses[index]);
      currentDayExpenses.removeAt(index);
      BuildCategoriesTotal();
      totalDaySpendings = CurrentDaySpendings();
    });
  }

  EditExpense(int index) {
    var popup = MyPopup(title: "Edit expense", localDb: localDb, expense: currentDayExpenses[index],);
    showDialog (context: context, builder: (context) => popup)
    .then((value) {
      (popup.getExpense!.date.day == DateTime.now().day && popup.getExpense!.date.month == DateTime.now().month && popup.getExpense!.date.year == DateTime.now().year) ? currentDayExpenses[index] = popup.getExpense! : currentDayExpenses.removeAt(index);
      var updatedList = currentDayExpenses;
      setState(() {
        currentDayExpenses = updatedList;
        BuildCategoriesTotal();
        totalDaySpendings = CurrentDaySpendings();
      });
    spendedValueController.clear();
    noteController.clear();
    });
  }

  String CurrentDaySpendings() {
    if (currentDayExpenses.isNotEmpty) {
      return totalDaySpendings = currentDayExpenses.map((_) => _.spendedValue).reduce((value, element) => value + element).toString();
    }
    return '0';
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

  AddNewExpense() {
    if (displayedValue.isEmpty) return;
    var now = DateTime.now();
    selectedCategoryIndex ??= 0;
    Expense expense = Expense(
      spendedValue: double.parse(displayedValue),
      category: localDb.defaultCategorys[selectedCategoryIndex!],
      date: DateTime(now.year, now.month, now.day),
      note: ""
    );
    localDb.createNewExpense(expense);
    setState(() {
      currentDayExpenses.add(expense);
      monthExpenses.add(expense);
      BuildCategoriesTotal();
      displayedValue = "";
      totalDaySpendings = CurrentDaySpendings();
    });
    _scrollController.animateTo(
      _scrollController.position.viewportDimension,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
   );
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    noteController.dispose();
    spendedValueController.dispose();
  }  
}