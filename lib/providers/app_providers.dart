import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../models/gold_price_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/gold_price_service.dart';
import '../services/transaction_service.dart';

// ─── Services ───────────────────────────────────────────────────────────────

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(storageServiceProvider));
});

final goldPriceServiceProvider = Provider<GoldPriceService>((ref) {
  return GoldPriceService();
});

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(ref.read(storageServiceProvider));
});

// ─── Auth State ─────────────────────────────────────────────────────────────

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      final user = await _authService.getCurrentUser();
      state = AuthState(user: user, isLoggedIn: user != null);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.login(email: email, password: password);
      state = AuthState(user: user, isLoggedIn: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
      );
      state = AuthState(user: user, isLoggedIn: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState();
  }

  void updateUser(UserModel user) {
    state = state.copyWith(user: user);
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// ─── Transactions ────────────────────────────────────────────────────────────

class TransactionNotifier extends StateNotifier<AsyncValue<List<TransactionModel>>> {
  final TransactionService _service;
  final Ref _ref;
  TransactionType? _filterType;

  TransactionNotifier(this._service, this._ref)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final transactions = await _service.getTransactions();
      state = AsyncValue.data(transactions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  List<TransactionModel> get filtered {
    final all = state.valueOrNull ?? [];
    if (_filterType == null) return all;
    return all.where((t) => t.type == _filterType).toList();
  }

  void setFilter(TransactionType? type) {
    _filterType = type;
    state = AsyncValue.data(state.valueOrNull ?? []);
  }

  TransactionType? get currentFilter => _filterType;

  Future<String?> buyGold({
    required double eurAmount,
    required double goldAmount,
  }) async {
    final user = _ref.read(authProvider).user;
    if (user == null) return 'Not logged in';
    try {
      final result = await _service.buyGold(
        user: user,
        eurAmount: eurAmount,
        goldAmount: goldAmount,
      );
      _ref.read(authProvider.notifier).updateUser(result.updatedUser);
      await load();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<String?> sellGold({
    required double goldAmount,
    required double eurAmount,
  }) async {
    final user = _ref.read(authProvider).user;
    if (user == null) return 'Not logged in';
    try {
      final result = await _service.sellGold(
        user: user,
        goldAmount: goldAmount,
        eurAmount: eurAmount,
      );
      _ref.read(authProvider.notifier).updateUser(result.updatedUser);
      await load();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<String?> transferGold({
    required String recipientEmail,
    required double goldAmount,
    required double eurValue,
  }) async {
    final user = _ref.read(authProvider).user;
    if (user == null) return 'Not logged in';
    try {
      final result = await _service.transferGold(
        user: user,
        recipientEmail: recipientEmail,
        goldAmount: goldAmount,
        eurValue: eurValue,
      );
      _ref.read(authProvider.notifier).updateUser(result.updatedUser);
      await load();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}

final transactionProvider = StateNotifierProvider<TransactionNotifier, AsyncValue<List<TransactionModel>>>((ref) {
  return TransactionNotifier(ref.read(transactionServiceProvider), ref);
});

// ─── Gold Price ──────────────────────────────────────────────────────────────

class GoldPriceNotifier extends StateNotifier<GoldPriceData> {
  final GoldPriceService _service;

  GoldPriceNotifier(this._service) : super(_service.getMockPriceData()) {
    _refresh();
  }

  Future<void> _refresh() async {
    final data = await _service.getLivePriceData();
    state = data;
  }

  Future<void> refresh() async {
    await _refresh();
  }
}

final goldPriceProvider = StateNotifierProvider<GoldPriceNotifier, GoldPriceData>((ref) {
  return GoldPriceNotifier(ref.read(goldPriceServiceProvider));
});

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.read(storageServiceProvider));
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final StorageService _storage;

  ThemeNotifier(this._storage) : super(ThemeMode.dark) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    state = await _storage.getThemeMode();
  }

  Future<void> toggleTheme() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    await _storage.saveThemeMode(next);
  }
}
