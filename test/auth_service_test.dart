import 'package:flutter_test/flutter_test.dart';
import 'package:aurix_gold_wallet/services/auth_service.dart';
import 'package:aurix_gold_wallet/services/storage_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    late StorageService storageService;

    setUp(() {
      storageService = StorageService();
      authService = AuthService(storageService);
    });

    test('AuthService can be initialized with StorageService', () {
      expect(authService, isNotNull);
    });

    test('Login with valid credentials returns user', () async {
      final user = await authService.login(
        email: 'test@aurix.com',
        password: 'password123',
      );

      expect(user, isNotNull);
      expect(user.email, 'test@aurix.com');
      expect(user.id, isNotEmpty);
      expect(user.goldBalance, greaterThan(0));
      expect(user.eurBalance, greaterThan(0));
    });

    test('Login with short password throws exception', () async {
      expect(
        () => authService.login(
          email: 'test@aurix.com',
          password: 'short',
        ),
        throwsException,
      );
    });

    test('Register with valid data returns user', () async {
      final user = await authService.register(
        email: 'newuser@aurix.com',
        password: 'password123',
        name: 'New User',
      );

      expect(user, isNotNull);
      expect(user.email, 'newuser@aurix.com');
      expect(user.name, 'New User');
      expect(user.avatarInitials, isNotEmpty);
    });

    test('Logout completes without error', () async {
      await authService.logout();
      expect(true, true); // Logout should complete
    });

    test('Login can be called multiple times', () async {
      final user1 = await authService.login(
        email: 'test1@aurix.com',
        password: 'password123',
      );

      final user2 = await authService.login(
        email: 'test2@aurix.com',
        password: 'password123',
      );

      expect(user1.email, 'test1@aurix.com');
      expect(user2.email, 'test2@aurix.com');
    });

    test('User email is stored after login', () async {
      final user = await authService.login(
        email: 'stored@aurix.com',
        password: 'password123',
      );

      final storedUser = await storageService.getUser();
      expect(storedUser!.email, user.email);
    });
  });
}
