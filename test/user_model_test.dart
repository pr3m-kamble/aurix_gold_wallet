import 'package:flutter_test/flutter_test.dart';
import 'package:aurix_gold_wallet/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('User creation with valid data', () {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'John Doe',
        eurBalance: 10000.0,
        goldBalance: 100.5,
        avatarInitials: 'JD',
      );

      expect(user.id, '1');
      expect(user.email, 'test@aurix.com');
      expect(user.name, 'John Doe');
      expect(user.eurBalance, 10000.0);
      expect(user.goldBalance, 100.5);
    });

    test('User toJson returns correct map', () {
      final user = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'John Doe',
        eurBalance: 10000.0,
        goldBalance: 100.5,
        avatarInitials: 'JD',
      );

      final json = user.toJson();

      expect(json['id'], '1');
      expect(json['email'], 'test@aurix.com');
      expect(json['name'], 'John Doe');
      expect(json['eurBalance'], 10000.0);
      expect(json['goldBalance'], 100.5);
    });

    test('User fromJson creates instance correctly', () {
      final json = {
        'id': '1',
        'email': 'test@aurix.com',
        'name': 'John Doe',
        'eurBalance': 10000.0,
        'goldBalance': 100.5,
        'avatarInitials': 'JD',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, '1');
      expect(user.email, 'test@aurix.com');
      expect(user.name, 'John Doe');
      expect(user.eurBalance, 10000.0);
      expect(user.goldBalance, 100.5);
    });

    test('User with zero balances is valid', () {
      final user = UserModel(
        id: '2',
        email: 'empty@aurix.com',
        name: 'Empty User',
        eurBalance: 0.0,
        goldBalance: 0.0,
        avatarInitials: 'EU',
      );

      expect(user.eurBalance, 0.0);
      expect(user.goldBalance, 0.0);
    });

    test('User copy method works correctly', () {
      final user1 = UserModel(
        id: '1',
        email: 'test@aurix.com',
        name: 'John Doe',
        eurBalance: 10000.0,
        goldBalance: 100.5,
        avatarInitials: 'JD',
      );

      final user2 = user1.copyWith(eurBalance: 5000.0);

      expect(user2.eurBalance, 5000.0);
      expect(user2.goldBalance, 100.5); // unchanged
      expect(user1.eurBalance, 10000.0); // original unchanged
    });
  });
}
