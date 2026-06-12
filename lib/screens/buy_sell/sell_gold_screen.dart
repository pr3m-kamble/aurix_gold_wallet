import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SellGoldScreen extends ConsumerStatefulWidget {
  const SellGoldScreen({super.key});

  @override
  ConsumerState<SellGoldScreen> createState() => _SellGoldScreenState();
}

class _SellGoldScreenState extends ConsumerState<SellGoldScreen> {
  final _goldCtrl = TextEditingController();
  final _eurCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  double get _pricePerGram => ref.read(goldPriceProvider).currentPrice;

  void _onGoldChanged(String value) {
    final gold = double.tryParse(value) ?? 0;
    final eur = gold * _pricePerGram;
    _eurCtrl.text = eur > 0 ? eur.toStringAsFixed(2) : '';
    setState(() => _error = null);
  }

  Future<void> _confirmSell() async {
    final gold = double.tryParse(_goldCtrl.text);
    if (gold == null || gold <= 0) {
      setState(() => _error = 'Enter a valid gold amount');
      return;
    }
    final user = ref.read(authProvider).user;
    if (user != null && gold > user.goldBalance) {
      setState(() => _error = 'Insufficient gold balance');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final eur = double.tryParse(_eurCtrl.text) ?? 0;
    final err = await ref
        .read(transactionProvider.notifier)
        .sellGold(goldAmount: gold, eurAmount: eur);

    setState(() => _isLoading = false);

    if (err != null) {
      setState(() => _error = err);
      return;
    }

    if (mounted) {
      await SuccessSheet.show(
        context,
        title: 'Gold Sold!',
        message:
            'You sold ${gold.toStringAsFixed(4)}g of gold for €${eur.toStringAsFixed(2)}.',
        onDone: () {
          context.pop();
          context.go('/dashboard');
        },
      );
    }
  }

  @override
  void dispose() {
    _goldCtrl.dispose();
    _eurCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final goldPrice = ref.watch(goldPriceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sell Gold'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AurixCard(
                hasGoldBorder: true,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.errorSubtle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.remove_circle_outline,
                          color: AppColors.error, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current gold price',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13)),
                        Text(
                          '€${goldPrice.currentPrice.toStringAsFixed(2)} / gram',
                          style: const TextStyle(
                            color: AppColors.goldPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 24),

              if (user != null)
                BalanceChip(
                  label: 'Gold balance:',
                  amount: '${user.goldBalance.toStringAsFixed(3)}g',
                ).animate(delay: 50.ms).fadeIn(),

              const SizedBox(height: 24),

              AmountInputField(
                controller: _goldCtrl,
                label: 'You sell',
                suffix: 'GOLD',
                hint: '0.0000',
                errorText: _error,
                onChanged: _onGoldChanged,
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 16),

              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.errorSubtle,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.arrow_downward_rounded,
                      color: AppColors.error, size: 20),
                ),
              ).animate(delay: 150.ms).fadeIn(),

              const SizedBox(height: 16),

              AmountInputField(
                controller: _eurCtrl,
                label: 'You receive',
                suffix: 'EUR',
                hint: '0.00',
                readOnly: true,
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 32),

              const Text('Quick sell',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              if (user != null)
                Wrap(
                  spacing: 10,
                  children: [0.5, 1.0, 2.0, 5.0].map((grams) {
                    final canSell = grams <= user.goldBalance;
                    return GestureDetector(
                      onTap: canSell
                          ? () {
                              _goldCtrl.text = grams.toStringAsFixed(1);
                              _onGoldChanged(grams.toStringAsFixed(1));
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: canSell
                              ? AppColors.surfaceElevated
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text('${grams}g',
                            style: TextStyle(
                              color: canSell
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            )),
                      ),
                    );
                  }).toList(),
                ).animate(delay: 250.ms).fadeIn(),

              const SizedBox(height: 40),

              GoldButton(
                label: 'Sell Gold',
                isLoading: _isLoading,
                onPressed: () => _confirmSell(),
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
