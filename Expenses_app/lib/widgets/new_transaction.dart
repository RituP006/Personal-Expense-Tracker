import './adaptive_flatbuttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addnewtx;

  NewTransaction(this.addnewtx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titlecontroller = TextEditingController();

  final _amountcontroller = TextEditingController();

  DateTime _selectedDate;

  void _submitData() {
    if (_amountcontroller.text.isEmpty) {
      return;
    }

    final enteredtitle = _titlecontroller.text;
    final enteredamount = double.parse(_amountcontroller.text);

    if (enteredtitle.isEmpty || enteredamount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addnewtx(enteredtitle, enteredamount, _selectedDate);

    Navigator.of(context).pop(); //3
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titlecontroller,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountcontroller,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    AdaptiveFlatButton('Choose date', _presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
                child: Text(
                  'Add Transaction',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Note : on onpress of buttons, do not directly pass the function to be executed,
//  wrap it with anonymous function with no arguments.

// to change the keyboard type, use keyboardType:TextInputType.(any static propetry)

// Note: On iOS TextInputType.number might not allow decimal places. Use TextInputType.numberWithOptions(decimal:true).

// Note: The statefull widget and its state class are two different classes, therefore to use the property
// of the widgets we need to prefix them by 'widget.' which gives access to class and its properties.

// 3. Automatically clears the bottom modal once we hit done.

// showDatePicker() - built in method that overlays a date picker on the screen.
// this method returns a future class, which is resolved once user selects the date,
// to handle this we use .then()

// ************* Responsiveness *********

// the softkeyboard setting - we give additional padding at the bottom in modal,
// with respect to viewinsets.bottom
