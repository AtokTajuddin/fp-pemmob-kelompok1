import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Domain representation of a user transaction stored under users/{uid}/transactions/.
@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required double amount,
    required String category,
    @_TimestampConverter() required DateTime date,
    required String note,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? locationName,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

/// Handles Firestore Timestamp <-> DateTime conversions while remaining
/// resilient to other supported formats (ISO string / epoch milliseconds).
class _TimestampConverter implements JsonConverter<DateTime, Object?> {
  const _TimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json == null) {
      throw const FormatException('Transaction date cannot be null.');
    }
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is DateTime) {
      return json;
    }
    if (json is String) {
      return DateTime.parse(json);
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    throw FormatException('Unsupported date format: $json');
  }

  @override
  Object toJson(DateTime object) => object.toIso8601String();
}
