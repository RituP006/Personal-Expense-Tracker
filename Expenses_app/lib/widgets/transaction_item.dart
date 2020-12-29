import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for using dateformat

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deletetx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deletetx;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(child: Text('\$${transaction.amount}')),
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
