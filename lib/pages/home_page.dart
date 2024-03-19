
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
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
  int? selectedCategoryIndex = -1;
  ExpenseDatabase localDb = ExpenseDatabase();
  List<Expense> fetchedExpenses = [];
  TextEditingController spendedValueController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? totalDaySpendings;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SizedBox(height: 50),
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
                      print("selected category: ${localDb.defaultCategorys[selectedCategoryIndex!].name}");
                    });
                  },
                )
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 300,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: fetchedExpenses.length,
              itemBuilder: (context, int index) { 
                Expense individualExpense = fetchedExpenses[index];
                return MyListTile(
                  category: individualExpense.category,
                  note: individualExpense.note,
                  spendedValue: individualExpense.spendedValue,
                  onEditPressed: (context) => {EditExpense(index)},
                  onDeletePressed: (context) => {DeleteExpense(index)},
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: null, child: Text("1")),
              ElevatedButton(onPressed: null, child: Text("2")),
              ElevatedButton(onPressed: null, child: Text("3"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: null, child: Text("4")),
              ElevatedButton(onPressed: null, child: Text("5")),
              ElevatedButton(onPressed: null, child: Text("6"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: null, child: Text("7")),
              ElevatedButton(onPressed: null, child: Text("8")),
              ElevatedButton(onPressed: null, child: Text("9"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: null, child: Text(".")),
              ElevatedButton(onPressed: () => {}, child: Icon(Icons.add)),
              ElevatedButton(onPressed: null, child: Icon(Icons.backspace_outlined)),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var popup = MyPopup(
                title: "New expense",
                spendedValueController: spendedValueController,
                noteController: noteController,
                localDb: localDb,
                totalDaySpendings: totalDaySpendings!,
              );
          showDialog (
            context: context,
             builder: (context) => popup
          ).then((value) {
            if (popup.getExpense != null && popup.getExpense!.date.day == DateTime.now().day && popup.getExpense!.date.month == DateTime.now().month && popup.getExpense!.date.year == DateTime.now().year) {
              setState(() {
                fetchedExpenses.add(popup.getExpense!);
                totalDaySpendings = popup.getTotalDaySpendings;
              });
            }
            spendedValueController.clear();
            noteController.clear();
          });
        },
        elevation: 0,
        child: const Icon(Icons.more),
      ), 
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_sharp), label: "Statistics"),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Buget"),
        ],
      ),  
    );
  }

  DeleteExpense(int index) {
    var deletedExpenseId = fetchedExpenses[index].id;
    localDb.deleteExpense(deletedExpenseId);
    //var newTotalDaySpendings = (double.parse(totalDaySpendings!) - fetchedExpenses[index].spendedValue).toString();
    setState(() {
      fetchedExpenses.removeAt(index);
      totalDaySpendings = CurrentDaySpendings();
    });
  }

  EditExpense(int index) {
    var popup = MyPopup(title: "Edit expense", spendedValueController: spendedValueController, noteController: noteController, localDb: localDb, totalDaySpendings: totalDaySpendings!, expense: fetchedExpenses[index],);
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    noteController.dispose();
    spendedValueController.dispose();
  }
  
}