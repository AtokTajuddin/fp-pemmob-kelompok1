import 'package:cloud_firestore/cloud_firestore.dart';

class SupportChatMessage {
  SupportChatMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.fromSupport,
  });

  final String id;
  final String text;
  final DateTime sentAt;
  final bool fromSupport;

  factory SupportChatMessage.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    return SupportChatMessage(
      id: document.id,
      text: data['text'] as String? ?? '',
      sentAt: _parseTimestamp(data['sentAt']) ?? DateTime.now(),
      fromSupport: data['fromSupport'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sentAt': Timestamp.fromDate(sentAt),
      'fromSupport': fromSupport,
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }
}
