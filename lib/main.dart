import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

/// WOOO, STACK OVERFLOW.
/// Thanks to András Szepesházi: https://stackoverflow.com/questions/49393231/how-to-get-day-of-year-week-of-year-from-a-datetime-dart-object
/// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

/// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
  if (woy < 1) {
    woy = numOfWeeks(date.year - 1);
  } else if (woy > numOfWeeks(date.year)) {
    woy = 1;
  }
  return woy;
}

void main() {
  runApp(const GySupport());
}

class GySupport extends StatefulWidget {
  const GySupport({super.key});

  @override
  State<GySupport> createState() => _GySupportState();
}

class _GySupportState extends State<GySupport> {
  bool darkMode = false;

  void turnOnDark(bool v) {
    setState(() {
      darkMode = v;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiBet Support',
      theme: ThemeData(
          primarySwatch: Colors.red, brightness: darkMode ? Brightness.dark : Brightness.light),
      home: MyHomePage(title: 'TiBet Support', togFunc: turnOnDark),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final void Function(bool) togFunc;

  const MyHomePage({super.key, required this.title, required this.togFunc});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> devs = ['Morten', 'Eivind', 'Christian', 'Sindre'];
  bool darkMode = false;
  bool showList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(mainAxisSize: MainAxisSize.max, children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const Text('Important: ', style: TextStyle(fontWeight: FontWeight.bold)),
            Switch(
                value: darkMode,
                onChanged: (v) {
                  darkMode = v;
                  widget.togFunc(v);
                })
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const Text('Eivind Mode: ', style: TextStyle(fontWeight: FontWeight.bold)),
            Switch(value: showList, onChanged: (v) => setState(() => showList = v)),
          ]),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Support denne uken: ', style: TextStyle(fontSize: 20)),
                Text(devs[weekNumber(DateTime.now()) % devs.length],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
              (showList ? Text('Rekkefølge: ${devs.toString()}') : const Text('')),
            ]),
          )
        ]),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.warning),
            label: const Text('Trenger en utvikler til møte'),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Den heldige utvalgte er: ${devs[Random().nextInt(devs.length)]}')));
            }));
  }
}
