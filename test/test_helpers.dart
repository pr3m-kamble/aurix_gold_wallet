/// Test utilities and constants for Aurix Gold Wallet tests
library test_helpers;

import 'package:aurix_gold_wallet/models/user_model.dart';
import 'package:aurix_gold_wallet/models/transaction_model.dart';
import 'package:aurix_gold_wallet/models/gold_price_model.dart';

/// Mock users for testing
class TestUsers {
  static const demoUser = UserModel(
    id: '1',
    email: 'demo@aurix.com',
    name: 'Demo User',
    eurBalance: 10000.0,
    goldBalance: 100.5,
    avatarInitials: 'DU',
  );

  static const testUser = UserModel(
    id: '2',
    email: 'test@aurix.com',
    name: 'Test User',
    eurBalance: 5000.0,
    goldBalance: 50.0,
    avatarInitials: 'TU',
  );

  static const newUser = UserModel(
    id: '3',
    email: 'newuser@aurix.com',
    name: 'New User',
    eurBalance: 0.0,
    goldBalance: 0.0,
    avatarInitials: 'NU',
  );
}

/// Mock transactions for testing
class TestTransactions {
  static final buyTransaction = TransactionModel(
    id: 'txn_1',
    type: TransactionType.buy,
    goldAmount: 10.0,
    eurAmount: 650.0,
    date: DateTime(2024, 1, 1, 10, 0),
    status: TransactionStatus.completed,
  );

  static final sellTransaction = TransactionModel(
    id: 'txn_2',
    type: TransactionType.sell,
    goldAmount: 5.0,
    eurAmount: 325.0,
    date: DateTime(2024, 1, 2, 10, 0),
    status: TransactionStatus.completed,
  );

  static final transferTransaction = TransactionModel(
    id: 'txn_3',
    type: TransactionType.transfer,
    goldAmount: 2.5,
    eurAmount: 0.0,
    date: DateTime(2024, 1, 3, 10, 0),
    status: TransactionStatus.completed,
    recipientEmail: 'recipient@aurix.com',
  );

  static final pendingTransaction = TransactionModel(
    id: 'txn_4',
    type: TransactionType.buy,
    goldAmount: 5.0,
    eurAmount: 330.0,
    date: DateTime(2024, 1, 4, 10, 0),
    status: TransactionStatus.pending,
  );

  static final receiveTransaction = TransactionModel(
    id: 'txn_5',
    type: TransactionType.receive,
    goldAmount: 3.0,
    eurAmount: 0.0,
    date: DateTime(2024, 1, 5, 10, 0),
    status: TransactionStatus.completed,
    recipientEmail: 'sender@aurix.com',
  );
}

/// Mock gold price data for testing
class TestPriceData {
  static final standardPrice = GoldPriceData(
    currentPrice: 65.50,
    change24h: 0.50,
    changePercent24h: 0.77,
    history: [
      GoldPricePoint(date: DateTime(2024, 1, 1), price: 65.0),
      GoldPricePoint(date: DateTime(2024, 1, 2), price: 65.2),
      GoldPricePoint(date: DateTime(2024, 1, 3), price: 65.5),
    ],
  );

  static final highPrice = GoldPriceData(
    currentPrice: 75.00,
    change24h: 10.00,
    changePercent24h: 15.38,
    history: List.generate(
      30,
      (i) => GoldPricePoint(
        date: DateTime(2024, 1, 1).add(Duration(days: i)),
        price: 65.0 + i * 0.33,
      ),
    ),
  );

  static final lowPrice = GoldPriceData(
    currentPrice: 55.00,
    change24h: -10.00,
    changePercent24h: -15.38,
    history: List.generate(
      30,
      (i) => GoldPricePoint(
        date: DateTime(2024, 1, 1).add(Duration(days: i)),
        price: 65.0 - i * 0.33,
      ),
    ),
  );
}

/// Assertions helper for common test patterns
class TestAssertions {
  /// Assert user data is valid
  static void assertValidUser(UserModel user) {
    assert(user.id.isNotEmpty, 'User ID cannot be empty');
    assert(user.email.isNotEmpty, 'Email cannot be empty');
    assert(user.email.contains('@'), 'Email must be valid');
    assert(user.name.isNotEmpty, 'Name cannot be empty');
    assert(user.eurBalance >= 0, 'EUR balance cannot be negative');
    assert(user.goldBalance >= 0, 'Gold balance cannot be negative');
  }

  /// Assert transaction data is valid
  static void assertValidTransaction(TransactionModel transaction) {
    assert(transaction.id.isNotEmpty, 'Transaction ID cannot be empty');
    assert(transaction.goldAmount > 0, 'Gold amount must be positive');
    assert(
      transaction.eurAmount >= 0,
      'EUR amount cannot be negative',
    );
  }

  /// Assert price data is valid
  static void assertValidPriceData(GoldPriceData priceData) {
    assert(priceData.currentPrice > 0, 'Current price must be positive');
    assert(priceData.history.isNotEmpty, 'History cannot be empty');
    assert(
      priceData.history.every((point) => point.price > 0),
      'All historical prices must be positive',
    );
  }
}
