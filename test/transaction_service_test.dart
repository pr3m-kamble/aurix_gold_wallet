import 'package:flutter_test/flutter_test.dart';
import 'package:aurix_gold_wallet/services/transaction_service.dart';
import 'package:aurix_gold_wallet/services/storage_service.dart';
import 'package:aurix_gold_wallet/models/transaction_model.dart';
import 'package:aurix_gold_wallet/models/user_model.dart';

void main() {
  group('TransactionService', () {
    late TransactionService transactionService;
    late StorageService storageService;

    setUp(() {
      storageService = StorageService();
      transactionService = TransactionService(storageService);
    });

    test('TransactionService can be initialized', () {
      expect(transactionService, isNotNull);
    });

    test('Buy gold transaction returns updated user and transaction', () async {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'Test User',
        eurBalance: 1000.0,
        goldBalance: 10.0,
        avatarInitials: 'TU',
      );

      final result = await transactionService.buyGold(
        user: user,
        eurAmount: 650.0,
        goldAmount: 10.0,
      );

      expect(result.transaction, isNotNull);
      expect(result.transaction.type, TransactionType.buy);
      expect(result.transaction.goldAmount, 10.0);
      expect(result.transaction.eurAmount, 650.0);
      expect(result.updatedUser, isNotNull);
      expect(result.updatedUser.eurBalance, 350.0);
    });

    test('Sell gold transaction returns updated user and transaction', () async {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'Test User',
        eurBalance: 1000.0,
        goldBalance: 20.0,
        avatarInitials: 'TU',
      );

      final result = await transactionService.sellGold(
        user: user,
        goldAmount: 5.0,
        eurAmount: 325.0,
      );

      expect(result.transaction, isNotNull);
      expect(result.transaction.type, TransactionType.sell);
      expect(result.transaction.goldAmount, 5.0);
      expect(result.updatedUser, isNotNull);
      expect(result.updatedUser.eurBalance, 1325.0);
      expect(result.updatedUser.goldBalance, 15.0);
    });

    test('Transfer gold transaction returns transaction', () async {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'Test User',
        eurBalance: 1000.0,
        goldBalance: 20.0,
        avatarInitials: 'TU',
      );

      final result = await transactionService.transferGold(
        user: user,
        goldAmount: 2.5,
        recipientEmail: 'recipient@aurix.com',
        eurValue: 0.0,
      );

      expect(result.transaction, isNotNull);
      expect(result.transaction.type, TransactionType.transfer);
      expect(result.transaction.goldAmount, 2.5);
      expect(result.updatedUser.goldBalance, 17.5);
    });

    test('Get all transactions returns list', () async {
      final transactions = await transactionService.getTransactions();
      expect(transactions, isNotNull);
    });

    test('Buy with insufficient balance throws exception', () async {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'Test User',
        eurBalance: 100.0,
        goldBalance: 10.0,
        avatarInitials: 'TU',
      );

      expect(
        () => transactionService.buyGold(
          user: user,
          eurAmount: 500.0,
          goldAmount: 10.0,
        ),
        throwsException,
      );
    });

    test('Sell with insufficient gold throws exception', () async {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'Test User',
        eurBalance: 1000.0,
        goldBalance: 5.0,
        avatarInitials: 'TU',
      );

      expect(
        () => transactionService.sellGold(
          user: user,
          goldAmount: 20.0,
          eurAmount: 1300.0,
        ),
        throwsException,
      );
    });

    test('Buy with zero amount throws exception', () async {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'Test User',
        eurBalance: 1000.0,
        goldBalance: 10.0,
        avatarInitials: 'TU',
      );

      expect(
        () => transactionService.buyGold(
          user: user,
          eurAmount: 0.0,
          goldAmount: 0.0,
        ),
        throwsException,
      );
    });
  });
}

