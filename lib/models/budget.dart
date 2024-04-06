import 'package:isar/isar.dart';

part 'budget.g.dart';

@Collection()
class Budget {
  Id id = Isar.autoIncrement;
  
  double value;

  int month;

  int year;

  Budget({
    required this.value,
    required this.month,
    required this.year,
  });
}