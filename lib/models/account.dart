class Account {
  final String id;
  final String name;
  double balance; 

  Account({
    required this.id,
    required this.name,
    required this.balance,
  });

  Account copyWith({
    String? id,
    String? name,
    double? balance,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
    );
  }

  String get balanceFormatted => '\$${balance.toStringAsFixed(2)}';
}
