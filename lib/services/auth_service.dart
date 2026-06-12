import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storage;
  static const _uuid = Uuid();

  AuthService(this._storage);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock validation
    if (password.length < 6) {
      throw Exception('Invalid credentials. Please try again.');
    }

    final name = email.split('@').first;
    final formattedName = name[0].toUpperCase() + name.substring(1);
    final initials = formattedName.length >= 2
        ? '${formattedName[0]}${formattedName[1]}'.toUpperCase()
        : formattedName[0].toUpperCase();

    final user = UserModel(
      id: _uuid.v4(),
      name: formattedName,
      email: email,
      goldBalance: 12.457,
      eurBalance: 2850.00,
      avatarInitials: initials,
    );

    await _storage.saveUser(user);
    await _storage.setLoggedIn(true);
    await _seedTransactions(user.id);

    return user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1400));

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }

    final initials = name.trim().split(' ').length >= 2
        ? '${name.trim().split(' ')[0][0]}${name.trim().split(' ')[1][0]}'.toUpperCase()
        : name.trim().substring(0, name.trim().length >= 2 ? 2 : 1).toUpperCase();

    final user = UserModel(
      id: _uuid.v4(),
      name: name.trim(),
      email: email.trim(),
      goldBalance: 0.0,
      eurBalance: 500.0,
      avatarInitials: initials,
    );

    await _storage.saveUser(user);
    await _storage.setLoggedIn(true);

    return user;
  }

  Future<void> logout() async {
    await _storage.logout();
  }

  Future<bool> isLoggedIn() => _storage.isLoggedIn();
  Future<UserModel?> getCurrentUser() => _storage.getUser();

  Future<void> _seedTransactions(String userId) async {
    final now = DateTime.now();
    final seeded = [
      TransactionModel(
        id: _uuid.v4(),
        type: TransactionType.buy,
        goldAmount: 5.0,
        eurAmount: 325.0,
        date: now.subtract(const Duration(days: 2)),
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: _uuid.v4(),
        type: TransactionType.buy,
        goldAmount: 3.457,
        eurAmount: 224.7,
        date: now.subtract(const Duration(days: 5)),
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: _uuid.v4(),
        type: TransactionType.sell,
        goldAmount: 1.0,
        eurAmount: 65.0,
        date: now.subtract(const Duration(days: 8)),
        status: TransactionStatus.completed,
      ),
      TransactionModel(
        id: _uuid.v4(),
        type: TransactionType.receive,
        goldAmount: 2.0,
        eurAmount: 130.0,
        date: now.subtract(const Duration(days: 12)),
        status: TransactionStatus.completed,
        recipientEmail: 'sender@aurix.com',
      ),
      TransactionModel(
        id: _uuid.v4(),
        type: TransactionType.transfer,
        goldAmount: 0.5,
        eurAmount: 32.5,
        date: now.subtract(const Duration(days: 15)),
        status: TransactionStatus.completed,
        recipientEmail: 'alice@aurix.com',
      ),
      TransactionModel(
        id: _uuid.v4(),
        type: TransactionType.buy,
        goldAmount: 3.5,
        eurAmount: 227.5,
        date: now.subtract(const Duration(days: 20)),
        status: TransactionStatus.completed,
      ),
    ];
    await _storage.saveTransactions(seeded);
  }
}
