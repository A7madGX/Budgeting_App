import '../db/database_manager.dart';

class Account {
  final int? id;
  final String name;
  final num balance;
  final String cardNumber;
  final String expiryDate;
  final String bankName;
  final String holderName;

  Account({
    this.id,
    required this.name,
    required this.balance,
    required this.cardNumber,
    required this.expiryDate,
    required this.bankName,
    required this.holderName,
  });

  Map<String, dynamic> toMap() {
    return {
      AccountTable.id: id,
      AccountTable.name: name,
      AccountTable.balance: balance,
      AccountTable.cardNumber: cardNumber,
      AccountTable.expiryDate: expiryDate,
      AccountTable.bankName: bankName,
      AccountTable.holderName: holderName,
    };
  }

  // Create Account from Map
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map[AccountTable.id] as int?,
      name: map[AccountTable.name] as String,
      balance: map[AccountTable.balance] as num,
      cardNumber: map[AccountTable.cardNumber] as String,
      expiryDate: map[AccountTable.expiryDate] as String,
      bankName: map[AccountTable.bankName] as String,
      holderName: map[AccountTable.holderName] as String,
    );
  }

  // Create copy of Account with optional new values
  Account copyWith({
    int? id,
    String? name,
    num? balance,
    String? cardNumber,
    String? expiryDate,
    String? bankName,
    String? holderName,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      bankName: bankName ?? this.bankName,
      holderName: holderName ?? this.holderName,
    );
  }
}
