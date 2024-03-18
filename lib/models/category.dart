import 'package:isar/isar.dart';
import '../enums/category_enum.dart';

part 'category.g.dart';

@Collection()
class Category {
  Id id = Isar.autoIncrement;
  
  @enumerated
  final CategoryEnum name;

  final String? imgPath;

  Category({
    required this.name,
    required this.imgPath,
  });
}