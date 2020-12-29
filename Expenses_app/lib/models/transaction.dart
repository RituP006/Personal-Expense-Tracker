import 'package:flutter/foundation.dart';

class Transaction {
  final String id; // the values won't change once its created
  final String title;
  final double amount;
  final DateTime date;

  Transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});
}

// note : @required decorator is not a dart feature, it's provided by Flutter.
