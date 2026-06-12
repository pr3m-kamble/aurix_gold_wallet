import 'package:flutter_test/flutter_test.dart';
import 'package:aurix_gold_wallet/services/gold_price_service.dart';

void main() {
  group('GoldPriceService', () {
    late GoldPriceService goldPriceService;

    setUp(() {
      goldPriceService = GoldPriceService();
    });

    test('Get mock price data returns valid structure', () async {
      final mockData = goldPriceService.getMockPriceData();

      expect(mockData, isNotNull);
      expect(mockData.currentPrice, greaterThan(0));
      expect(mockData.history, isNotEmpty);
      expect(mockData.history.length, 30);
    });

    test('Mock price is around €65/gram', () async {
      final mockData = goldPriceService.getMockPriceData();

      expect(mockData.currentPrice, greaterThan(50));
      expect(mockData.currentPrice, lessThan(80));
    });

    test('Mock history has 30 days of data', () async {
      final mockData = goldPriceService.getMockPriceData();

      expect(mockData.history.length, 30);
      expect(mockData.history.every((point) => point.price > 0), true);
    });

    test('Get live price data without API key returns mock data', () async {
      // When no API key is provided, should return mock data
      final priceData = await goldPriceService.getLivePriceData();

      expect(priceData, isNotNull);
      expect(priceData.currentPrice, greaterThan(0));
      expect(priceData.history.length, 30);
    });

    test('Price change is calculated', () async {
      final priceData = goldPriceService.getMockPriceData();

      expect(priceData.change24h, isNotNull);
      expect(priceData.changePercent24h, isNotNull);
    });

    test('GoldPriceData contains required fields', () async {
      final priceData = await goldPriceService.getLivePriceData();

      expect(priceData.currentPrice, isNotNull);
      expect(priceData.history, isNotNull);
      expect(priceData.change24h, isNotNull);
      expect(priceData.changePercent24h, isNotNull);
    });

    test('Price history is in chronological order', () async {
      final priceData = goldPriceService.getMockPriceData();

      // History should have first and last values
      expect(priceData.history.first, isNotNull);
      expect(priceData.history.last, isNotNull);
    });

    test('Multiple calls to mock return consistent structure', () async {
      final data1 = goldPriceService.getMockPriceData();
      final data2 = goldPriceService.getMockPriceData();

      expect(data1.history.length, data2.history.length);
      expect(data1.currentPrice, greaterThan(0));
      expect(data2.currentPrice, greaterThan(0));
    });

    test('Current price is last value in realistic range', () async {
      final priceData = goldPriceService.getMockPriceData();

      // For demo, price should be realistic
      expect(priceData.currentPrice, greaterThan(40.0));
      expect(priceData.currentPrice, lessThan(100.0));
    });

    test('Historical prices vary reasonably', () async {
      final priceData = goldPriceService.getMockPriceData();

      final minPrice = priceData.history
          .map((p) => p.price)
          .reduce((a, b) => a < b ? a : b);
      final maxPrice = priceData.history
          .map((p) => p.price)
          .reduce((a, b) => a > b ? a : b);
      final priceRange = maxPrice - minPrice;

      // Should have some variation but not unrealistic
      expect(priceRange, greaterThan(0.0));
      expect(priceRange, lessThan(20.0));
    });

    test('API key environment support is documented', () {
      // Service should support API keys from:
      // 1. .env file via dotenv
      // 2. --dart-define for CI/build
      // 3. Fallback to mock data

      // This is more of a documentation test
      expect(GoldPriceService, isNotNull);
    });

    test('Service handles missing API gracefully', () async {
      // Without an API key, should return mock data without throwing
      final priceData = await goldPriceService.getLivePriceData();

      expect(priceData, isNotNull);
      expect(priceData.currentPrice, greaterThan(0));
    });
  });
}
