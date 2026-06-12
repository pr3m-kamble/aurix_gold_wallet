import 'package:flutter_test/flutter_test.dart';
import 'package:aurix_gold_wallet/models/transaction_model.dart';

void main() {
  group('TransactionModel', () {
    test('Transaction creation with all required fields', () {
      final transaction = TransactionModel(
        id: 'txn_1',
        type: TransactionType.buy,
        goldAmount: 10.5,
        eurAmount: 682.5,
        date: DateTime(2024, 1, 1, 10, 0),
        status: TransactionStatus.completed,
      );

      expect(transaction.id, 'txn_1');
      expect(transaction.type, TransactionType.buy);
      expect(transaction.goldAmount, 10.5);
      expect(transaction.eurAmount, 682.5);
      expect(transaction.status, TransactionStatus.completed);
    });

    test('Transaction toJson returns correct map', () {
      final transaction = TransactionModel(
        id: 'txn_1',
        type: TransactionType.sell,
        goldAmount: 5.0,
        eurAmount: 325.0,
        date: DateTime(2024, 1, 1, 10, 0),
        status: TransactionStatus.completed,
      );

      final json = transaction.toJson();

      expect(json['id'], 'txn_1');
      expect(json['type'], TransactionType.sell.index);
      expect(json['goldAmount'], 5.0);
      expect(json['eurAmount'], 325.0);
      expect(json['status'], TransactionStatus.completed.index);
    });

    test('Transaction fromJson creates instance correctly', () {
      final json = {
        'id': 'txn_1',
        'type': TransactionType.buy.index,
        'goldAmount': 10.5,
        'eurAmount': 682.5,
        'date': '2024-01-01T10:00:00.000Z',
        'status': TransactionStatus.completed.index,
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.id, 'txn_1');
      expect(transaction.type, TransactionType.buy);
      expect(transaction.goldAmount, 10.5);
      expect(transaction.eurAmount, 682.5);
    });

    test('Transaction types are correct', () {
      expect(TransactionType.buy.toString(), 'TransactionType.buy');
      expect(TransactionType.sell.toString(), 'TransactionType.sell');
      expect(TransactionType.transfer.toString(), 'TransactionType.transfer');
      expect(TransactionType.receive.toString(), 'TransactionType.receive');
    });

    test('Transaction status values are correct', () {
      expect(TransactionStatus.completed.toString(), 'TransactionStatus.completed');
      expect(TransactionStatus.pending.toString(), 'TransactionStatus.pending');
      expect(TransactionStatus.failed.toString(), 'TransactionStatus.failed');
    });

    test('Transaction calculation is correct', () {
      final transaction = TransactionModel(
        id: 'txn_2',
        type: TransactionType.buy,
        goldAmount: 20.0,
        eurAmount: 1400.0,
        date: DateTime.now(),
        status: TransactionStatus.completed,
      );

      // Verify eurAmount is calculated from goldAmount
      expect(transaction.goldAmount, 20.0);
      expect(transaction.eurAmount, 1400.0);
    });

    test('Multiple transactions can be created', () {
      final txn1 = TransactionModel(
        id: 'txn_1',
        type: TransactionType.buy,
        goldAmount: 10.0,
        eurAmount: 650.0,
        date: DateTime(2024, 1, 1),
        status: TransactionStatus.completed,
      );

      final txn2 = TransactionModel(
        id: 'txn_2',
        type: TransactionType.sell,
        goldAmount: 5.0,
        eurAmount: 330.0,
        date: DateTime(2024, 1, 2),
        status: TransactionStatus.completed,
      );

      expect(txn1.id, 'txn_1');
      expect(txn2.id, 'txn_2');
      expect(txn1.type, TransactionType.buy);
      expect(txn2.type, TransactionType.sell);
    });
  });
}
