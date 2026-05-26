class BudgetEntry {
  final String id;
  final String title;
  final double amount;
  final String type; // 'income' | 'expense'
  final DateTime date;
  final String category;

  BudgetEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  factory BudgetEntry.fromMap(Map<String, dynamic> map, String id) {
    return BudgetEntry(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? 'expense',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      category: map['category'] ?? 'General',
    );
  }
}
