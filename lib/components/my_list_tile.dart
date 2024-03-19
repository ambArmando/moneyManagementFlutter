import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_management/enums/category_enum.dart';

class MyListTile extends StatelessWidget {
  final CategoryEnum category;
  final String? note;
  final double spendedValue;
  final Function(BuildContext)? onEditPressed;
  final Function(BuildContext)? onDeletePressed;

  const MyListTile ({
      super.key,
      required this.category,
      required this.note,
      required this.spendedValue,
      required this.onEditPressed,
      required this.onDeletePressed,
    }
  );

  @override
  Widget build(BuildContext context) {
      return Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onEditPressed,
              backgroundColor: Color.fromARGB(255, 56, 140, 209),
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
        child: ListTile(
          title: Text(category.name),
          leading: Image.asset("assets/${category.name}.png", width: 26.0, height: 26.0,),
          subtitle: Text(note.toString()),
          trailing: Text("-$spendedValue", style: const TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.w500
          ),),
          
        ),
      );
  }

}
