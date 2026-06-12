class GoldPricePoint {
  final DateTime date;
  final double price; // EUR per gram

  const GoldPricePoint({required this.date, required this.price});
}

class GoldPriceData {
  final double currentPrice;
  final double change24h;
  final double changePercent24h;
  final List<GoldPricePoint> history;

  const GoldPriceData({
    required this.currentPrice,
    required this.change24h,
    required this.changePercent24h,
    required this.history,
  });

  bool get isPositive => change24h >= 0;
}
