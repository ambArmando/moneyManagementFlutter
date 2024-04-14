// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBudgetCollection on Isar {
  IsarCollection<Budget> get budgets => this.collection();
}

const BudgetSchema = CollectionSchema(
  name: r'Budget',
  id: -3383598594604670326,
  properties: {
    r'fixedCosts': PropertySchema(
      id: 0,
      name: r'fixedCosts',
      type: IsarType.long,
    ),
    r'freeSpendings': PropertySchema(
      id: 1,
      name: r'freeSpendings',
      type: IsarType.long,
    ),
    r'investing': PropertySchema(
      id: 2,
      name: r'investing',
      type: IsarType.long,
    ),
    r'month': PropertySchema(
      id: 3,
      name: r'month',
      type: IsarType.long,
    ),
    r'savings': PropertySchema(
      id: 4,
      name: r'savings',
      type: IsarType.long,
    ),
    r'value': PropertySchema(
      id: 5,
      name: r'value',
      type: IsarType.double,
    ),
    r'year': PropertySchema(
      id: 6,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _budgetEstimateSize,
  serialize: _budgetSerialize,
  deserialize: _budgetDeserialize,
  deserializeProp: _budgetDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _budgetGetId,
  getLinks: _budgetGetLinks,
  attach: _budgetAttach,
  version: '3.1.0',
);

int _budgetEstimateSize(
  Budget object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _budgetSerialize(
  Budget object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.fixedCosts);
  writer.writeLong(offsets[1], object.freeSpendings);
  writer.writeLong(offsets[2], object.investing);
  writer.writeLong(offsets[3], object.month);
  writer.writeLong(offsets[4], object.savings);
  writer.writeDouble(offsets[5], object.value);
  writer.writeLong(offsets[6], object.year);
}

Budget _budgetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Budget(
    fixedCosts: reader.readLongOrNull(offsets[0]),
    freeSpendings: reader.readLongOrNull(offsets[1]),
    investing: reader.readLongOrNull(offsets[2]),
    month: reader.readLong(offsets[3]),
    savings: reader.readLongOrNull(offsets[4]),
    value: reader.readDouble(offsets[5]),
    year: reader.readLong(offsets[6]),
  );
  object.id = id;
  return object;
}

P _budgetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetGetId(Budget object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetGetLinks(Budget object) {
  return [];
}

void _budgetAttach(IsarCollection<dynamic> col, Id id, Budget object) {
  object.id = id;
}

extension BudgetQueryWhereSort on QueryBuilder<Budget, Budget, QWhere> {
  QueryBuilder<Budget, Budget, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetQueryWhere on QueryBuilder<Budget, Budget, QWhereClause> {
  QueryBuilder<Budget, Budget, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Budget, Budget, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterWhereClause> idBetween(
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

extension BudgetQueryFilter on QueryBuilder<Budget, Budget, QFilterCondition> {
  QueryBuilder<Budget, Budget, QAfterFilterCondition> fixedCostsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fixedCosts',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> fixedCostsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fixedCosts',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> fixedCostsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fixedCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> fixedCostsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fixedCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> fixedCostsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fixedCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> fixedCostsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fixedCosts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> freeSpendingsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'freeSpendings',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> freeSpendingsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'freeSpendings',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> freeSpendingsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'freeSpendings',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> freeSpendingsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'freeSpendings',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> freeSpendingsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'freeSpendings',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> freeSpendingsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'freeSpendings',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Budget, Budget, QAfterFilterCondition> investingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'investing',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> investingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'investing',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> investingEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'investing',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> investingGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'investing',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> investingLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'investing',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> investingBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'investing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> monthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> monthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> monthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> monthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'month',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> savingsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'savings',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> savingsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'savings',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> savingsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savings',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> savingsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'savings',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> savingsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'savings',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> savingsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'savings',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> yearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetQueryObject on QueryBuilder<Budget, Budget, QFilterCondition> {}

extension BudgetQueryLinks on QueryBuilder<Budget, Budget, QFilterCondition> {}

extension BudgetQuerySortBy on QueryBuilder<Budget, Budget, QSortBy> {
  QueryBuilder<Budget, Budget, QAfterSortBy> sortByFixedCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedCosts', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByFixedCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedCosts', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByFreeSpendings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freeSpendings', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByFreeSpendingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freeSpendings', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByInvesting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'investing', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByInvestingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'investing', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortBySavings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savings', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortBySavingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savings', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension BudgetQuerySortThenBy on QueryBuilder<Budget, Budget, QSortThenBy> {
  QueryBuilder<Budget, Budget, QAfterSortBy> thenByFixedCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedCosts', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByFixedCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedCosts', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByFreeSpendings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freeSpendings', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByFreeSpendingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freeSpendings', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByInvesting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'investing', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByInvestingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'investing', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenBySavings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savings', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenBySavingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savings', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension BudgetQueryWhereDistinct on QueryBuilder<Budget, Budget, QDistinct> {
  QueryBuilder<Budget, Budget, QDistinct> distinctByFixedCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fixedCosts');
    });
  }

  QueryBuilder<Budget, Budget, QDistinct> distinctByFreeSpendings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'freeSpendings');
    });
  }

  QueryBuilder<Budget, Budget, QDistinct> distinctByInvesting() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'investing');
    });
  }

  QueryBuilder<Budget, Budget, QDistinct> distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month');
    });
  }

  QueryBuilder<Budget, Budget, QDistinct> distinctBySavings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savings');
    });
  }

  QueryBuilder<Budget, Budget, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }

  QueryBuilder<Budget, Budget, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension BudgetQueryProperty on QueryBuilder<Budget, Budget, QQueryProperty> {
  QueryBuilder<Budget, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Budget, int?, QQueryOperations> fixedCostsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fixedCosts');
    });
  }

  QueryBuilder<Budget, int?, QQueryOperations> freeSpendingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'freeSpendings');
    });
  }

  QueryBuilder<Budget, int?, QQueryOperations> investingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'investing');
    });
  }

  QueryBuilder<Budget, int, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<Budget, int?, QQueryOperations> savingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savings');
    });
  }

  QueryBuilder<Budget, double, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }

  QueryBuilder<Budget, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
