
import 'package:isar/isar.dart';
import 'package:money_management/enums/buget_categories_enum.dart';
import 'package:money_management/models/expense.dart';
import '../enums/category_enum.dart';

part 'category.g.dart';

@Collection()
class Category {
  Id id = Isar.autoIncrement;
  
  @enumerated
  final CategoryEnum name;
  
  @enumerated
  final BugetEnum bugetCategory;

  final String? imgPath;

  Category({
    required this.name,
    required this.bugetCategory,
    this.imgPath,
  });

}