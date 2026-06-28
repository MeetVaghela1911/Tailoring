// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_local_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderLocalModelCollection on Isar {
  IsarCollection<OrderLocalModel> get orderLocalModels => this.collection();
}

const OrderLocalModelSchema = CollectionSchema(
  name: r'OrderLocalModel',
  id: 4811415428614039087,
  properties: {
    r'advancePaid': PropertySchema(
      id: 0,
      name: r'advancePaid',
      type: IsarType.double,
    ),
    r'assignedTailor': PropertySchema(
      id: 1,
      name: r'assignedTailor',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customerId': PropertySchema(
      id: 3,
      name: r'customerId',
      type: IsarType.string,
    ),
    r'customerName': PropertySchema(
      id: 4,
      name: r'customerName',
      type: IsarType.string,
    ),
    r'customerPhone': PropertySchema(
      id: 5,
      name: r'customerPhone',
      type: IsarType.string,
    ),
    r'deliveryDate': PropertySchema(
      id: 6,
      name: r'deliveryDate',
      type: IsarType.dateTime,
    ),
    r'externalCharges': PropertySchema(
      id: 7,
      name: r'externalCharges',
      type: IsarType.double,
    ),
    r'garmentPricesJson': PropertySchema(
      id: 8,
      name: r'garmentPricesJson',
      type: IsarType.string,
    ),
    r'garmentQuantitiesJson': PropertySchema(
      id: 9,
      name: r'garmentQuantitiesJson',
      type: IsarType.string,
    ),
    r'garmentTypes': PropertySchema(
      id: 10,
      name: r'garmentTypes',
      type: IsarType.stringList,
    ),
    r'isSynced': PropertySchema(id: 11, name: r'isSynced', type: IsarType.bool),
    r'lastUpdated': PropertySchema(
      id: 12,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'measurementNotesJson': PropertySchema(
      id: 13,
      name: r'measurementNotesJson',
      type: IsarType.string,
    ),
    r'measurementsJson': PropertySchema(
      id: 14,
      name: r'measurementsJson',
      type: IsarType.string,
    ),
    r'paymentMode': PropertySchema(
      id: 15,
      name: r'paymentMode',
      type: IsarType.long,
    ),
    r'priorityIndex': PropertySchema(
      id: 16,
      name: r'priorityIndex',
      type: IsarType.long,
    ),
    r'referenceImagePath': PropertySchema(
      id: 17,
      name: r'referenceImagePath',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 18,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'specialInstructions': PropertySchema(
      id: 19,
      name: r'specialInstructions',
      type: IsarType.string,
    ),
    r'status': PropertySchema(id: 20, name: r'status', type: IsarType.string),
    r'totalAmount': PropertySchema(
      id: 21,
      name: r'totalAmount',
      type: IsarType.double,
    ),
  },

  estimateSize: _orderLocalModelEstimateSize,
  serialize: _orderLocalModelSerialize,
  deserialize: _orderLocalModelDeserialize,
  deserializeProp: _orderLocalModelDeserializeProp,
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
    r'deliveryDate': IndexSchema(
      id: 3163565673826690650,
      name: r'deliveryDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deliveryDate',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
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

  getId: _orderLocalModelGetId,
  getLinks: _orderLocalModelGetLinks,
  attach: _orderLocalModelAttach,
  version: '3.3.2',
);

int _orderLocalModelEstimateSize(
  OrderLocalModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assignedTailor.length * 3;
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
  bytesCount += 3 + object.garmentPricesJson.length * 3;
  bytesCount += 3 + object.garmentQuantitiesJson.length * 3;
  bytesCount += 3 + object.garmentTypes.length * 3;
  {
    for (var i = 0; i < object.garmentTypes.length; i++) {
      final value = object.garmentTypes[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.measurementNotesJson.length * 3;
  bytesCount += 3 + object.measurementsJson.length * 3;
  {
    final value = object.referenceImagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.remoteId.length * 3;
  {
    final value = object.specialInstructions;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _orderLocalModelSerialize(
  OrderLocalModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.advancePaid);
  writer.writeString(offsets[1], object.assignedTailor);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.customerId);
  writer.writeString(offsets[4], object.customerName);
  writer.writeString(offsets[5], object.customerPhone);
  writer.writeDateTime(offsets[6], object.deliveryDate);
  writer.writeDouble(offsets[7], object.externalCharges);
  writer.writeString(offsets[8], object.garmentPricesJson);
  writer.writeString(offsets[9], object.garmentQuantitiesJson);
  writer.writeStringList(offsets[10], object.garmentTypes);
  writer.writeBool(offsets[11], object.isSynced);
  writer.writeDateTime(offsets[12], object.lastUpdated);
  writer.writeString(offsets[13], object.measurementNotesJson);
  writer.writeString(offsets[14], object.measurementsJson);
  writer.writeLong(offsets[15], object.paymentMode);
  writer.writeLong(offsets[16], object.priorityIndex);
  writer.writeString(offsets[17], object.referenceImagePath);
  writer.writeString(offsets[18], object.remoteId);
  writer.writeString(offsets[19], object.specialInstructions);
  writer.writeString(offsets[20], object.status);
  writer.writeDouble(offsets[21], object.totalAmount);
}

OrderLocalModel _orderLocalModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderLocalModel();
  object.advancePaid = reader.readDouble(offsets[0]);
  object.assignedTailor = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.customerId = reader.readStringOrNull(offsets[3]);
  object.customerName = reader.readStringOrNull(offsets[4]);
  object.customerPhone = reader.readStringOrNull(offsets[5]);
  object.deliveryDate = reader.readDateTimeOrNull(offsets[6]);
  object.externalCharges = reader.readDouble(offsets[7]);
  object.garmentPricesJson = reader.readString(offsets[8]);
  object.garmentQuantitiesJson = reader.readString(offsets[9]);
  object.garmentTypes = reader.readStringList(offsets[10]) ?? [];
  object.id = id;
  object.isSynced = reader.readBool(offsets[11]);
  object.lastUpdated = reader.readDateTimeOrNull(offsets[12]);
  object.measurementNotesJson = reader.readString(offsets[13]);
  object.measurementsJson = reader.readString(offsets[14]);
  object.paymentMode = reader.readLong(offsets[15]);
  object.priorityIndex = reader.readLong(offsets[16]);
  object.referenceImagePath = reader.readStringOrNull(offsets[17]);
  object.remoteId = reader.readString(offsets[18]);
  object.specialInstructions = reader.readStringOrNull(offsets[19]);
  object.status = reader.readString(offsets[20]);
  object.totalAmount = reader.readDouble(offsets[21]);
  return object;
}

P _orderLocalModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringList(offset) ?? []) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderLocalModelGetId(OrderLocalModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderLocalModelGetLinks(OrderLocalModel object) {
  return [];
}

void _orderLocalModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  OrderLocalModel object,
) {
  object.id = id;
}

extension OrderLocalModelByIndex on IsarCollection<OrderLocalModel> {
  Future<OrderLocalModel?> getByRemoteId(String remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  OrderLocalModel? getByRemoteIdSync(String remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(String remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(String remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<OrderLocalModel?>> getAllByRemoteId(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<OrderLocalModel?> getAllByRemoteIdSync(List<String> remoteIdValues) {
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

  Future<Id> putByRemoteId(OrderLocalModel object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(OrderLocalModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<OrderLocalModel> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(
    List<OrderLocalModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension OrderLocalModelQueryWhereSort
    on QueryBuilder<OrderLocalModel, OrderLocalModel, QWhere> {
  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhere>
  anyDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'deliveryDate'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhere> anyIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSynced'),
      );
    });
  }
}

extension OrderLocalModelQueryWhere
    on QueryBuilder<OrderLocalModel, OrderLocalModel, QWhereClause> {
  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  remoteIdEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'remoteId', value: [remoteId]),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'customerId', value: [null]),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  customerIdEqualTo(String? customerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'customerId', value: [customerId]),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  deliveryDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'deliveryDate', value: [null]),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  deliveryDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deliveryDate',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  deliveryDateEqualTo(DateTime? deliveryDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'deliveryDate',
          value: [deliveryDate],
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  deliveryDateNotEqualTo(DateTime? deliveryDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deliveryDate',
                lower: [],
                upper: [deliveryDate],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deliveryDate',
                lower: [deliveryDate],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deliveryDate',
                lower: [deliveryDate],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deliveryDate',
                lower: [],
                upper: [deliveryDate],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  deliveryDateGreaterThan(DateTime? deliveryDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deliveryDate',
          lower: [deliveryDate],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  deliveryDateLessThan(DateTime? deliveryDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deliveryDate',
          lower: [],
          upper: [deliveryDate],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  deliveryDateBetween(
    DateTime? lowerDeliveryDate,
    DateTime? upperDeliveryDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deliveryDate',
          lower: [lowerDeliveryDate],
          includeLower: includeLower,
          upper: [upperDeliveryDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'status', value: [status]),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
  isSyncedEqualTo(bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isSynced', value: [isSynced]),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterWhereClause>
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

extension OrderLocalModelQueryFilter
    on QueryBuilder<OrderLocalModel, OrderLocalModel, QFilterCondition> {
  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  advancePaidEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'advancePaid',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  advancePaidGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'advancePaid',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  advancePaidLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'advancePaid',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  advancePaidBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'advancePaid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'assignedTailor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'assignedTailor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'assignedTailor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'assignedTailor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'assignedTailor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'assignedTailor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'assignedTailor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'assignedTailor',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'assignedTailor', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  assignedTailorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'assignedTailor', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerId'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerId', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerId', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerName'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerName'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerName', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customerPhone'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customerPhone'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerPhone', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  customerPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerPhone', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  deliveryDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deliveryDate'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  deliveryDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'deliveryDate'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  deliveryDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deliveryDate', value: value),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  deliveryDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deliveryDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  deliveryDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deliveryDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  deliveryDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deliveryDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  externalChargesEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'externalCharges',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  externalChargesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'externalCharges',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  externalChargesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'externalCharges',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  externalChargesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'externalCharges',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'garmentPricesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'garmentPricesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'garmentPricesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'garmentPricesJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'garmentPricesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'garmentPricesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'garmentPricesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'garmentPricesJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'garmentPricesJson', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentPricesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'garmentPricesJson', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'garmentQuantitiesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'garmentQuantitiesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'garmentQuantitiesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'garmentQuantitiesJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'garmentQuantitiesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'garmentQuantitiesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'garmentQuantitiesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'garmentQuantitiesJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'garmentQuantitiesJson', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentQuantitiesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'garmentQuantitiesJson',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'garmentTypes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'garmentTypes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'garmentTypes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'garmentTypes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'garmentTypes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'garmentTypes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'garmentTypes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'garmentTypes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'garmentTypes', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'garmentTypes', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'garmentTypes', length, true, length, true);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'garmentTypes', 0, true, 0, true);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'garmentTypes', 0, false, 999999, true);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'garmentTypes', 0, true, length, include);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'garmentTypes', length, include, 999999, true);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  garmentTypesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'garmentTypes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSynced', value: value),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  lastUpdatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastUpdated'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  lastUpdatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastUpdated'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  lastUpdatedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastUpdated', value: value),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  lastUpdatedGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastUpdated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  lastUpdatedLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastUpdated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  lastUpdatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastUpdated',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'measurementNotesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'measurementNotesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'measurementNotesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'measurementNotesJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'measurementNotesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'measurementNotesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'measurementNotesJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'measurementNotesJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'measurementNotesJson', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementNotesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'measurementNotesJson',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'measurementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'measurementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'measurementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'measurementsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'measurementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'measurementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'measurementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'measurementsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'measurementsJson', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  measurementsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'measurementsJson', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  paymentModeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentMode', value: value),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  priorityIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'priorityIndex', value: value),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  priorityIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'priorityIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  priorityIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'priorityIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  priorityIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'priorityIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'referenceImagePath'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'referenceImagePath'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'referenceImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'referenceImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'referenceImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'referenceImagePath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'referenceImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'referenceImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'referenceImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'referenceImagePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'referenceImagePath', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  referenceImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'referenceImagePath', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
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

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'remoteId', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'remoteId', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'specialInstructions'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'specialInstructions'),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'specialInstructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'specialInstructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'specialInstructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'specialInstructions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'specialInstructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'specialInstructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'specialInstructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'specialInstructions',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'specialInstructions', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  specialInstructionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'specialInstructions',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  totalAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  totalAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  totalAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterFilterCondition>
  totalAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension OrderLocalModelQueryObject
    on QueryBuilder<OrderLocalModel, OrderLocalModel, QFilterCondition> {}

extension OrderLocalModelQueryLinks
    on QueryBuilder<OrderLocalModel, OrderLocalModel, QFilterCondition> {}

extension OrderLocalModelQuerySortBy
    on QueryBuilder<OrderLocalModel, OrderLocalModel, QSortBy> {
  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByAdvancePaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'advancePaid', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByAdvancePaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'advancePaid', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByAssignedTailor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedTailor', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByAssignedTailorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedTailor', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByCustomerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByCustomerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDate', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByDeliveryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDate', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByExternalCharges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalCharges', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByExternalChargesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalCharges', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByGarmentPricesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentPricesJson', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByGarmentPricesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentPricesJson', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByGarmentQuantitiesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentQuantitiesJson', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByGarmentQuantitiesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentQuantitiesJson', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByMeasurementNotesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementNotesJson', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByMeasurementNotesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementNotesJson', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByMeasurementsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsJson', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByMeasurementsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsJson', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByPaymentMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByPaymentModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByPriorityIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priorityIndex', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByPriorityIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priorityIndex', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByReferenceImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceImagePath', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByReferenceImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceImagePath', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortBySpecialInstructions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specialInstructions', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortBySpecialInstructionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specialInstructions', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  sortByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension OrderLocalModelQuerySortThenBy
    on QueryBuilder<OrderLocalModel, OrderLocalModel, QSortThenBy> {
  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByAdvancePaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'advancePaid', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByAdvancePaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'advancePaid', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByAssignedTailor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedTailor', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByAssignedTailorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedTailor', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByCustomerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByCustomerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDate', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByDeliveryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDate', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByExternalCharges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalCharges', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByExternalChargesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalCharges', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByGarmentPricesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentPricesJson', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByGarmentPricesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentPricesJson', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByGarmentQuantitiesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentQuantitiesJson', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByGarmentQuantitiesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentQuantitiesJson', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByMeasurementNotesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementNotesJson', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByMeasurementNotesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementNotesJson', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByMeasurementsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsJson', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByMeasurementsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsJson', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByPaymentMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByPaymentModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByPriorityIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priorityIndex', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByPriorityIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priorityIndex', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByReferenceImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceImagePath', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByReferenceImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceImagePath', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenBySpecialInstructions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specialInstructions', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenBySpecialInstructionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specialInstructions', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QAfterSortBy>
  thenByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension OrderLocalModelQueryWhereDistinct
    on QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct> {
  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByAdvancePaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'advancePaid');
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByAssignedTailor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'assignedTailor',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByCustomerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByCustomerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByCustomerPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'customerPhone',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveryDate');
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByExternalCharges() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'externalCharges');
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByGarmentPricesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'garmentPricesJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByGarmentQuantitiesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'garmentQuantitiesJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByGarmentTypes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'garmentTypes');
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByMeasurementNotesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'measurementNotesJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByMeasurementsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'measurementsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByPaymentMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentMode');
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByPriorityIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priorityIndex');
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByReferenceImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'referenceImagePath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct> distinctByRemoteId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctBySpecialInstructions({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'specialInstructions',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderLocalModel, OrderLocalModel, QDistinct>
  distinctByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAmount');
    });
  }
}

extension OrderLocalModelQueryProperty
    on QueryBuilder<OrderLocalModel, OrderLocalModel, QQueryProperty> {
  QueryBuilder<OrderLocalModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderLocalModel, double, QQueryOperations>
  advancePaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'advancePaid');
    });
  }

  QueryBuilder<OrderLocalModel, String, QQueryOperations>
  assignedTailorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assignedTailor');
    });
  }

  QueryBuilder<OrderLocalModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OrderLocalModel, String?, QQueryOperations>
  customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<OrderLocalModel, String?, QQueryOperations>
  customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<OrderLocalModel, String?, QQueryOperations>
  customerPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerPhone');
    });
  }

  QueryBuilder<OrderLocalModel, DateTime?, QQueryOperations>
  deliveryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveryDate');
    });
  }

  QueryBuilder<OrderLocalModel, double, QQueryOperations>
  externalChargesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'externalCharges');
    });
  }

  QueryBuilder<OrderLocalModel, String, QQueryOperations>
  garmentPricesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'garmentPricesJson');
    });
  }

  QueryBuilder<OrderLocalModel, String, QQueryOperations>
  garmentQuantitiesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'garmentQuantitiesJson');
    });
  }

  QueryBuilder<OrderLocalModel, List<String>, QQueryOperations>
  garmentTypesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'garmentTypes');
    });
  }

  QueryBuilder<OrderLocalModel, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<OrderLocalModel, DateTime?, QQueryOperations>
  lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<OrderLocalModel, String, QQueryOperations>
  measurementNotesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measurementNotesJson');
    });
  }

  QueryBuilder<OrderLocalModel, String, QQueryOperations>
  measurementsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measurementsJson');
    });
  }

  QueryBuilder<OrderLocalModel, int, QQueryOperations> paymentModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMode');
    });
  }

  QueryBuilder<OrderLocalModel, int, QQueryOperations> priorityIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priorityIndex');
    });
  }

  QueryBuilder<OrderLocalModel, String?, QQueryOperations>
  referenceImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceImagePath');
    });
  }

  QueryBuilder<OrderLocalModel, String, QQueryOperations> remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<OrderLocalModel, String?, QQueryOperations>
  specialInstructionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'specialInstructions');
    });
  }

  QueryBuilder<OrderLocalModel, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<OrderLocalModel, double, QQueryOperations>
  totalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAmount');
    });
  }
}
