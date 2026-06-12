import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class BuyGoldScreen extends ConsumerStatefulWidget {
  const BuyGoldScreen({super.key});

  @override
  ConsumerState<BuyGoldScreen> createState() => _BuyGoldScreenState();
}

class _BuyGoldScreenState extends ConsumerState<BuyGoldScreen> {
  final _eurCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  double get _pricePerGram =>
      ref.read(goldPriceProvider).currentPrice;

  void _onEurChanged(String value) {
    final eur = double.tryParse(value) ?? 0;
    final gold = eur / _pricePerGram;
    _goldCtrl.text = gold > 0 ? gold.toStringAsFixed(4) : '';
    setState(() => _error = null);
  }

  Future<void> _confirmBuy() async {
    final eur = double.tryParse(_eurCtrl.text);
    if (eur == null || eur <= 0) {
      setState(() => _error = 'Enter a valid EUR amount');
      return;
    }
    final user = ref.read(authProvider).user;
    if (user != null && eur > user.eurBalance) {
      setState(() => _error = 'Insufficient EUR balance');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final gold = double.tryParse(_goldCtrl.text) ?? 0;
    final err = await ref
        .read(transactionProvider.notifier)
        .buyGold(eurAmount: eur, goldAmount: gold);

    setState(() => _isLoading = false);

    if (err != null) {
      setState(() => _error = err);
      return;
    }

    if (mounted) {
      await SuccessSheet.show(
        context,
        title: 'Gold Purchased!',
        message:
            'You bought ${gold.toStringAsFixed(4)}g of gold for €${eur.toStringAsFixed(2)}.',
        onDone: () {
          context.pop();
          context.go('/dashboard');
        },
      );
    }
  }

  @override
  void dispose() {
    _eurCtrl.dispose();
    _goldCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final goldPrice = ref.watch(goldPriceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Buy Gold'),
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
              // Price info card
              AurixCard(
                hasGoldBorder: true,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.goldSubtle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.bar_chart_rounded,
                          color: AppColors.goldPrimary, size: 20),
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
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // EUR Balance
              if (user != null)
                BalanceChip(
                  label: 'Available:',
                  amount: '€${user.eurBalance.toStringAsFixed(2)}',
                ).animate(delay: 50.ms).fadeIn(),

              const SizedBox(height: 24),

              AmountInputField(
                controller: _eurCtrl,
                label: 'You pay',
                suffix: 'EUR',
                hint: '0.00',
                errorText: _error,
                onChanged: _onEurChanged,
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 16),

              // Conversion arrow
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.goldSubtle,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.goldPrimary.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.arrow_downward_rounded,
                      color: AppColors.goldPrimary, size: 20),
                ),
              ).animate(delay: 150.ms).fadeIn(),

              const SizedBox(height: 16),

              AmountInputField(
                controller: _goldCtrl,
                label: 'You receive',
                suffix: 'GOLD',
                hint: '0.0000',
                readOnly: true,
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 32),

              // Quick amount buttons
              const Text('Quick amounts',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: [50.0, 100.0, 250.0, 500.0].map((amt) {
                  return GestureDetector(
                    onTap: () {
                      _eurCtrl.text = amt.toStringAsFixed(0);
                      _onEurChanged(amt.toStringAsFixed(0));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text('€${amt.toInt()}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )),
                    ),
                  );
                }).toList(),
              ).animate(delay: 250.ms).fadeIn(),

              const SizedBox(height: 40),

              GoldButton(
                label: 'Buy Gold',
                isLoading: _isLoading,
                onPressed: _confirmBuy,
                icon: const Icon(Icons.add_circle_outline,
                    color: AppColors.background, size: 20),
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
