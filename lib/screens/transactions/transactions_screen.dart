import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  TransactionType? _selectedFilter;

  static const _filters = [
    (label: 'All', type: null),
    (label: 'Bought', type: TransactionType.buy),
    (label: 'Sold', type: TransactionType.sell),
    (label: 'Sent', type: TransactionType.transfer),
    (label: 'Received', type: TransactionType.receive),
  ];

  @override
  Widget build(BuildContext context) {
    final txState = ref.watch(transactionProvider);
    final notifier = ref.read(transactionProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction History'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final f = _filters[i];
                  final isSelected = _selectedFilter == f.type;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedFilter = f.type);
                      notifier.setFilter(f.type);
                    },
                    child: AnimatedContainer(
                      duration: 200.ms,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.goldPrimary
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.goldPrimary
                              : AppColors.cardBorder,
                        ),
                      ),
                      child: Text(
                        f.label,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.background
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Transaction list
            Expanded(
              child: txState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.goldPrimary),
                ),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 40),
                      const SizedBox(height: 12),
                      Text('Error: $e',
                          style: const TextStyle(
                              color: AppColors.error)),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => notifier.load(),
                        child: const Text('Retry',
                            style: TextStyle(
                                color: AppColors.goldPrimary)),
                      ),
                    ],
                  ),
                ),
                data: (_) {
                  final filtered = notifier.filtered;
                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.goldSubtle,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                                Icons.receipt_long_outlined,
                                color: AppColors.goldPrimary,
                                size: 32),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No transactions yet',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your gold transactions will appear here',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.goldPrimary,
                    backgroundColor: AppColors.card,
                    onRefresh: () => notifier.load(),
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => TransactionItem(
                        transaction: filtered[index],
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
