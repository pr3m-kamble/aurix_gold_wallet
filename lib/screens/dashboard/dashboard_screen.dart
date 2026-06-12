import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final goldPrice = ref.watch(goldPriceProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final theme = Theme.of(context);
    final textPrimary = theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;

    if (user == null) return const SizedBox();

    final portfolioValue = user.goldBalance * goldPrice.currentPrice;
    final totalValue = portfolioValue + user.eurBalance;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good ${_greeting()},',
                            style: TextStyle(color: textSecondary, fontSize: 14)),
                        Text(user.name,
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
                      icon: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.wb_sunny_outlined
                            : Icons.dark_mode_rounded,
                        color: AppColors.goldPrimary,
                      ),
                      splashRadius: 22,
                      tooltip: themeMode == ThemeMode.dark
                          ? 'Switch to light mode'
                          : 'Switch to dark mode',
                    ),
                    IconButton(
                      onPressed: () => _showLogoutDialog(context, ref),
                      icon: const Icon(Icons.logout_rounded,
                          color: AppColors.goldPrimary),
                      splashRadius: 22,
                      tooltip: 'Sign out',
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Portfolio Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E1A0E), Color(0xFF2A2210)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: AppColors.goldPrimary.withValues(alpha: 0.3),
                        width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Total Portfolio',
                              style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 13)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: goldPrice.isPositive
                                  ? AppColors.successSubtle
                                  : AppColors.errorSubtle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  goldPrice.isPositive
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  color: goldPrice.isPositive
                                      ? AppColors.success
                                      : AppColors.error,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${goldPrice.isPositive ? '+' : ''}${goldPrice.changePercent24h.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: goldPrice.isPositive
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '€${totalValue.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.goldLight,
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _balanceItem(
                            label: 'Gold',
                            value: '${user.goldBalance.toStringAsFixed(3)}g',
                            subValue:
                                '€${portfolioValue.toStringAsFixed(2)}',
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.goldPrimary.withValues(alpha: 0.2),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          _balanceItem(
                            label: 'EUR Balance',
                            value: '€${user.eurBalance.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Gold Price Chart
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AurixCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gold Price',
                                  style: TextStyle(
                                      color: textSecondary,
                                      fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                '€${goldPrice.currentPrice.toStringAsFixed(2)}/g',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            '${goldPrice.isPositive ? '+' : ''}€${goldPrice.change24h.toStringAsFixed(2)} today',
                            style: TextStyle(
                              color: goldPrice.isPositive
                                  ? AppColors.success
                                  : AppColors.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 100,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: goldPrice.history
                                    .asMap()
                                    .entries
                                    .map((e) => FlSpot(
                                        e.key.toDouble(), e.value.price))
                                    .toList(),
                                isCurved: true,
                                color: goldPrice.isPositive
                                    ? AppColors.success
                                    : AppColors.error,
                                barWidth: 2,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: (goldPrice.isPositive
                                          ? AppColors.success
                                          : AppColors.error)
                                      .withValues(alpha: 0.08),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Actions',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        QuickActionButton(
                          icon: Icons.add_rounded,
                          label: 'Buy',
                          onTap: () => context.push('/buy'),
                          color: AppColors.success,
                        ),
                        QuickActionButton(
                          icon: Icons.remove_rounded,
                          label: 'Sell',
                          onTap: () => context.push('/sell'),
                          color: AppColors.error,
                        ),
                        QuickActionButton(
                          icon: Icons.send_rounded,
                          label: 'Transfer',
                          onTap: () => context.push('/transfer'),
                          color: AppColors.goldPrimary,
                        ),
                        QuickActionButton(
                          icon: Icons.receipt_long_rounded,
                          label: 'History',
                          onTap: () => context.push('/transactions'),
                          color: const Color(0xFF818CF8),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Recent Transactions Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text('Recent Activity',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.push('/transactions'),
                      child: const Text('See all',
                          style: TextStyle(
                            color: AppColors.goldPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ],
                ),
              ).animate(delay: 350.ms).fadeIn(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Recent transactions list
            Consumer(
              builder: (context, ref, _) {
                final txState = ref.watch(transactionProvider);
                return txState.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.goldPrimary)),
                    ),
                  ),
                  error: (e, _) => SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Error: $e',
                          style: const TextStyle(
                              color: AppColors.error)),
                    ),
                  ),
                  data: (transactions) {
                    final recent = transactions.take(3).toList();
                    if (recent.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No transactions yet.',
                              style: TextStyle(
                                  color: AppColors.textMuted)),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => TransactionItem(
                            transaction: recent[index],
                            index: index,
                          ),
                          childCount: recent.length,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _balanceItem(
      {required String label,
      required String value,
      String? subValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
              color: AppColors.goldLight,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            )),
        if (subValue != null)
          Text(subValue,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 12)),
      ],
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Sign Out',
              style: TextStyle(color: AppColors.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Are you sure you want to sign out?',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size.fromHeight(56),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(authProvider.notifier).logout();
                },
                child: const Text('Logout'),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.goldPrimary,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
          actions: const [],
        );
      },
    );
  }
}
