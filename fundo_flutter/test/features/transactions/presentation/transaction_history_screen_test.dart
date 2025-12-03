import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fundo_flutter/features/transactions/application/transaction_providers.dart';
import 'package:fundo_flutter/features/transactions/domain/transaction_model.dart';
import 'package:fundo_flutter/features/transactions/presentation/screens/transaction_history_screen.dart';

void main() {
  final now = DateTime(2024, 7, 20, 14, 30);
  final transaction = TransactionModel(
    id: 'abc',
    amount: 125000,
    category: 'Food',
    date: now,
    note: 'Lunch with team',
    locationName: 'Starbucks Surabaya',
  );

  Widget buildTestApp(Override override) {
    return ProviderScope(
      overrides: [override],
      child: const MaterialApp(home: TransactionHistoryScreen()),
    );
  }

  testWidgets('shows empty state when there are no transactions', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        recentTransactionsProvider.overrideWith(
          (ref) => Stream<List<TransactionModel>>.value([]),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(
      find.text(
        'Tap the green plus button to add your first expense or income.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('renders list items when transactions are available', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        recentTransactionsProvider.overrideWith(
          (ref) => Stream<List<TransactionModel>>.value([transaction]),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Rp'), findsOneWidget);
    expect(find.text('Lunch with team'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
  });

  testWidgets('shows error state when provider throws', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        recentTransactionsProvider.overrideWith(
          (ref) => Stream<List<TransactionModel>>.error('boom'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Failed to load transactions'), findsOneWidget);
    expect(find.text('boom'), findsOneWidget);
  });
}
