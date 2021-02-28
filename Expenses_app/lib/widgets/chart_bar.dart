import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTOtal;

  const ChartBar(this.label, this.spendingAmount, this.spendingPctOfTOtal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                '\$${spendingAmount.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTOtal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ))),
        ],
      );
    });
  }
}

// Stack() - It allows overlapping of widgets above eachother.
// Fittedbox - forces the child to be in original size, preventing them to grow

// ************** Responsiveness ***********
// issue - chartbar occupies hard-coded height which looks either short on large
// devices or large on small devices.

// Solution - use LayoutBuilder(builder: (ctx, constraints){}), it gives us information about the constraints of the widget.

// constraints - it defines how much space a widget takes. all built-in widgets in flutter has default constraints.
// constraints always refer to height and width and are expressed as minimum or maximum height or width.

// It's possible to declare a constructor as const if all its parameter are final, cause that means that instance of constructor can
// never be changed.
// constructor can not be declared as const if it has any non-final parameter.
// chartbar constructor is declared as const above.
