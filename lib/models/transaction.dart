class Transaction {
  final String id;
  final String description;
  final String category;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String? productName;

  Transaction({
    required this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.productName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'category': category,
        'amount': amount,
        'isIncome': isIncome ? 1 : 0,
        'date': date.millisecondsSinceEpoch,
        'productName': productName,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        description: json['description'],
        category: json['category'],
        amount: json['amount'],
        isIncome: json['isIncome'] == 1,
        date: json['date'] is String
            ? DateTime.parse(json['date'])
            : DateTime.fromMillisecondsSinceEpoch(json['date']),
        productName: json['productName'],
      );
}
