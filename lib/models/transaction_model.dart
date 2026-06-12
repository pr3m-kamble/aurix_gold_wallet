enum TransactionType { buy, sell, transfer, receive }
enum TransactionStatus { pending, completed, failed }

class TransactionModel {
  final String id;
  final TransactionType type;
  final double goldAmount; // in grams
  final double eurAmount;
  final DateTime date;
  final TransactionStatus status;
  final String? recipientEmail;
  final String? note;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.goldAmount,
    required this.eurAmount,
    required this.date,
    required this.status,
    this.recipientEmail,
    this.note,
  });

  String get typeLabel {
    switch (type) {
      case TransactionType.buy:
        return 'Bought Gold';
      case TransactionType.sell:
        return 'Sold Gold';
      case TransactionType.transfer:
        return 'Sent Gold';
      case TransactionType.receive:
        return 'Received Gold';
    }
  }

  String get statusLabel {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  bool get isCredit =>
      type == TransactionType.buy || type == TransactionType.receive;
  bool get isDebit =>
      type == TransactionType.sell || type == TransactionType.transfer;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'goldAmount': goldAmount,
        'eurAmount': eurAmount,
        'date': date.toIso8601String(),
        'status': status.index,
        'recipientEmail': recipientEmail,
        'note': note,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] as String,
        type: TransactionType.values[json['type'] as int],
        goldAmount: (json['goldAmount'] as num).toDouble(),
        eurAmount: (json['eurAmount'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        status: TransactionStatus.values[json['status'] as int],
        recipientEmail: json['recipientEmail'] as String?,
        note: json['note'] as String?,
      );
}
