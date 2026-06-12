import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

// ─── Gold Gradient Button ────────────────────────────────────────────────────

class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;

  const GoldButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? const LinearGradient(
                  colors: [Color(0xFF444444), Color(0xFF333333)])
              : const LinearGradient(
                  colors: [
                    AppColors.goldLight,
                    AppColors.goldPrimary,
                    AppColors.goldDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.goldPrimary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: Size(width ?? double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.background,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 8)],
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.background,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Aurix Card ──────────────────────────────────────────────────────────────

class AurixCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool hasGoldBorder;
  final VoidCallback? onTap;

  const AurixCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.hasGoldBorder = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasGoldBorder
                ? AppColors.goldPrimary.withValues(alpha: 0.4)
                : AppColors.cardBorder,
            width: hasGoldBorder ? 1.5 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

// ─── Quick Action Button ─────────────────────────────────────────────────────

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.goldPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.withValues(alpha: 0.25)),
            ),
            child: Icon(icon, color: c, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Amount Input Field ───────────────────────────────────────────────────────

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String suffix;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const AmountInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.suffix,
    this.hint,
    this.errorText,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
          ],
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint ?? '0.00',
            errorText: errorText,
            suffixText: suffix,
            suffixStyle: const TextStyle(
              color: AppColors.goldPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
      ],
    );
  }
}

// ─── Balance Chip ─────────────────────────────────────────────────────────────

class BalanceChip extends StatelessWidget {
  final String label;
  final String amount;

  const BalanceChip({super.key, required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.goldSubtle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          Text(amount,
              style: const TextStyle(
                  color: AppColors.goldPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ─── Transaction Item ─────────────────────────────────────────────────────────

class TransactionItem extends StatelessWidget {
  final dynamic transaction; // TransactionModel
  final int index;

  const TransactionItem(
      {super.key, required this.transaction, required this.index});

  IconData get _icon {
    switch (transaction.type.index) {
      case 0:
        return Icons.add_circle_outline;
      case 1:
        return Icons.remove_circle_outline;
      case 2:
        return Icons.arrow_upward;
      case 3:
        return Icons.arrow_downward;
      default:
        return Icons.circle;
    }
  }

  Color get _color {
    switch (transaction.type.index) {
      case 0:
      case 3:
        return AppColors.success;
      case 1:
      case 2:
        return AppColors.error;
      default:
        return AppColors.goldPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.isCredit as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: _color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.typeLabel as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _formatDate(transaction.date as DateTime),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (transaction.recipientEmail != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '• ${transaction.recipientEmail}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}${(transaction.goldAmount as double).toStringAsFixed(3)}g',
                style: TextStyle(
                  color: isCredit ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                '€${(transaction.eurAmount as double).toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 60)).fadeIn().slideX(
          begin: 0.05,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ─── Auth Text Field ──────────────────────────────────────────────────────────

class AurixTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;

  const AurixTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
  });

  @override
  State<AurixTextField> createState() => _AurixTextFieldState();
}

class _AurixTextFieldState extends State<AurixTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscure,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              )
            : null,
      ),
    );
  }
}

// ─── Success Bottom Sheet ──────────────────────────────────────────────────────

class SuccessSheet extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDone;

  const SuccessSheet({
    super.key,
    required this.title,
    required this.message,
    required this.onDone,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onDone,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SuccessSheet(title: title, message: message, onDone: onDone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.successSubtle,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.success,
              size: 36,
            ),
          )
              .animate()
              .scale(duration: 400.ms, curve: Curves.elasticOut)
              .fadeIn(duration: 300.ms),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 28),
          GoldButton(
            label: 'Done',
            onPressed: onDone,
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
