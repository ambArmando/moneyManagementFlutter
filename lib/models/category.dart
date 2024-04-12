
import 'package:isar/isar.dart';
import 'package:money_management/enums/buget_categories_enum.dart';
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;

  Category({
    required this.name,
    required this.bugetCategory,
    this.imgPath,
  });

}