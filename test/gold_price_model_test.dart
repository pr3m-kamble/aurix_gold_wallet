import 'package:flutter_test/flutter_test.dart';
import 'package:aurix_gold_wallet/models/gold_price_model.dart';

void main() {
  group('GoldPriceModel', () {
    test('GoldPricePoint creation with valid data', () {
      final point = GoldPricePoint(
        date: DateTime(2024, 1, 1),
        price: 65.50,
      );

      expect(point.date, DateTime(2024, 1, 1));
      expect(point.price, 65.50);
    });

    test('GoldPriceData creation with valid data', () {
      final priceData = GoldPriceData(
        currentPrice: 65.50,
        change24h: 0.50,
        changePercent24h: 0.77,
        history: [
          GoldPricePoint(date: DateTime(2024, 1, 1), price: 65.0),
          GoldPricePoint(date: DateTime(2024, 1, 2), price: 65.2),
          GoldPricePoint(date: DateTime(2024, 1, 3), price: 65.5),
        ],
      );

      expect(priceData.currentPrice, 65.50);
      expect(priceData.change24h, 0.50);
      expect(priceData.changePercent24h, 0.77);
      expect(priceData.history.length, 3);
    });

    test('GoldPriceData with negative change', () {
      final priceData = GoldPriceData(
        currentPrice: 64.50,
        change24h: -0.50,
        changePercent24h: -0.77,
        history: [
          GoldPricePoint(date: DateTime(2024, 1, 1), price: 65.0),
          GoldPricePoint(date: DateTime(2024, 1, 2), price: 64.8),
          GoldPricePoint(date: DateTime(2024, 1, 3), price: 64.5),
        ],
      );

      expect(priceData.change24h, -0.50);
      expect(priceData.changePercent24h, -0.77);
    });

    test('GoldPriceData with 30-day history', () {
      final history = List.generate(
        30,
        (i) => GoldPricePoint(
          date: DateTime(2024, 1, 1).add(Duration(days: i)),
          price: 65.0 + i * 0.1,
        ),
      );

      final priceData = GoldPriceData(
        currentPrice: history.last.price,
        change24h: 3.0,
        changePercent24h: 4.62,
        history: history,
      );

      expect(priceData.history.length, 30);
      expect(priceData.history.first.price, 65.0);
      expect(priceData.history.last.price, greaterThan(65.0));
    });

    test('GoldPriceData isPositive getter works', () {
      final positive = GoldPriceData(
        currentPrice: 65.50,
        change24h: 0.50,
        changePercent24h: 0.77,
        history: [
          GoldPricePoint(date: DateTime(2024, 1, 1), price: 65.0),
        ],
      );

      expect(positive.isPositive, true);
    });

    test('GoldPriceData isPositive with negative change', () {
      final negative = GoldPriceData(
        currentPrice: 64.50,
        change24h: -0.50,
        changePercent24h: -0.77,
        history: [
          GoldPricePoint(date: DateTime(2024, 1, 1), price: 65.0),
        ],
      );

      expect(negative.isPositive, false);
    });

    test('GoldPriceData with zero change', () {
      final neutral = GoldPriceData(
        currentPrice: 65.00,
        change24h: 0.0,
        changePercent24h: 0.0,
        history: [
          GoldPricePoint(date: DateTime(2024, 1, 1), price: 65.0),
        ],
      );

      expect(neutral.isPositive, true); // zero is >= 0
      expect(neutral.change24h, 0.0);
      expect(neutral.changePercent24h, 0.0);
    });

    test('Multiple GoldPricePoint dates are different', () {
      final point1 = GoldPricePoint(date: DateTime(2024, 1, 1), price: 65.0);
      final point2 = GoldPricePoint(date: DateTime(2024, 1, 2), price: 65.5);

      expect(point1.date, isNot(point2.date));
      expect(point1.price, lessThan(point2.price));
    });

    test('GoldPriceData percentage change is reasonable', () {
      final priceData = GoldPriceData(
        currentPrice: 65.50,
        change24h: 0.50,
        changePercent24h: 0.77,
        history: [
          GoldPricePoint(date: DateTime(2024, 1, 1), price: 65.0),
        ],
      );

      // Verify percentage is between -5% and 5% (reasonable for 24h change)
      expect(priceData.changePercent24h, greaterThan(-5.0));
      expect(priceData.changePercent24h, lessThan(5.0));
    });
  });
}
