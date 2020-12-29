import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deletetx;

  TransactionList(this.transactions, this.deletetx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No Transactions',
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/img2.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(
                  transaction: transactions[index], deletetx: deletetx);
            },
            itemCount: transactions.length,
          );
  }
}

// ******** Custom List Items *******************
// return Card(
//   child: Row(
//     children: <Widget>[
//       Container(
//           margin: EdgeInsets.symmetric(
//             vertical: 10,
//             horizontal: 15,
//           ),
//           decoration: BoxDecoration(
//               border: Border.all(
//             color: Theme.of(context).primaryColor,
//             width: 2,
//           )),
//           padding: EdgeInsets.all(10),
//           child: Text(
//             '\$${transactions[index].amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Theme.of(context).primaryColor,
//             ),
//           )),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//               margin: EdgeInsets.only(bottom: 5),
//               child: Text(transactions[index].title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ))),
//           Text(
//               DateFormat.yMMMd()
//                   .format(transactions[index].date),
//               style: TextStyle(
//                 color: Colors.grey,
//               ))
//         ],
//       )
//     ],
//   ),
// );

// ListView gives a scrollable column or scrollable row on the basis of direction given to it.
// default is vertical i.e scrollable column.
// it has an infinite height, since it's scrollable, therefore it needs a defined height.

//  there are two ways to use List view
//  ListView(children:[]) - It renders all widgets that are part of list view initially, even if they are beyond viewport,
//  it's better for short lists but can give performance issues for larges lists.
//  ListView.builder() - It only renders the widgets that are visible. the parts that are outside viewport are not
//  loaded or rendered it builds them as we go on scrolling. It takes an itemBuilder argument which is a function, and is
//  called by flutter everytime it renders new list widget. It also takes an argument called itemCount instead of children,
//  the length of the list is passed as an value to this item.

// SizedBox Widget - it can be used ro separate widgets, by providing only height
// or width with no contents.

// Instead of styling your own list items, ListTile() widget can be used which
// has some predefined list styling.
// It takes an 'leading' argument, which takes the widget that needs to position
//  at the beginning of list tile.

// CircleAvatar() - bounds the content in acircle of user-defined radius.

// ************* Responsiveness *****
// added text with icon for list item width more than 460, by using mediaquery
// FlatButton.icon - allows to add text with icon.
