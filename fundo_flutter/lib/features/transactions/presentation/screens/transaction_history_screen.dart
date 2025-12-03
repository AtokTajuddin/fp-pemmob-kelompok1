import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/transaction_providers.dart';
import '../../domain/transaction_model.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return SafeArea(
      child: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const _EmptyHistoryView();
          }
          return _TransactionList(transactions: transactions);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _HistoryErrorView(error: error),
      ),
    );
  }
}

class _TransactionList extends ConsumerWidget {
  const _TransactionList({required this.transactions});

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(recentTransactionsProvider);
        await ref.read(recentTransactionsProvider.future);
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final subtitle = StringBuffer()
            ..write(dateFormat.format(transaction.date));
          if (transaction.locationName?.isNotEmpty ?? false) {
            subtitle
              ..write(' · ')
              ..write(transaction.locationName);
          }
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.receipt_long,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                currency.format(transaction.amount),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (transaction.note.isNotEmpty)
                    Text(
                      transaction.note,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                  if (transaction.latitude != null &&
                      transaction.longitude != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Lat ${transaction.latitude!.toStringAsFixed(4)}, '
                            'Lng ${transaction.longitude!.toStringAsFixed(4)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.category,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  if (transaction.imageUrl != null &&
                      transaction.imageUrl!.isNotEmpty)
                    const Icon(Icons.attachment, size: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyHistoryView extends StatelessWidget {
  const _EmptyHistoryView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.grey.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the green plus button to add your first expense or income.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryErrorView extends StatelessWidget {
  const _HistoryErrorView({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load transactions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '$error',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
