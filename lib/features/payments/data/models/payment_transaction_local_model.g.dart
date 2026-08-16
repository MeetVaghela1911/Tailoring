// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction_local_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPaymentTransactionLocalModelCollection on Isar {
  IsarCollection<PaymentTransactionLocalModel>
  get paymentTransactionLocalModels => this.collection();
}

const PaymentTransactionLocalModelSchema = CollectionSchema(
  name: r'PaymentTransactionLocalModel',
  id: -8314001627669476694,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.double),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customerId': PropertySchema(
      id: 2,
      name: r'customerId',
      type: IsarType.string,
    ),
    r'customerName': PropertySchema(
      id: 3,
      name: r'customerName',
      type: IsarType.string,
    ),
    r'customerPhone': PropertySchema(
      id: 4,
      name: r'customerPhone',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(id: 5, name: r'isSynced', type: IsarType.bool),
    r'notes': PropertySchema(id: 6, name: r'notes', type: IsarType.string),
    r'orderId': PropertySchema(id: 7, name: r'orderId', type: IsarType.string),
    r'paymentMode': PropertySchema(
      id: 8,
      name: r'paymentMode',
      type: IsarType.long,
    ),
    r'paymentModeName': PropertySchema(
      id: 9,
      name: r'paymentModeName',
      type: IsarType.string,
    ),
    r'paymentStage': PropertySchema(
      id: 10,
      name: r'paymentStage',
      type: IsarType.string,
    ),
    r'referenceNumber': PropertySchema(
      id: 11,
      name: r'referenceNumber',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 12,
      name: r'remoteId',
      type: IsarType.string,
    ),
  },

  estimateSize: _paymentTransactionLocalModelEstimateSize,
  serialize: _paymentTransactionLocalModelSerialize,
  deserialize: _paymentTransactionLocalModelDeserialize,
  deserializeProp: _paymentTransactionLocalModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'orderId': IndexSchema(
      id: -6176610178429382285,
      name: r'orderId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orderId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'customerId': IndexSchema(
      id: 1498639901530368639,
      name: r'customerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'customerId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'isSynced': IndexSchema(
      id: -39763503327887510,
      name: r'isSynced',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isSynced',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _paymentTransactionLocalModelGetId,
  getLinks: _paymentTransactionLocalModelGetLinks,
  attach: _paymentTransactionLocalModelAttach,
  version: '3.3.2',
);

int _paymentTransactionLocalModelEstimateSize(
  PaymentTransactionLocalModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.customerId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customerPhone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.orderId.length * 3;
  {
    final value = object.paymentModeName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.paymentStage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.referenceNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.remoteId.length * 3;
  return bytesCount;
}

void _paymentTransactionLocalModelSerialize(
  PaymentTransactionLocalModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.customerId);
  writer.writeString(offsets[3], object.customerName);
  writer.writeString(offsets[4], object.customerPhone);
  writer.writeBool(offsets[5], object.isSynced);
  writer.writeString(offsets[6], object.notes);
  writer.writeString(offsets[7], object.orderId);
  writer.writeLong(offsets[8], object.paymentMode);
  writer.writeString(offsets[9], object.paymentModeName);
  writer.writeString(offsets[10], object.paymentStage);
  writer.writeString(offsets[11], object.referenceNumber);
  writer.writeString(offsets[12], object.remoteId);
}

PaymentTransactionLocalModel _paymentTransactionLocalModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PaymentTransactionLocalModel();
  object.amount = reader.readDouble(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.customerId = reader.readStringOrNull(offsets[2]);
  object.customerName = reader.readStringOrNull(offsets[3]);
  object.customerPhone = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[5]);
  object.notes = reader.readStringOrNull(offsets[6]);
  object.orderId = reader.readString(offsets[7]);
  object.paymentMode = reader.readLong(offsets[8]);
  object.paymentModeName = reader.readStringOrNull(offsets[9]);
  object.paymentStage = reader.readStringOrNull(offsets[10]);
  object.referenceNumber = reader.readStringOrNull(offsets[11]);
  object.remoteId = reader.readString(offsets[12]);
  return object;
}

P _paymentTransactionLocalModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _paymentTransactionLocalModelGetId(PaymentTransactionLocalModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _paymentTransactionLocalModelGetLinks(
  PaymentTransactionLocalModel object,
) {
  return [];
}

void _paymentTransactionLocalModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  PaymentTransactionLocalModel object,
) {
  object.id = id;
}

extension PaymentTransactionLocalModelByIndex
    on IsarCollection<PaymentTransactionLocalModel> {
  Future<PaymentTransactionLocalModel?> getByRemoteId(String remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  PaymentTransactionLocalModel? getByRemoteIdSync(String remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(String remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(String remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<PaymentTransactionLocalModel?>> getAllByRemoteId(
    List<String> remoteIdValues,
  ) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<PaymentTransactionLocalModel?> getAllByRemoteIdSync(
    List<String> remoteIdValues,
  ) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(PaymentTransactionLocalModel object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(
    PaymentTransactionLocalModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(
    List<PaymentTransactionLocalModel> objects,
  ) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(
    List<PaymentTransactionLocalModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension PaymentTransactionLocalModelQueryWhereSort
    on
        QueryBuilder<
          PaymentTransactionLocalModel,
          PaymentTransactionLocalModel,
          QWhere
        > {
  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhere
  >
  anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhere
  >
  anyIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSynced'),
      );
    });
  }
}

extension PaymentTransactionLocalModelQueryWhere
    on
        QueryBuilder<
          PaymentTransactionLocalModel,
          PaymentTransactionLocalModel,
          QWhereClause
        > {
  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  idNotEqualTo(Id id) {
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

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  remoteIdEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'remoteId', value: [remoteId]),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  remoteIdNotEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [],
                upper: [remoteId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [remoteId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [remoteId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [],
                upper: [remoteId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  orderIdEqualTo(String orderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'orderId', value: [orderId]),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  orderIdNotEqualTo(String orderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderId',
                lower: [],
                upper: [orderId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderId',
                lower: [orderId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderId',
                lower: [orderId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderId',
                lower: [],
                upper: [orderId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'customerId', value: [null]),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'customerId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  customerIdEqualTo(String? customerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'customerId', value: [customerId]),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  customerIdNotEqualTo(String? customerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'customerId',
                lower: [],
                upper: [customerId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'customerId',
                lower: [customerId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'customerId',
                lower: [customerId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'customerId',
                lower: [],
                upper: [customerId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  createdAtGreaterThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [createdAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  createdAtLessThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [],
          upper: [createdAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [lowerCreatedAt],
          includeLower: includeLower,
          upper: [upperCreatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  isSyncedEqualTo(bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isSynced', value: [isSynced]),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterWhereClause
  >
  isSyncedNotEqualTo(bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isSynced',
                lower: [],
                upper: [isSynced],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isSynced',
                lower: [isSynced],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isSynced',
                lower: [isSynced],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isSynced',
                lower: [],
                upper: [isSynced],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension PaymentTransactionLocalModelQueryFilter
    on
        QueryBuilder<
          PaymentTransactionLocalModel,
          PaymentTransactionLocalModel,
          QFilterCondition
        > {
  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  amountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customerId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customerId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerId', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerId', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerName'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerName'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customerName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customerName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerPhone'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerPhone'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customerPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customerPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customerPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customerPhone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customerPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customerPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customerPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customerPhone',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerPhone', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  customerPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerPhone', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSynced', value: value),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'orderId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'orderId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'orderId', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  orderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'orderId', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentMode', value: value),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paymentMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paymentMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paymentMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'paymentModeName'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'paymentModeName'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paymentModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paymentModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paymentModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paymentModeName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paymentModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paymentModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paymentModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paymentModeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentModeName', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentModeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paymentModeName', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'paymentStage'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'paymentStage'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paymentStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paymentStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paymentStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paymentStage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paymentStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paymentStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paymentStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paymentStage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentStage', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  paymentStageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paymentStage', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'referenceNumber'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'referenceNumber'),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'referenceNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'referenceNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'referenceNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'referenceNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'referenceNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'referenceNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'referenceNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'referenceNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'referenceNumber', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  referenceNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'referenceNumber', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'remoteId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'remoteId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'remoteId', value: ''),
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterFilterCondition
  >
  remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'remoteId', value: ''),
      );
    });
  }
}

extension PaymentTransactionLocalModelQueryObject
    on
        QueryBuilder<
          PaymentTransactionLocalModel,
          PaymentTransactionLocalModel,
          QFilterCondition
        > {}

extension PaymentTransactionLocalModelQueryLinks
    on
        QueryBuilder<
          PaymentTransactionLocalModel,
          PaymentTransactionLocalModel,
          QFilterCondition
        > {}

extension PaymentTransactionLocalModelQuerySortBy
    on
        QueryBuilder<
          PaymentTransactionLocalModel,
          PaymentTransactionLocalModel,
          QSortBy
        > {
  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByCustomerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByCustomerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByPaymentMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByPaymentModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByPaymentModeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentModeName', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByPaymentModeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentModeName', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByPaymentStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStage', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByPaymentStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStage', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByReferenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceNumber', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByReferenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceNumber', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }
}

extension PaymentTransactionLocalModelQuerySortThenBy
    on
        QueryBuilder<
          PaymentTransactionLocalModel,
          PaymentTransactionLocalModel,
          QSortThenBy
        > {
  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByCustomerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByCustomerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByPaymentMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByPaymentModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByPaymentModeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentModeName', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByPaymentModeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentModeName', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByPaymentStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStage', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByPaymentStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStage', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByReferenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceNumber', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByReferenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceNumber', Sort.desc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QAfterSortBy
  >
  thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }
}

extension PaymentTransactionLocalModelQueryWhereDistinct
    on
        QueryBuilder<
          PaymentTransactionLocalModel,
          PaymentTransactionLocalModel,
          QDistinct
        > {
  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByCustomerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByCustomerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByCustomerPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'customerPhone',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByOrderId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByPaymentMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentMode');
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByPaymentModeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'paymentModeName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByPaymentStage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentStage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByReferenceNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'referenceNumber',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<
    PaymentTransactionLocalModel,
    PaymentTransactionLocalModel,
    QDistinct
  >
  distinctByRemoteId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }
}

extension PaymentTransactionLocalModelQueryProperty
    on
        QueryBuilder<
          PaymentTransactionLocalModel,
          PaymentTransactionLocalModel,
          QQueryProperty
        > {
  QueryBuilder<PaymentTransactionLocalModel, int, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, double, QQueryOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, String?, QQueryOperations>
  customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, String?, QQueryOperations>
  customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, String?, QQueryOperations>
  customerPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerPhone');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, bool, QQueryOperations>
  isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, String?, QQueryOperations>
  notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, String, QQueryOperations>
  orderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderId');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, int, QQueryOperations>
  paymentModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMode');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, String?, QQueryOperations>
  paymentModeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentModeName');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, String?, QQueryOperations>
  paymentStageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentStage');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, String?, QQueryOperations>
  referenceNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceNumber');
    });
  }

  QueryBuilder<PaymentTransactionLocalModel, String, QQueryOperations>
  remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }
}
