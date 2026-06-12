import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class TransactionService {
  final StorageService _storage;
  static const _uuid = Uuid();

  TransactionService(this._storage);

  Future<List<TransactionModel>> getTransactions() =>
      _storage.getTransactions();

  Future<({UserModel updatedUser, TransactionModel transaction})> buyGold({
    required UserModel user,
    required double eurAmount,
    required double goldAmount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (eurAmount > user.eurBalance) {
      throw Exception('Insufficient EUR balance.');
    }
    if (eurAmount <= 0) {
      throw Exception('Amount must be greater than zero.');
    }

    final transaction = TransactionModel(
      id: _uuid.v4(),
      type: TransactionType.buy,
      goldAmount: goldAmount,
      eurAmount: eurAmount,
      date: DateTime.now(),
      status: TransactionStatus.completed,
    );

    final updatedUser = user.copyWith(
      eurBalance: user.eurBalance - eurAmount,
      goldBalance: user.goldBalance + goldAmount,
    );

    await _storage.saveUser(updatedUser);
    await _storage.addTransaction(transaction);

    return (updatedUser: updatedUser, transaction: transaction);
  }

  Future<({UserModel updatedUser, TransactionModel transaction})> sellGold({
    required UserModel user,
    required double goldAmount,
    required double eurAmount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (goldAmount > user.goldBalance) {
      throw Exception('Insufficient gold balance.');
    }
    if (goldAmount <= 0) {
      throw Exception('Amount must be greater than zero.');
    }

    final transaction = TransactionModel(
      id: _uuid.v4(),
      type: TransactionType.sell,
      goldAmount: goldAmount,
      eurAmount: eurAmount,
      date: DateTime.now(),
      status: TransactionStatus.completed,
    );

    final updatedUser = user.copyWith(
      goldBalance: user.goldBalance - goldAmount,
      eurBalance: user.eurBalance + eurAmount,
    );

    await _storage.saveUser(updatedUser);
    await _storage.addTransaction(transaction);

    return (updatedUser: updatedUser, transaction: transaction);
  }

  Future<({UserModel updatedUser, TransactionModel transaction})> transferGold({
    required UserModel user,
    required String recipientEmail,
    required double goldAmount,
    required double eurValue,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (goldAmount > user.goldBalance) {
      throw Exception('Insufficient gold balance.');
    }
    if (goldAmount <= 0) {
      throw Exception('Amount must be greater than zero.');
    }

    final transaction = TransactionModel(
      id: _uuid.v4(),
      type: TransactionType.transfer,
      goldAmount: goldAmount,
      eurAmount: eurValue,
      date: DateTime.now(),
      status: TransactionStatus.completed,
      recipientEmail: recipientEmail,
    );

    final updatedUser = user.copyWith(
      goldBalance: user.goldBalance - goldAmount,
    );

    await _storage.saveUser(updatedUser);
    await _storage.addTransaction(transaction);

    return (updatedUser: updatedUser, transaction: transaction);
  }
}
