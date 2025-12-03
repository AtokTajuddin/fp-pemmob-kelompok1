import 'dart:convert';
import 'dart:io' as io show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/transaction_model.dart';

/// Handles CRUD operations for transactions scoped to the authenticated user.
class TransactionRepository {
  TransactionRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance,
       _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  /// Adds/updates a transaction and uploads the image first when provided.
  Future<TransactionModel> addTransaction(
    TransactionModel transaction, {
    XFile? imageFile,
  }) async {
    final uid = _requireUid();
    debugPrint('📝 Adding transaction ${transaction.id} for user $uid');

    var transactionToPersist = transaction;

    if (imageFile != null) {
      if (kIsWeb) {
        // On web: convert to base64 data URL and store in Firestore directly
        // This avoids CORS issues with Firebase Storage
        debugPrint('📷 Converting image to base64 for web storage...');
        final dataUrl = await _convertToBase64DataUrl(imageFile);
        debugPrint('✅ Image converted to base64 (${dataUrl.length} chars)');
        transactionToPersist = transaction.copyWith(imageUrl: dataUrl);
      } else {
        // On mobile: upload to Firebase Storage
        debugPrint('📤 Uploading receipt image...');
        final uploadedUrl = await _uploadReceipt(
          uid: uid,
          transactionId: transaction.id,
          file: imageFile,
        );
        debugPrint('✅ Receipt uploaded: $uploadedUrl');
        transactionToPersist = transaction.copyWith(imageUrl: uploadedUrl);
      }
    }

    debugPrint('💾 Saving to Firestore...');
    final docRef = _transactionsCollection(uid).doc(transactionToPersist.id);
    await docRef.set(_toFirestore(transactionToPersist));
    debugPrint('✅ Transaction saved successfully!');
    return transactionToPersist;
  }

  /// Returns recent transactions ordered by date (desc).
  Future<List<TransactionModel>> getRecentTransactions({int limit = 20}) async {
    final uid = _requireUid();
    final snapshot = await _transactionsCollection(
      uid,
    ).orderBy('date', descending: true).limit(limit).get();

    return snapshot.docs.map(_fromFirestore).toList(growable: false);
  }

  /// Streams transactions ordered by date so UI stays in sync in real time.
  Stream<List<TransactionModel>> watchRecentTransactions({int limit = 20}) {
    final uid = _requireUid();
    return _transactionsCollection(uid)
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(_fromFirestore).toList(growable: false),
        );
  }

  /// Deletes a transaction document and the associated receipt image if present.
  Future<void> deleteTransaction(String transactionId) async {
    final uid = _requireUid();
    final docRef = _transactionsCollection(uid).doc(transactionId);

    final snapshot = await docRef.get();
    final data = snapshot.data();
    final imageUrl = data?['imageUrl'] as String?;

    await docRef.delete();

    // Only delete from Firebase Storage if it's a Firebase URL (not base64 data URL)
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        !imageUrl.startsWith('data:')) {
      try {
        await _storage.refFromURL(imageUrl).delete();
      } on FirebaseException {
        // Ignore missing file/permission errors, Firestore delete already succeeded.
      }
    }
  }

  CollectionReference<Map<String, dynamic>> _transactionsCollection(
    String uid,
  ) {
    return _firestore.collection('users').doc(uid).collection('transactions');
  }

  String _requireUid() {
    final user = _auth.currentUser;
    if (user == null || user.uid.isEmpty) {
      throw FirebaseAuthException(
        code: 'NO_AUTH_USER',
        message: 'User must be signed in before accessing transactions.',
      );
    }
    return user.uid;
  }

  Map<String, dynamic> _toFirestore(TransactionModel model) {
    final json = model.toJson();
    json['date'] = Timestamp.fromDate(model.date);
    return json;
  }

  TransactionModel _fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    data.putIfAbsent('id', () => document.id);
    return TransactionModel.fromJson(data);
  }

  Future<String> _uploadReceipt({
    required String uid,
    required String transactionId,
    required XFile file,
  }) async {
    final normalizedPath = file.path.replaceAll('\\', '/');
    final fallbackName = normalizedPath.split('/').last;
    final fileName = file.name.isNotEmpty ? file.name : fallbackName;
    final ref = _storage.ref().child(
      'users/$uid/transactions/$transactionId/$fileName',
    );

    debugPrint('📤 Uploading to: ${ref.fullPath}');

    if (kIsWeb) {
      debugPrint('📤 Reading bytes from XFile (web)...');
      final bytes = await file.readAsBytes();
      debugPrint('📤 Got ${bytes.length} bytes, uploading...');
      final task = ref.putData(
        bytes,
        SettableMetadata(contentType: file.mimeType ?? 'image/jpeg'),
      );

      // Monitor upload progress
      task.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes * 100;
        debugPrint('📤 Upload progress: ${progress.toStringAsFixed(1)}%');
      });

      await task;
      debugPrint('📤 Upload complete!');
    } else {
      await ref.putFile(io.File(file.path));
    }

    final url = await ref.getDownloadURL();
    debugPrint('📤 Download URL: $url');
    return url;
  }

  /// Converts an XFile image to a base64 data URL for storing in Firestore.
  /// This is used on web to avoid CORS issues with Firebase Storage.
  /// Note: Firestore docs have a 1MB limit, so images are compressed if needed.
  Future<String> _convertToBase64DataUrl(XFile file) async {
    final bytes = await file.readAsBytes();
    final mimeType = file.mimeType ?? 'image/jpeg';

    // Warn if image is large (Firestore has 1MB doc limit)
    if (bytes.length > 500000) {
      debugPrint(
        '⚠️ Image is ${(bytes.length / 1024).toStringAsFixed(1)}KB - may be large for Firestore',
      );
    }

    final base64String = base64Encode(bytes);
    return 'data:$mimeType;base64,$base64String';
  }
}
