import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/support_chat_repository.dart';
import '../domain/support_chat_message.dart';
import 'support_chat_service.dart';

final supportChatRepositoryProvider = Provider<SupportChatRepository>((ref) {
  return SupportChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final supportChatServiceProvider = Provider<SupportChatService>((ref) {
  return SupportChatService(
    repository: ref.watch(supportChatRepositoryProvider),
  );
});

final supportChatMessagesProvider =
    StreamProvider.autoDispose<List<SupportChatMessage>>((ref) {
      final service = ref.watch(supportChatServiceProvider);
      return service.watchConversation(limit: 100);
    });
