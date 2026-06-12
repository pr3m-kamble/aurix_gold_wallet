import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/gold_price_model.dart';

class GoldPriceService {
  static String get _apiKey {
    final env = dotenv.isInitialized ? dotenv.env : null;
    return env?['GOLDAPI_KEY']?.trim() ??
        const String.fromEnvironment('GOLDAPI_KEY', defaultValue: '');
  }

  static const String _baseUrl = 'https://www.goldapi.io/api';
  static const double basePrice = 65.0; // EUR per gram

  /// Returns live gold price data. If no API key is available, this falls back
  /// to mock data.
  Future<GoldPriceData> getLivePriceData() async {
    if (_apiKey.isEmpty) {
      return getMockPriceData();
    }

    try {
      return await fetchLivePriceData();
    } catch (_) {
      return getMockPriceData();
    }
  }

  Future<GoldPriceData> fetchLivePriceData() async {
    final uri = Uri.parse('$_baseUrl/XAU/EUR');
    final headers = <String, String>{
      'accept': 'application/json',
      'x-access-token': _apiKey,
    };

    final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('GoldAPI request failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final currentPrice = _parsePricePerGram(data);
    final change = _parseChange(data, currentPrice);
    final changePercent = _parseChangePercent(data, currentPrice);
    final history = _generateHistoryAroundPrice(currentPrice);

    return GoldPriceData(
      currentPrice: currentPrice,
      change24h: change,
      changePercent24h: changePercent,
      history: history,
    );
  }

  double _parsePricePerGram(Map<String, dynamic> data) {
    final priceGram24k = _readDouble(data['price_gram_24k']);
    if (priceGram24k != null && priceGram24k > 0) {
      return priceGram24k;
    }

    final priceOunce = _readDouble(data['price']);
    if (priceOunce != null && priceOunce > 0) {
      return priceOunce / 31.1034768;
    }

    throw Exception('GoldAPI response did not return a usable price.');
  }

  double _parseChange(Map<String, dynamic> data, double currentPrice) {
    final rawChange = _readDouble(data['change']);
    if (rawChange != null) return rawChange;

    final priceOpen = _readDouble(data['price_open']);
    if (priceOpen != null) {
      return currentPrice - priceOpen / 31.1034768;
    }

    return 0.0;
  }

  double _parseChangePercent(Map<String, dynamic> data, double currentPrice) {
    final rawPercent = _readDouble(data['change_percent']);
    if (rawPercent != null) return rawPercent;

    final priceOpen = _readDouble(data['price_open']);
    if (priceOpen != null && priceOpen > 0) {
      final openGram = priceOpen / 31.1034768;
      return ((currentPrice - openGram) / openGram) * 100;
    }

    return 0.0;
  }

  double? _readDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  GoldPriceData getMockPriceData() {
    final random = Random(DateTime.now().day); // seeded by day for consistency
    final history = _generateHistory(random);
    final change = history.last.price - history[history.length - 2].price;
    final changePercent = (change / history[history.length - 2].price) * 100;

    return GoldPriceData(
      currentPrice: history.last.price,
      change24h: change,
      changePercent24h: changePercent,
      history: history,
    );
  }

  List<GoldPricePoint> _generateHistory(Random random) {
    final points = <GoldPricePoint>[];
    double price = basePrice;
    final now = DateTime.now();

    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final delta = (random.nextDouble() - 0.48) * 1.2;
      price = (price + delta).clamp(58.0, 72.0);
      points.add(GoldPricePoint(date: date, price: double.parse(price.toStringAsFixed(2))));
    }

    return points;
  }

  List<GoldPricePoint> _generateHistoryAroundPrice(double currentPrice) {
    final random = Random(DateTime.now().day);
    final points = <GoldPricePoint>[];
    double price = currentPrice;
    final now = DateTime.now();

    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final delta = (random.nextDouble() - 0.48) * (currentPrice * 0.01);
      price = (price + delta).clamp(currentPrice * 0.85, currentPrice * 1.15);
      points.add(GoldPricePoint(date: date, price: double.parse(price.toStringAsFixed(2))));
    }

    return points;
  }

  double calculateGoldFromEur(double eurAmount, double pricePerGram) {
    if (pricePerGram == 0) return 0;
    return eurAmount / pricePerGram;
  }

  double calculateEurFromGold(double goldGrams, double pricePerGram) {
    return goldGrams * pricePerGram;
  }
}
