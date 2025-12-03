import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/transaction_repository.dart';
import '../domain/transaction_model.dart';
import 'transaction_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider),
  );
});

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(
    repository: ref.watch(transactionRepositoryProvider),
  );
});

final recentTransactionsProvider =
    StreamProvider.autoDispose<List<TransactionModel>>((ref) {
      final service = ref.watch(transactionServiceProvider);
      return service.watchRecentTransactions(limit: 50);
    });
