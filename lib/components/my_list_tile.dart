import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_management/models/expense.dart';

class MyListTile extends StatelessWidget {
  final Expense expense;
  final Function(BuildContext)? onEditPressed;
  final Function(BuildContext)? onDeletePressed;

  const MyListTile ({
      super.key,
      required this.expense,
      required this.onEditPressed,
      required this.onDeletePressed,
    }
  );

  @override
  Widget build(BuildContext context) {
      return Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onEditPressed,
              backgroundColor: const Color.fromARGB(255, 56, 140, 209),
              icon: Icons.edit,
              foregroundColor: Colors.grey[100],
            ),
            SlidableAction(
              onPressed: onDeletePressed,
              backgroundColor: const Color.fromARGB(255, 247, 70, 70),
              icon: Icons.delete,
              foregroundColor: Colors.grey[100],
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(expense.category.name),
              leading: Image.asset("assets/${expense.category.name}.png", width: 26.0, height: 26.0,),
              subtitle: Text(expense.note.toString()),
              trailing: SizedBox(
                width: 130,
                child: Row(
                  children: [
                    Expanded(child: Text(DateFormat('dd.MM').format(expense.date), style: const TextStyle(
                      fontSize: 12,
                    ),)),
                    Text("-${expense.spendedValue}", style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                    ),  
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 0.5, 
              color: Color.fromARGB(255, 192, 192, 192),
            )
          ],
        ),
      );
  }

}
