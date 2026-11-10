// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransactionCollection on Isar {
  IsarCollection<Transaction> get transactions => this.collection();
}

const TransactionSchema = CollectionSchema(
  name: r'Transaction',
  id: 5320225499417954855,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'isRecurring': PropertySchema(
      id: 2,
      name: r'isRecurring',
      type: IsarType.bool,
    ),
    r'nextRecurrenceDate': PropertySchema(
      id: 3,
      name: r'nextRecurrenceDate',
      type: IsarType.dateTime,
    ),
    r'note': PropertySchema(
      id: 4,
      name: r'note',
      type: IsarType.string,
    ),
    r'parentRecurringId': PropertySchema(
      id: 5,
      name: r'parentRecurringId',
      type: IsarType.long,
    ),
    r'pocketId': PropertySchema(
      id: 6,
      name: r'pocketId',
      type: IsarType.long,
    ),
    r'recurrenceEndDate': PropertySchema(
      id: 7,
      name: r'recurrenceEndDate',
      type: IsarType.dateTime,
    ),
    r'recurrenceFrequency': PropertySchema(
      id: 8,
      name: r'recurrenceFrequency',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 10,
      name: r'type',
      type: IsarType.string,
      enumMap: _TransactiontypeEnumValueMap,
    )
  },
  estimateSize: _transactionEstimateSize,
  serialize: _transactionSerialize,
  deserialize: _transactionDeserialize,
  deserializeProp: _transactionDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isRecurring': IndexSchema(
      id: 1211429805563284888,
      name: r'isRecurring',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isRecurring',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'nextRecurrenceDate': IndexSchema(
      id: 6133252099153929562,
      name: r'nextRecurrenceDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nextRecurrenceDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'category': LinkSchema(
      id: 9039453146683828404,
      name: r'category',
      target: r'Category',
      single: true,
    ),
    r'account': LinkSchema(
      id: -8467990729867616553,
      name: r'account',
      target: r'Account',
      single: true,
    ),
    r'toAccount': LinkSchema(
      id: 4183772830040559160,
      name: r'toAccount',
      target: r'Account',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _transactionGetId,
  getLinks: _transactionGetLinks,
  attach: _transactionAttach,
  version: '3.1.0+1',
);

int _transactionEstimateSize(
  Transaction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recurrenceFrequency;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _transactionSerialize(
  Transaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeBool(offsets[2], object.isRecurring);
  writer.writeDateTime(offsets[3], object.nextRecurrenceDate);
  writer.writeString(offsets[4], object.note);
  writer.writeLong(offsets[5], object.parentRecurringId);
  writer.writeLong(offsets[6], object.pocketId);
  writer.writeDateTime(offsets[7], object.recurrenceEndDate);
  writer.writeString(offsets[8], object.recurrenceFrequency);
  writer.writeString(offsets[9], object.title);
  writer.writeString(offsets[10], object.type.name);
}

Transaction _transactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Transaction();
  object.amount = reader.readDouble(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.id = id;
  object.isRecurring = reader.readBool(offsets[2]);
  object.nextRecurrenceDate = reader.readDateTimeOrNull(offsets[3]);
  object.note = reader.readStringOrNull(offsets[4]);
  object.parentRecurringId = reader.readLongOrNull(offsets[5]);
  object.pocketId = reader.readLongOrNull(offsets[6]);
  object.recurrenceEndDate = reader.readDateTimeOrNull(offsets[7]);
  object.recurrenceFrequency = reader.readStringOrNull(offsets[8]);
  object.title = reader.readString(offsets[9]);
  object.type =
      _TransactiontypeValueEnumMap[reader.readStringOrNull(offsets[10])] ??
          TransactionType.expense;
  return object;
}

P _transactionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (_TransactiontypeValueEnumMap[reader.readStringOrNull(offset)] ??
          TransactionType.expense) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TransactiontypeEnumValueMap = {
  r'expense': r'expense',
  r'income': r'income',
  r'transfer': r'transfer',
};
const _TransactiontypeValueEnumMap = {
  r'expense': TransactionType.expense,
  r'income': TransactionType.income,
  r'transfer': TransactionType.transfer,
};

Id _transactionGetId(Transaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transactionGetLinks(Transaction object) {
  return [object.category, object.account, object.toAccount];
}

void _transactionAttach(
    IsarCollection<dynamic> col, Id id, Transaction object) {
  object.id = id;
  object.category.attach(col, col.isar.collection<Category>(), r'category', id);
  object.account.attach(col, col.isar.collection<Account>(), r'account', id);
  object.toAccount
      .attach(col, col.isar.collection<Account>(), r'toAccount', id);
}

extension TransactionQueryWhereSort
    on QueryBuilder<Transaction, Transaction, QWhere> {
  QueryBuilder<Transaction, Transaction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhere> anyIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isRecurring'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhere> anyNextRecurrenceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'nextRecurrenceDate'),
      );
    });
  }
}

extension TransactionQueryWhere
    on QueryBuilder<Transaction, Transaction, QWhereClause> {
  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idBetween(
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

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> isRecurringEqualTo(
      bool isRecurring) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isRecurring',
        value: [isRecurring],
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause>
      isRecurringNotEqualTo(bool isRecurring) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [],
              upper: [isRecurring],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [isRecurring],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [isRecurring],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [],
              upper: [isRecurring],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause>
      nextRecurrenceDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nextRecurrenceDate',
        value: [null],
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause>
      nextRecurrenceDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nextRecurrenceDate',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause>
      nextRecurrenceDateEqualTo(DateTime? nextRecurrenceDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nextRecurrenceDate',
        value: [nextRecurrenceDate],
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause>
      nextRecurrenceDateNotEqualTo(DateTime? nextRecurrenceDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nextRecurrenceDate',
              lower: [],
              upper: [nextRecurrenceDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nextRecurrenceDate',
              lower: [nextRecurrenceDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nextRecurrenceDate',
              lower: [nextRecurrenceDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nextRecurrenceDate',
              lower: [],
              upper: [nextRecurrenceDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause>
      nextRecurrenceDateGreaterThan(
    DateTime? nextRecurrenceDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nextRecurrenceDate',
        lower: [nextRecurrenceDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause>
      nextRecurrenceDateLessThan(
    DateTime? nextRecurrenceDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nextRecurrenceDate',
        lower: [],
        upper: [nextRecurrenceDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause>
      nextRecurrenceDateBetween(
    DateTime? lowerNextRecurrenceDate,
    DateTime? upperNextRecurrenceDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nextRecurrenceDate',
        lower: [lowerNextRecurrenceDate],
        includeLower: includeLower,
        upper: [upperNextRecurrenceDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TransactionQueryFilter
    on QueryBuilder<Transaction, Transaction, QFilterCondition> {
  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      isRecurringEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRecurring',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      nextRecurrenceDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextRecurrenceDate',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      nextRecurrenceDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextRecurrenceDate',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      nextRecurrenceDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextRecurrenceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      nextRecurrenceDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextRecurrenceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      nextRecurrenceDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextRecurrenceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      nextRecurrenceDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextRecurrenceDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      parentRecurringIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentRecurringId',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      parentRecurringIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentRecurringId',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      parentRecurringIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentRecurringId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      parentRecurringIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentRecurringId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      parentRecurringIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentRecurringId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      parentRecurringIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentRecurringId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      pocketIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pocketId',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      pocketIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pocketId',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> pocketIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pocketId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      pocketIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pocketId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      pocketIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pocketId',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> pocketIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pocketId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceEndDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceEndDate',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceEndDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceEndDate',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceEndDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceEndDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceEndDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceEndDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceEndDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceFrequency',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceFrequency',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recurrenceFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recurrenceFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recurrenceFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recurrenceFrequency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceFrequency',
        value: '',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      recurrenceFrequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recurrenceFrequency',
        value: '',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeEqualTo(
    TransactionType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeGreaterThan(
    TransactionType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeLessThan(
    TransactionType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeBetween(
    TransactionType lower,
    TransactionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension TransactionQueryObject
    on QueryBuilder<Transaction, Transaction, QFilterCondition> {}

extension TransactionQueryLinks
    on QueryBuilder<Transaction, Transaction, QFilterCondition> {
  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> category(
      FilterQuery<Category> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'category');
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'category', 0, true, 0, true);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> account(
      FilterQuery<Account> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'account');
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      accountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'account', 0, true, 0, true);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> toAccount(
      FilterQuery<Account> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'toAccount');
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
      toAccountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'toAccount', 0, true, 0, true);
    });
  }
}

extension TransactionQuerySortBy
    on QueryBuilder<Transaction, Transaction, QSortBy> {
  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      sortByNextRecurrenceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextRecurrenceDate', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      sortByNextRecurrenceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextRecurrenceDate', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      sortByParentRecurringId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentRecurringId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      sortByParentRecurringIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentRecurringId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByPocketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pocketId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByPocketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pocketId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      sortByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      sortByRecurrenceEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      sortByRecurrenceFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceFrequency', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      sortByRecurrenceFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceFrequency', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TransactionQuerySortThenBy
    on QueryBuilder<Transaction, Transaction, QSortThenBy> {
  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      thenByNextRecurrenceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextRecurrenceDate', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      thenByNextRecurrenceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextRecurrenceDate', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      thenByParentRecurringId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentRecurringId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      thenByParentRecurringIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentRecurringId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByPocketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pocketId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByPocketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pocketId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      thenByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      thenByRecurrenceEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      thenByRecurrenceFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceFrequency', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
      thenByRecurrenceFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceFrequency', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension TransactionQueryWhereDistinct
    on QueryBuilder<Transaction, Transaction, QDistinct> {
  QueryBuilder<Transaction, Transaction, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRecurring');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct>
      distinctByNextRecurrenceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextRecurrenceDate');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct>
      distinctByParentRecurringId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentRecurringId');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByPocketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pocketId');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct>
      distinctByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceEndDate');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct>
      distinctByRecurrenceFrequency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceFrequency',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension TransactionQueryProperty
    on QueryBuilder<Transaction, Transaction, QQueryProperty> {
  QueryBuilder<Transaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Transaction, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<Transaction, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Transaction, bool, QQueryOperations> isRecurringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRecurring');
    });
  }

  QueryBuilder<Transaction, DateTime?, QQueryOperations>
      nextRecurrenceDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextRecurrenceDate');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<Transaction, int?, QQueryOperations>
      parentRecurringIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentRecurringId');
    });
  }

  QueryBuilder<Transaction, int?, QQueryOperations> pocketIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pocketId');
    });
  }

  QueryBuilder<Transaction, DateTime?, QQueryOperations>
      recurrenceEndDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceEndDate');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations>
      recurrenceFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceFrequency');
    });
  }

  QueryBuilder<Transaction, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Transaction, TransactionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
