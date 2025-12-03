import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/support_chat_message.dart';

class SupportChatRepository {
  SupportChatRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<void> sendUserMessage(String text) async {
    final uid = _requireUid();
    await _messagesCollection(uid).add({
      'text': text,
      'fromSupport': false,
      'sentAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<SupportChatMessage>> watchMessages({int limit = 50}) {
    final uid = _requireUid();
    return _messagesCollection(uid)
        .orderBy('sentAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          final items =
              snapshot.docs
                  .map(SupportChatMessage.fromDocument)
                  .toList(growable: false)
                ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
          return items;
        });
  }

  CollectionReference<Map<String, dynamic>> _messagesCollection(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('supportMessages');
  }

  String _requireUid() {
    final user = _auth.currentUser;
    if (user == null || user.uid.isEmpty) {
      throw FirebaseAuthException(
        code: 'NO_AUTH_USER',
        message: 'User must be signed in before accessing support chat.',
      );
    }
    return user.uid;
  }
}
