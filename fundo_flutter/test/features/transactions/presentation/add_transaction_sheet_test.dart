import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fundo_flutter/features/transactions/application/transaction_providers.dart';
import 'package:fundo_flutter/features/transactions/application/transaction_service.dart';
import 'package:fundo_flutter/features/transactions/domain/transaction_model.dart';
import 'package:fundo_flutter/features/transactions/presentation/widgets/add_transaction_sheet.dart';

class _FakeTransactionService implements TransactionService {
  bool submitCalled = false;
  double? lastAmount;
  String? lastNote;

  @override
  Future<XFile?> captureReceiptImage({
    ImageSource source = ImageSource.camera,
  }) async {
    return null;
  }

  @override
  Future<TransactionModel> submitTransaction({
    required double amount,
    required String category,
    required DateTime date,
    required String note,
    XFile? imageFile,
    double? latitude,
    double? longitude,
    String? locationName,
  }) async {
    submitCalled = true;
    lastAmount = amount;
    lastNote = note;
    return TransactionModel(
      id: 'generated',
      amount: amount,
      category: category,
      date: date,
      note: note,
    );
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {}

  @override
  Future<List<TransactionModel>> getRecentTransactions({int limit = 20}) async {
    return const [];
  }

  @override
  Stream<List<TransactionModel>> watchRecentTransactions({int limit = 20}) {
    return const Stream.empty();
  }

  @override
  Future<TransactionLocationSnapshot?> detectCurrentLocation() async {
    return null;
  }
}

void main() {
  Widget buildSheet(_FakeTransactionService service) {
    return ProviderScope(
      overrides: [transactionServiceProvider.overrideWithValue(service)],
      child: const MaterialApp(home: Scaffold(body: AddTransactionSheet())),
    );
  }

  testWidgets('valid submission passes values to transaction service', (
    tester,
  ) async {
    final service = _FakeTransactionService();
    await tester.pumpWidget(buildSheet(service));

    await tester.enterText(find.bySemanticsLabel('Amount'), '120000');
    await tester.enterText(find.bySemanticsLabel('Note'), 'Team lunch');

    await tester.ensureVisible(find.text('Save transaction'));
    await tester.tap(find.text('Save transaction'));
    await tester.pump();

    expect(service.submitCalled, isTrue);
    expect(service.lastAmount, 120000);
    expect(service.lastNote, 'Team lunch');
  });

  testWidgets('shows validation error when amount missing', (tester) async {
    final service = _FakeTransactionService();
    await tester.pumpWidget(buildSheet(service));

    await tester.ensureVisible(find.text('Save transaction'));
    await tester.tap(find.text('Save transaction'));
    await tester.pump();

    expect(find.text('Amount is required'), findsOneWidget);
    expect(service.submitCalled, isFalse);
  });
}
