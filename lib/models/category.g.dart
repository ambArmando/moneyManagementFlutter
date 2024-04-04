// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCategoryCollection on Isar {
  IsarCollection<Category> get categorys => this.collection();
}

const CategorySchema = CollectionSchema(
  name: r'Category',
  id: 5751694338128944171,
  properties: {
    r'bugetCategory': PropertySchema(
      id: 0,
      name: r'bugetCategory',
      type: IsarType.byte,
      enumMap: _CategorybugetCategoryEnumValueMap,
    ),
    r'imgPath': PropertySchema(
      id: 1,
      name: r'imgPath',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.byte,
      enumMap: _CategorynameEnumValueMap,
    )
  },
  estimateSize: _categoryEstimateSize,
  serialize: _categorySerialize,
  deserialize: _categoryDeserialize,
  deserializeProp: _categoryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _categoryGetId,
  getLinks: _categoryGetLinks,
  attach: _categoryAttach,
  version: '3.1.0',
);

int _categoryEstimateSize(
  Category object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.imgPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _categorySerialize(
  Category object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.bugetCategory.index);
  writer.writeString(offsets[1], object.imgPath);
  writer.writeByte(offsets[2], object.name.index);
}

Category _categoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Category(
    bugetCategory:
        _CategorybugetCategoryValueEnumMap[reader.readByteOrNull(offsets[0])] ??
            BugetEnum.fixedCosts,
    imgPath: reader.readStringOrNull(offsets[1]),
    name: _CategorynameValueEnumMap[reader.readByteOrNull(offsets[2])] ??
        CategoryEnum.Housing,
  );
  object.id = id;
  return object;
}

P _categoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_CategorybugetCategoryValueEnumMap[
              reader.readByteOrNull(offset)] ??
          BugetEnum.fixedCosts) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (_CategorynameValueEnumMap[reader.readByteOrNull(offset)] ??
          CategoryEnum.Housing) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CategorybugetCategoryEnumValueMap = {
  'fixedCosts': 0,
  'savings': 1,
  'investing': 2,
  'freeSpendings': 3,
};
const _CategorybugetCategoryValueEnumMap = {
  0: BugetEnum.fixedCosts,
  1: BugetEnum.savings,
  2: BugetEnum.investing,
  3: BugetEnum.freeSpendings,
};
const _CategorynameEnumValueMap = {
  'Housing': 0,
  'Utilities': 1,
  'Transportation': 2,
  'Groceries': 3,
  'EmergencyFund': 4,
  'ShortTermGoals': 5,
  'LongTermGoals': 6,
  'Education': 7,
  'StockMarket': 8,
  'Cryptocurrency': 9,
  'Travel': 10,
  'Hobbies': 11,
  'Gifts': 12,
  'Shopping': 13,
  'DiningOut': 14,
};
const _CategorynameValueEnumMap = {
  0: CategoryEnum.Housing,
  1: CategoryEnum.Utilities,
  2: CategoryEnum.Transportation,
  3: CategoryEnum.Groceries,
  4: CategoryEnum.EmergencyFund,
  5: CategoryEnum.ShortTermGoals,
  6: CategoryEnum.LongTermGoals,
  7: CategoryEnum.Education,
  8: CategoryEnum.StockMarket,
  9: CategoryEnum.Cryptocurrency,
  10: CategoryEnum.Travel,
  11: CategoryEnum.Hobbies,
  12: CategoryEnum.Gifts,
  13: CategoryEnum.Shopping,
  14: CategoryEnum.DiningOut,
};

Id _categoryGetId(Category object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _categoryGetLinks(Category object) {
  return [];
}

void _categoryAttach(IsarCollection<dynamic> col, Id id, Category object) {
  object.id = id;
}

extension CategoryQueryWhereSort on QueryBuilder<Category, Category, QWhere> {
  QueryBuilder<Category, Category, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategoryQueryWhere on QueryBuilder<Category, Category, QWhereClause> {
  QueryBuilder<Category, Category, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Category, Category, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CategoryQueryFilter
    on QueryBuilder<Category, Category, QFilterCondition> {
  QueryBuilder<Category, Category, QAfterFilterCondition> bugetCategoryEqualTo(
      BugetEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bugetCategory',
        value: value,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition>
      bugetCategoryGreaterThan(
    BugetEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bugetCategory',
        value: value,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> bugetCategoryLessThan(
    BugetEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bugetCategory',
        value: value,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> bugetCategoryBetween(
    BugetEnum lower,
    BugetEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bugetCategory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imgPath',
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imgPath',
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imgPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imgPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imgPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imgPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imgPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imgPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imgPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imgPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imgPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> imgPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imgPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameEqualTo(
      CategoryEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameGreaterThan(
    CategoryEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameLessThan(
    CategoryEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
      ));
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameBetween(
    CategoryEnum lower,
    CategoryEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CategoryQueryObject
    on QueryBuilder<Category, Category, QFilterCondition> {}

extension CategoryQueryLinks
    on QueryBuilder<Category, Category, QFilterCondition> {}

extension CategoryQuerySortBy on QueryBuilder<Category, Category, QSortBy> {
  QueryBuilder<Category, Category, QAfterSortBy> sortByBugetCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bugetCategory', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByBugetCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bugetCategory', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByImgPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imgPath', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByImgPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imgPath', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CategoryQuerySortThenBy
    on QueryBuilder<Category, Category, QSortThenBy> {
  QueryBuilder<Category, Category, QAfterSortBy> thenByBugetCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bugetCategory', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByBugetCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bugetCategory', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByImgPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imgPath', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByImgPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imgPath', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CategoryQueryWhereDistinct
    on QueryBuilder<Category, Category, QDistinct> {
  QueryBuilder<Category, Category, QDistinct> distinctByBugetCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bugetCategory');
    });
  }

  QueryBuilder<Category, Category, QDistinct> distinctByImgPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imgPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Category, Category, QDistinct> distinctByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name');
    });
  }
}

extension CategoryQueryProperty
    on QueryBuilder<Category, Category, QQueryProperty> {
  QueryBuilder<Category, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Category, BugetEnum, QQueryOperations> bugetCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bugetCategory');
    });
  }

  QueryBuilder<Category, String?, QQueryOperations> imgPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imgPath');
    });
  }

  QueryBuilder<Category, CategoryEnum, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
