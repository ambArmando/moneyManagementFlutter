// ignore_for_file: non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_management/components/my_list_tile.dart';
import 'package:money_management/components/my_popup.dart';
import 'package:money_management/database/expense_database.dart';
import 'package:money_management/models/expense.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int? selectedCategoryIndex;
  ExpenseDatabase localDb = ExpenseDatabase();
  List<Expense> fetchedExpenses = [];
  TextEditingController spendedValueController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String displayedValue = "";
  String? totalDaySpendings;
  bool isLoading = true;

 //figure a way to call the current day expenses only when the app is opened for the first time
  @override
  void initState() {
    super.initState();
    totalDaySpendings = "0";
    LoadExpenses();
  }

  void LoadExpenses() async {
    var expenses = await localDb.getCurrentDayExpenses();
    totalDaySpendings = expenses.isNotEmpty ? expenses.map((_) => _.spendedValue).reduce((value, element) => value + element).toString() : "0";
    setState((){
      fetchedExpenses = expenses;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              child: ListView.builder(
                itemCount: localDb.defaultCategorys.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, int index) => GestureDetector(
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 9),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: index == selectedCategoryIndex ? Colors.deepOrange[500] : Colors.grey[200],
                      
                    ),
                    child: Column(
                      children: [
                        Image.asset("assets/${localDb.defaultCategorys.map((category) => category.name.toString().split(".").last).toList()[index]}.png", width: 26.0, height: 26.0,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(localDb.defaultCategorys.map((category) => category.name.toString().split(".").last).toList()[index],
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.visible,
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
          Container(
            height: 280,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: fetchedExpenses.length,
              itemBuilder: (context, int index) { 
                Expense individualExpense = fetchedExpenses[index];
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
          fetchedExpenses.add(popup.getExpense!);
          totalDaySpendings = CurrentDaySpendings();
        });
      }
      spendedValueController.clear();
      noteController.clear();
    });
  }

  DeleteExpense(int index) {
    var deletedExpenseId = fetchedExpenses[index].id;
    localDb.deleteExpense(deletedExpenseId);
    setState(() {
      fetchedExpenses.removeAt(index);
      totalDaySpendings = CurrentDaySpendings();
    });
  }

  EditExpense(int index) {
    var popup = MyPopup(title: "Edit expense", localDb: localDb, expense: fetchedExpenses[index],);
    showDialog (context: context, builder: (context) => popup)
    .then((value) {
      (popup.getExpense!.date.day == DateTime.now().day && popup.getExpense!.date.month == DateTime.now().month && popup.getExpense!.date.year == DateTime.now().year) ? fetchedExpenses[index] = popup.getExpense! : fetchedExpenses.removeAt(index);
      var updatedList = fetchedExpenses;
      setState(() {
        fetchedExpenses = updatedList;
        totalDaySpendings = CurrentDaySpendings();
      });
    spendedValueController.clear();
    noteController.clear();
    });
  }

  String CurrentDaySpendings() {
    if (fetchedExpenses.isNotEmpty) {
      return totalDaySpendings = fetchedExpenses.map((_) => _.spendedValue).reduce((value, element) => value + element).toString();
    }
    return '0';
  }

  AddNewExpense() {
    if (displayedValue.isEmpty) return;
    var now = DateTime.now();
    selectedCategoryIndex ??= 0;
    Expense expense = Expense(spendedValue: double.parse(displayedValue), category: localDb.defaultCategorys[selectedCategoryIndex!].name, date: DateTime(now.year, now.month, now.day), note: "");
    localDb.createNewExpense(expense);
    setState(() {
      fetchedExpenses.add(expense);
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