import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  double get _pricePerGram => ref.read(goldPriceProvider).currentPrice;

  double get _eurValue {
    final g = double.tryParse(_goldCtrl.text) ?? 0;
    return g * _pricePerGram;
  }

  Future<void> _confirmTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    final gold = double.tryParse(_goldCtrl.text);
    if (gold == null || gold <= 0) {
      setState(() => _error = 'Enter a valid amount');
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

    final err = await ref.read(transactionProvider.notifier).transferGold(
          recipientEmail: _emailCtrl.text.trim(),
          goldAmount: gold,
          eurValue: _eurValue,
        );

    setState(() => _isLoading = false);

    if (err != null) {
      setState(() => _error = err);
      return;
    }

    if (mounted) {
      await SuccessSheet.show(
        context,
        title: 'Transfer Complete!',
        message:
            '${gold.toStringAsFixed(4)}g of gold sent to ${_emailCtrl.text.trim()}.',
        onDone: () {
          context.pop();
          context.go('/dashboard');
        },
      );
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _goldCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final goldAmt = double.tryParse(_goldCtrl.text) ?? 0;
    final eurVal = goldAmt * _pricePerGram;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transfer Gold'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user != null)
                  BalanceChip(
                    label: 'Gold balance:',
                    amount: '${user.goldBalance.toStringAsFixed(3)}g',
                  ).animate().fadeIn(),

                const SizedBox(height: 24),

                // Recipient
                const Text('Recipient',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textPrimary),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Recipient email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(v)) {
                      return 'Enter a valid email';
                    }
                    if (v.trim() == user?.email) {
                      return 'Cannot transfer to yourself';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'recipient@aurix.com',
                    prefixIcon: Icon(Icons.alternate_email,
                        color: AppColors.textMuted, size: 20),
                  ),
                ).animate(delay: 50.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 24),

                AmountInputField(
                  controller: _goldCtrl,
                  label: 'Amount to send',
                  suffix: 'GOLD',
                  hint: '0.0000',
                  errorText: _error,
                  onChanged: (_) => setState(() {}),
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 16),

                // EUR equivalent
                if (eurVal > 0)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.goldSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.goldPrimary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.goldPrimary, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          'Equivalent value: €${eurVal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.goldPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),

                const SizedBox(height: 40),

                // Confirm summary
                if (_emailCtrl.text.isNotEmpty && goldAmt > 0)
                  AurixCard(
                    child: Column(
                      children: [
                        _summaryRow('To', _emailCtrl.text),
                        const Divider(height: 24),
                        _summaryRow(
                            'Gold', '${goldAmt.toStringAsFixed(4)}g'),
                        const SizedBox(height: 8),
                        _summaryRow(
                            'Value', '€${eurVal.toStringAsFixed(2)}'),
                      ],
                    ),
                  ).animate(delay: 100.ms).fadeIn(),

                const SizedBox(height: 24),

                GoldButton(
                  label: 'Send Gold',
                  isLoading: _isLoading,
                  onPressed: _confirmTransfer,
                  icon: const Icon(Icons.send_rounded,
                      color: AppColors.background, size: 20),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14)),
        Text(value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }
}
