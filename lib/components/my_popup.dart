
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_management/database/expense_database.dart';

import '../enums/category_enum.dart';
import '../models/expense.dart';

class MyPopup extends StatefulWidget {
  String title;
  ExpenseDatabase localDb;
  TextEditingController spendedValueController;
  TextEditingController noteController;
  String totalDaySpendings;
  Expense? expense;
  
  MyPopup({
    super.key,
    required this.title,
    required this.localDb,
    required this.spendedValueController,
    required this.noteController,
    required this.totalDaySpendings,
    this.expense,
  });

  Expense? get getExpense => expense;
  String? get getTotalDaySpendings => totalDaySpendings;
  
  @override
  State<MyPopup> createState() => MyPopupState();
}

class MyPopupState extends State<MyPopup>{
  late String _title;
  late String _totalDaySpendings;
  late TextEditingController _spendedValueController;
  late TextEditingController _noteController;
  late ExpenseDatabase _localDb;
  DateTime? selectedDate = DateTime.now();
  CategoryEnum? selectedCategory;
  Expense? _expense;
  
  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _spendedValueController = widget.spendedValueController;
    _noteController = widget.noteController;
    _localDb = widget.localDb;
    _totalDaySpendings = widget.totalDaySpendings;
    _expense = widget.expense;

    if (widget.expense != null) {
      _spendedValueController.text = widget.expense!.spendedValue.toString();
      _noteController.text = widget.expense!.note.toString();
      selectedCategory = widget.expense!.category;
      selectedDate = widget.expense!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            title: Text(_title),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) { 
                return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    controller: _spendedValueController,
                    decoration: const InputDecoration(hintText: "Value"),
                  ),
                  const SizedBox(height: 15),
                  DropdownButton<CategoryEnum>(
                    hint: const Text("Select category"),
                    isExpanded: true,
                    value: selectedCategory,
                    items:  _localDb.defaultCategorys.map((category) {
                      return DropdownMenuItem(
                        value: category.name,
                        child: Text(category.name.toString().split(".").last));
                    }).toList(),
                    onChanged: (CategoryEnum? newSelectedCategory) {
                      setState(() {
                      selectedCategory = newSelectedCategory!;
                    });
                    },
                  ),
                  TextField(
                    maxLength: 40,
                    controller: _noteController,
                    decoration: const InputDecoration(hintText: "Note"),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 20,
                    child: Row(
                      children: [                       
                        ElevatedButton(onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        }, child: const Text("Pick a date")),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Text(selectedDate == null ? DateFormat('dd MMMM yyyy').format(DateTime.now()) : DateFormat('dd MMMM yyyy').format(selectedDate!))),
                        ),
                      ],
                    ),
                  )
                ],
                );
              },
            ),
            actions: [
              _saveButton(),
              _cancelButton(),
            ],
          );
  }

  Widget _cancelButton() {
    return MaterialButton(
      onPressed: (){
        Navigator.pop(context);
        _spendedValueController.clear();
        _noteController.clear();
        selectedCategory = null;
        selectedDate = DateTime.now();
      },
      child: const Text("Cancel"),
    );
  }

  Widget _saveButton() {
    return MaterialButton(
      onPressed: () async {
        if (widget.expense == null && _spendedValueController.text.isNotEmpty && selectedCategory != null)
        {
          //create new expense
          Expense newExpense = Expense(
            spendedValue: double.parse(_spendedValueController.text),
            category: selectedCategory!, 
            date: selectedDate!, 
            note: _noteController.text,
          );

          widget.expense = newExpense;
          widget.totalDaySpendings = (double.parse(_totalDaySpendings) + newExpense.spendedValue).toString();
          // _scrollController.animateTo(
          //     _scrollController.position.maxScrollExtent,
          //     curve: Curves.easeOut,
          //     duration: const Duration(milliseconds: 500),
          // );
          //save to db
          Navigator.pop(context);
          await _localDb.createNewExpense(newExpense);
        } else if (widget.expense != null) {
          widget.expense!.spendedValue = double.parse(_spendedValueController.text);
          widget.expense!.category = selectedCategory!;
          widget.expense!.note = _noteController.text;
          widget.expense!.date = selectedDate!;
          Navigator.pop(context);
          await _localDb.updateExpense(widget.expense!);
        }
      },
      child: const Text("Save"),
    );
  }
  
}