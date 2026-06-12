import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).clearError();
    await ref.read(authProvider.notifier).register(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (_, next) {
      if (next.isLoggedIn && next.user != null) {
        context.go('/dashboard');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Create account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),
                const SizedBox(height: 8),
                const Text(
                  'Start your gold investment journey',
                  style: TextStyle(
                      fontSize: 16, color: AppColors.textSecondary),
                ).animate(delay: 50.ms).fadeIn(),

                const SizedBox(height: 36),

                if (authState.error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.errorSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Text(authState.error!,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 14)),
                  ).animate().fadeIn().shakeX(),

                AurixTextField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  hint: 'John Doe',
                  prefixIcon: const Icon(Icons.person_outline,
                      color: AppColors.textMuted, size: 20),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Name is required';
                    }
                    if (v.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 16),

                AurixTextField(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline,
                      color: AppColors.textMuted, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(v)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 16),

                AurixTextField(
                  controller: _passwordCtrl,
                  label: 'Password',
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textMuted, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 16),

                AurixTextField(
                  controller: _confirmCtrl,
                  label: 'Confirm Password',
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textMuted, size: 20),
                  validator: (v) {
                    if (v != _passwordCtrl.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 32),

                GoldButton(
                  label: 'Create Account',
                  isLoading: authState.isLoading,
                  onPressed: _register,
                ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ',
                        style: TextStyle(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Text('Sign in',
                          style: TextStyle(
                            color: AppColors.goldPrimary,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ).animate(delay: 350.ms).fadeIn(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
