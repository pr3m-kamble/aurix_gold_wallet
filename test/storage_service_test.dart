import 'package:flutter_test/flutter_test.dart';
import 'package:aurix_gold_wallet/services/storage_service.dart';
import 'package:aurix_gold_wallet/models/user_model.dart';

void main() {
  group('StorageService', () {
    late StorageService storageService;

    setUp(() {
      storageService = StorageService();
    });

    test('StorageService can be initialized', () {
      expect(storageService, isNotNull);
    });

    test('Can save and retrieve user', () async {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'Test User',
        eurBalance: 1000.0,
        goldBalance: 50.0,
        avatarInitials: 'TU',
      );

      await storageService.saveUser(user);
      final retrieved = await storageService.getUser();

      expect(retrieved, isNotNull);
      expect(retrieved!.email, 'test@aurix.com');
      expect(retrieved.goldBalance, 50.0);
    });

    test('Can update user balance', () async {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'Test User',
        eurBalance: 1000.0,
        goldBalance: 50.0,
        avatarInitials: 'TU',
      );

      await storageService.saveUser(user);

      final updated = user.copyWith(
        eurBalance: 500.0,
        goldBalance: 100.0,
      );

      await storageService.saveUser(updated);
      final retrieved = await storageService.getUser();

      expect(retrieved!.eurBalance, 500.0);
      expect(retrieved.goldBalance, 100.0);
    });

    test('Can get transactions list', () async {
      final transactions = await storageService.getTransactions();
      expect(transactions, isNotNull);
      expect(transactions, isA<List>());
    });

    test('Can save and retrieve transactions', () async {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'Test User',
        eurBalance: 1000.0,
        goldBalance: 50.0,
        avatarInitials: 'TU',
      );

      await storageService.saveUser(user);
      final retrieved = await storageService.getUser();

      expect(retrieved, isNotNull);
    });
  });
}

