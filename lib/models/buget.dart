import 'package:isar/isar.dart';

part 'buget.g.dart';

@Collection()
class Buget {
  Id id = Isar.autoIncrement;
  
  double value;

  int month;

  int year;

  Buget({
    required this.value,
    required this.month,
    required this.year,
  });
}