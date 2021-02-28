import 'dart:io'; // allows to check platform

import 'package:flutter/cupertino.dart'; // for iOS style widgets
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';

void main() {
  // way to disable landscape mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Map<int, Color> colorMap = {
    50: Color.fromRGBO(42, 54, 59, 0.1),
    100: Color.fromRGBO(42, 54, 59, 0.2),
    200: Color.fromRGBO(42, 54, 59, 0.3),
    300: Color.fromRGBO(42, 54, 59, 0.4),
    400: Color.fromRGBO(42, 54, 59, 0.5),
    500: Color.fromRGBO(42, 54, 59, 0.6),
    600: Color.fromRGBO(42, 54, 59, 0.7),
    700: Color.fromRGBO(42, 54, 59, 0.8),
    800: Color.fromRGBO(42, 54, 59, 0.9),
    900: Color.fromRGBO(42, 54, 59, 1.0),
  };

  static const MaterialColor _2A3638 = MaterialColor(0xFF2A363B, colorMap);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp(
            title: 'Personal Expenses',
            debugShowCheckedModeBanner: false,
            theme: CupertinoThemeData(
                primaryColor: _2A3638,
                primaryContrastingColor: Colors.white,
                textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(fontFamily: 'Quicksand'),
                )),
            home: MyHomePage(),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Personal Expenses',
            theme: ThemeData(
              primarySwatch: _2A3638,
              // accentColor: Colors.amber,
              fontFamily: 'Quicksand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    button: TextStyle(
                      color: Colors.white,
                    ),
                  ),
            ),
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // )
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(
        this); // tells flutter to initiate the observer in the same class
    super.initState();
  }

  @override // to Listen states of app
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose(); // calling dispose method of extended class
  }

  bool _showchart = false;

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
      String txtitle, double txAmount, DateTime chosendate) {
    final newtx = Transaction(
      id: DateTime.now().toString(),
      title: txtitle,
      amount: txAmount,
      date: chosendate,
    );

    setState(() {
      _userTransaction.add(newtx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaquery, AppBar appBar, Widget txlistwidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show chart'),
          Switch.adaptive(
              //adaptive constructor will generate switch according to platform
              activeColor: Theme.of(context).accentColor,
              value: _showchart,
              onChanged: (val) {
                setState(() {
                  _showchart = val;
                });
              })
        ],
      ),
      _showchart
          ? Container(
              height: (mediaquery.size.height -
                      appBar.preferredSize.height -
                      mediaquery.padding.top) *
                  0.7,
              child: Chart(_recentTransaction))
          : txlistwidget,
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaquery, AppBar appBar, Widget txlistwidget) {
    return [
      Container(
        color: Theme.of(context).primaryColor,
        height: (mediaquery.size.height -
                appBar.preferredSize.height -
                mediaquery.padding.top) *
            0.4,
        child: Chart(_recentTransaction),
      ),
      txlistwidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    // find the device orientation
    final islandscape = mediaquery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              // title
              'Personal Expenses',
              style: TextStyle(fontFamily: 'Open Sans'),
            ),
            trailing: Row(
                mainAxisSize: MainAxisSize
                    .min, //restricts the row size to minimum (only as big as its children need to be)
                children: <Widget>[
                  GestureDetector(
                    child: Icon(CupertinoIcons.add),
                    onTap: () => _startAddNewTransaction(context),
                  )
                ]),
          )
        : AppBar(
            leading: IconButton(
              icon: const Icon(Icons.short_text),
              onPressed: () {},
            ),
            centerTitle: true,
            elevation: 0,
            title: Text(
              'Personal Expenses',
              style: TextStyle(fontFamily: 'Open Sans'),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _startAddNewTransaction(context))
            ],
          );

    final txlistwidget = Container(
      height: (mediaquery.size.height -
              appBar.preferredSize.height -
              mediaquery.padding.top) *
          0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!islandscape)
            ..._buildPortraitContent(mediaquery, appBar, txlistwidget),
          if (islandscape)
            ..._buildLandscapeContent(mediaquery, appBar, txlistwidget),
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS //checks if its iOs Platform
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}

// NOte : body can take only one widget, therefore we create widget tree.
// Note : if statement can be used in lists, without curly braces. Its a feature of dart.
// Note : If you use MediaQuery.of(context) in several places, store it in variable and use thus improving the performance.
// Note : if you assign a list of widget or a function returning a list of widget to a  widget defined as list of widgets,
//        use spread operator, cause widget defined as list does not take list as its element.

// Size of the card depends on the size of it's child, unless it has parent with clearly defined width.
// size of Text dpends on its parent widget.
// to break this dependencies we can use Container as parent of text.
// the value, double.infinity of width indicates as wide as possible.

// row : main axis is from left to right and crossaxis is top to bottom.
// column : main axis is from top to bottom and crossaxis from left to right.

// use tostring() to convert numbers, double or any object into string.
//  difference between:
//                     containers                                  row/column widgets.
//         1. takes exactly one child widgets          1.Takes multiple (unlimited) child widgets
//         2. rich allignment & styling options        2.Alignment but no styling optiions
//            like Boxdecoration.
//         3. flexible width(eg. child width,          3.always take full available height in case
//            available width)                            of columns and width in row.
//         4. perfect for custom styling & Align-      4.use if widget sit next to/ above each other
//            ment.

// String Interpolation in dart is like template string is javascript but with different syntax :
//  'whatevwer string ${variable}'  // only difference is here you can use normal quotes.

// to give the scrolling effect  we use SingleChildScrollView(), which will give scrolling to entire page and
// can be used as body element only, i.e cannot be used in between.

// context - its an object that has a lot of metadata about the widget.

// adding atheme - use theme property in my app and set ThemeData().
// primarySwatch sets allthe shades of colour, primary color picks only one defined color
// accentColor - it defines an second theme color.

// ****** REsponsiveness ******

// 1. Scrollable issue
// Isuue - In landscape mode, when we scroll list, there's no way to scroll the entire page back this is due
// hard-coded height of the container in the transaction list.

// Solution - Instead of setting a hard-coded height, we need to calculate the available height dynamically
// and distribute it to the chart and list.

// way to solve - use MediaQuery class provided by flutter material package.
// 1. height: MediaQuery.of(context)  - it connects with device and widgets configuration using all the metadata
// provided by context object.
// 2. height: MediaQuery.of(context).size.height - gives the overall height of the device
// 3. height: MediaQuery.of(context).size.height * 0.6 - This sets the height to the 60% of the total device height.
// calculate the appBar size -> storing appbar in variable -> calculating its height -> deduct from total height ->
// MediaQuery.of(context).size.height-appBar.preferredSize.height)* 0.4 for card and so on.
// 4. height:(MediaQuery.of(context).size.height-appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top)* 0.4  - this deducts the statusbar height as well.

// 2. Landscape mode

// issue - App's chart bar and overall orientation exceeds the height in landscape mode, thus app crashes.

// Solution 1 - Disable landscape mode in app

// use SystemChrome, it allows to set application wide or system wide settings.
// Lock the device orientation to potrait mode, and disable landscape mode.

// Solution 2 -make a toggle that allows to switch from chart mode to List mode.abstract

// 3. Modal
// issue - when we type in modal, we have to manually close the keyboard to enter other texts.

// ****************************** iOS Styles *******************************
//  for iOS - use CupertinoPageScaffold(child:) here for body,there is child, so pass the app body to child.

// use Cupertinonavigationbar instead of App bar. while doing so, dart is not able to find that
// appBar and CupertinoNavigation Bar are PreferredSize widgets.
// Therefore explicitly declare the type of appBar variable as PreferredSizeWidget.

// In mobile devices sometimes we have some extra reserved space for top notch or task manager at bottom, this spaces can't
// be used to render widgets.
// therefore wrap the body with SafeArea(), it ensures that everything is positioned within the provided boundaries.
