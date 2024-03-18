
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
          )
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
            if (popup.getExpense != null) {
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
        child: const Icon(Icons.add),
      ),   
    );
  }

  // AlertDialog MyPopUp() {
  //   return AlertDialog(
  //           title: const Text("New expense"),
  //           content: StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) { 
  //               return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TextField(
  //                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //                   maxLength: 4,
  //                   keyboardType: TextInputType.number,
  //                   controller: spendedValueController,
  //                   decoration: const InputDecoration(hintText: "Value"),
  //                 ),
  //                 const SizedBox(height: 15),
  //                 DropdownButton<CategoryEnum>(
  //                   hint: const Text("Select category"),
  //                   isExpanded: true,
  //                   value: selectedCategory,
  //                   items:  localDb.defaultCategorys.map((category) {
  //                     return DropdownMenuItem(
  //                       value: category.name,
  //                       child: Text(category.name.toString().split(".").last));
  //                   }).toList(),
  //                   onChanged: (CategoryEnum? newSelectedCategory) {
  //                     setState(() {
  //                     selectedCategory = newSelectedCategory!;
  //                   });
  //                   },
  //                 ),
  //                 TextField(
  //                   maxLength: 40,
  //                   controller: noteController,
  //                   decoration: const InputDecoration(hintText: "Note"),
  //                 ),
  //                 const SizedBox(height: 15),
  //                 SizedBox(
  //                   height: 20,
  //                   child: Row(
  //                     children: [                       
  //                       ElevatedButton(onPressed: () async {
  //                         final DateTime? pickedDate = await showDatePicker(
  //                         context: context,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime(2000),
  //                         lastDate: DateTime(2101),
  //                         );
  //                         if (pickedDate != null) {
  //                           setState(() {
  //                             selectedDate = pickedDate;
  //                           });
  //                         }
  //                       }, child: const Text("Pick a date")),
  //                       Expanded(
  //                         child: Container(
  //                           margin: const EdgeInsets.only(left: 15),
  //                           child: Text(selectedDate == null ? DateFormat('dd MMMM yyyy').format(DateTime.now()) : DateFormat('dd MMMM yyyy').format(selectedDate!))),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //               );
  //             },
  //           ),
  //           actions: [
  //             _saveButton(),
  //             _cancelButton(),
  //           ],
  //         );
  // }

  // Widget _cancelButton() {
  //   return MaterialButton(
  //     onPressed: (){
  //       Navigator.pop(context);
  //       spendedValueController.clear();
  //       noteController.clear();
  //       selectedCategory = null;
  //       selectedDate = DateTime.now();
  //     },
  //     child: const Text("Cancel"),
  //   );
  // }

  // Widget _saveButton() {
  //   return MaterialButton(
  //     onPressed: () async {
  //       if (spendedValueController.text.isNotEmpty && selectedCategory != null)
  //       {
  //         //create new expense
  //         Expense newExpense = Expense(
  //           spendedValue: double.parse(spendedValueController.text),
  //           category: selectedCategory!, 
  //           date: selectedDate!, 
  //           note: noteController.text,
  //         );
  //         //update the UI
  //         var newTotalDaySpendings = (double.parse(totalDaySpendings!) + newExpense.spendedValue).toString();
  //         setState(() {
  //           fetchedExpenses.add(newExpense);
  //           totalDaySpendings = newTotalDaySpendings;
  //         });
  //         _scrollController.animateTo(
  //             _scrollController.position.maxScrollExtent,
  //             curve: Curves.easeOut,
  //             duration: const Duration(milliseconds: 500),
  //         );
  //         //save to db
  //         Navigator.pop(context);
  //         await localDb.createNewExpense(newExpense);
  //       }
  //     },
  //     child: const Text("Save"),
  //   );
  // }

  DeleteExpense(int index) {
    var deletedExpenseId = fetchedExpenses[index].id;
    localDb.deleteExpense(deletedExpenseId);
    var newTotalDaySpendings = (double.parse(totalDaySpendings!) - fetchedExpenses[index].spendedValue).toString();
    setState(() {
      fetchedExpenses.removeAt(index);
      totalDaySpendings = newTotalDaySpendings;
    });
  }

  EditExpense(int index) {
    var popup = MyPopup(title: "Edit expense", spendedValueController: spendedValueController, noteController: noteController, localDb: localDb, totalDaySpendings: totalDaySpendings!, expense: fetchedExpenses[index],);
    showDialog (context: context, builder: (context) => popup)
    .then((value) {
      setState(() {
        fetchedExpenses[index] = popup.getExpense!;
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
    return totalDaySpendings!;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    noteController.dispose();
    spendedValueController.dispose();
  }
  
}