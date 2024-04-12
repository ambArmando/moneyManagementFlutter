// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/database/expense_database.dart';
import 'package:money_management/models/category.dart';
import '../models/expense.dart';

class MyPopup extends StatefulWidget {
  String title;
  ExpenseDatabase localDb;
  Expense? expense;
  
  MyPopup({
    super.key,
    required this.title,
    required this.localDb,
    this.expense,
  });

  Expense? get getExpense => expense;
  
  @override
  State<MyPopup> createState() => MyPopupState();
}

class MyPopupState extends State<MyPopup>{
  late String _title;
  final TextEditingController _spendedValueController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late ExpenseDatabase _localDb;
  DateTime? selectedDate = DateTime.now();
  Category? selectedCategory;
  List<Category> _defaultCategories = [];
  String? errorTextValue;
  
  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _localDb = widget.localDb;
    LoadDefaultCategories();
    if (widget.expense != null) {
      _spendedValueController.text = widget.expense!.spendedValue.toString();
      _noteController.text = widget.expense!.note.toString();
      selectedCategory = widget.expense!.category.value;
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
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    controller: _spendedValueController,
                    decoration: InputDecoration(
                      hintText: "Value",
                      errorText: errorTextValue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: selectedCategory == null ? Border.all(color: Colors.red) : null,
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: DropdownButton<Category>(
                        hint: const Text("Select category"),
                        isExpanded: true,
                        value: selectedCategory,
                        items: _defaultCategories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name.name));
                        }).toList(),
                        onChanged: (Category? newSelectedCategory) {
                          setState(() {
                          selectedCategory = newSelectedCategory;
                        });
                        },
                      ),
                    ),
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
                              selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
                            });
                          }
                        }, child: const Text("Pick a date")),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Text(selectedDate == null ? DateFormat('dd MMM yyyy').format(DateTime.now()) : DateFormat('dd MMM yyyy').format(selectedDate!))),
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
        
        if (_spendedValueController.text.isEmpty) {
          setState(() {
            errorTextValue = "Add a value!"; 
          });
          return;
        }

        if (widget.expense == null && _spendedValueController.text.isNotEmpty && selectedCategory != null)
        {
          Expense newExpense = Expense(
            spendedValue: double.parse(_spendedValueController.text), 
            category: selectedCategory,
            date: selectedDate!, 
            note: _noteController.text,
          );
          widget.expense = newExpense;
          Navigator.pop(context);
          _localDb.createNewExpense(newExpense);
        } else if (widget.expense != null && _spendedValueController.text.isNotEmpty && selectedCategory != null) {
          widget.expense!.spendedValue = double.parse(_spendedValueController.text);
          widget.expense!.category.value = selectedCategory!;
          widget.expense!.note = _noteController.text;
          widget.expense!.date = selectedDate!;
          Navigator.pop(context);
          _localDb.updateExpense(widget.expense!);
        }

        errorTextValue = null;
      },
      child: const Text("Save"),
    );
  }
  
  void LoadDefaultCategories() async{
    var query = await _localDb.getCategories();
    setState(() {
      _defaultCategories = query;
    });
  }
}