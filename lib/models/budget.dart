import 'package:isar/isar.dart';

part 'budget.g.dart';

@Collection()
class Budget {
  Id id = Isar.autoIncrement;
  
  double value;

  int month;

  int year;

  int? fixedCosts;

  int? freeSpendings;

  int? savings;

  int? investing;

  Budget({
    required this.value,
    required this.month,
    required this.year,
    this.fixedCosts,
    this.freeSpendings,
    this.savings,
    this.investing,
  }) {
    fixedCosts = fixedCosts ?? 50;
    freeSpendings = freeSpendings ?? 35;
    savings = savings ?? 10;
    investing = investing ?? 5;
  }
}