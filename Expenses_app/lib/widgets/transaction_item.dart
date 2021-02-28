import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for using dateformat

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deletetx,
    @required this.randomNumber,
  }) : super(key: key);

  final Transaction transaction;
  final Function deletetx;
  final int randomNumber;

  final List<Color> colorpick = [
    Colors.pink.shade200,
    Colors.red.shade200,
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.green.shade200
  ];
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorpick[randomNumber],
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
                child: Text(
              '\$${transaction.amount}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
        ),
        title: Text(
          transaction.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: TextStyle(color: Colors.deepPurple),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () {
                  deletetx(transaction.id);
                },
                icon: const Icon(Icons.delete),
                label: const Text(
                    // to improve performance we can skip the rebuilding of this widget on every build call, by declaring it const
                    'DEL'),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  deletetx(transaction.id);
                },
              ),
      ),
    );
  }
}
