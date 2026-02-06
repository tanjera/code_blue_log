import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';

import 'drugs.dart';
import 'event.dart';
import 'log.dart';
import 'procedures.dart';
import 'utility.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Blue Log',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
      home: const Page(title: 'Code Blue Log'),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key, required this.title});

  final String title;

  @override
  State<Page> createState() => PageState();
}

class PageState extends State<Page> {
  Log log = Log();

  late Timer _timerUI;

  final Stopwatch _swCode = Stopwatch();
  String _btnCode = "Start Code";
  String _txtCode = "";

  final Stopwatch _swCPR = Stopwatch();
  String _btnCPR = "Start CPR";
  String _txtCPR = "";

  final Stopwatch _swShock = Stopwatch();
  String _txtShock = "";
  
  final Stopwatch _swEpi = Stopwatch();
  String _txtEpi = "";

  
  void endCode () {
    // Close out and reset the log
    log.add(Entry(type: EntryType.event, description: "Code ended"));
    log = Log();

    // Reset the stopwatches
    _swCode.stop();
    _swCode.reset();
    _swCPR.stop();
    _swCPR.reset();
    _swShock.stop();
    _swShock.reset();
    _swEpi.stop();
    _swEpi.reset();

    _txtCode = "--:--";
    _txtCPR = "--:--";
    _txtShock = "--:--";
    _txtEpi = "--:--";
  }

  void _pressedCode() {
    if (!_swCode.isRunning) {
      _swCode.start();
      log.add(Entry(type: EntryType.event, description: "Code started"));
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SheetCodeEnd(this);
        },
      );
    }

    updateUI();
  }

  void _pressedCPR() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swCPR.isRunning) {
      _swCPR.start();

      log.add(Entry(type: EntryType.cpr, description: "CPR started"));
    } else {
      _swCPR.stop();
      _swCPR.reset();

      log.add(Entry(type: EntryType.cpr, description: "CPR paused"));
    }

    updateUI();
  }

  void _pressedShock() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swShock.isRunning) {
      _swShock.start();
    } else {
      _swShock.reset();
    }

    log.add(Entry(type: EntryType.shock, description: "Shock delivered"));

    updateUI();
  }

  void pressedEpi() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swEpi.isRunning) {
      _swEpi.start();
    } else {
      _swEpi.reset();
    }

    log.add(Entry(type: EntryType.drug, description: "Epinephrine administered"));

    updateUI();
  }

  void updateUI() {
    setState(() {
      _txtCode = formatTimer(_swCode.isRunning, _swCode.elapsedMilliseconds ~/ 1000);
      _txtCPR = formatTimer(_swCPR.isRunning, _swCPR.elapsedMilliseconds ~/ 1000);
      _txtShock = formatTimer(_swShock.isRunning, _swShock.elapsedMilliseconds ~/ 1000);
      _txtEpi = formatTimer(_swEpi.isRunning, _swEpi.elapsedMilliseconds ~/ 1000);

      _btnCode = !_swCode.isRunning ? "Start Code" : "Stop Code";
      _btnCPR = !_swCPR.isRunning ? "Start CPR" : "Pause CPR";
    });
  }

  @override
  void initState() {
    super.initState();

    _timerUI = Timer.periodic(const Duration(seconds: 1), (_) {
      updateUI();
    });
  }

  @override
  void dispose() {
    _timerUI.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Padding (
              padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 10),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(   // Overall code time
                    children: [
                      Center(
                        child: Text(_txtCode,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                        onPressed: _pressedCode,
                        child: Text(_btnCode,
                            style: TextStyle(fontSize: 28)),
                      )
                    ],
                  ),

                  TableRow(   // CPR
                    children: [
                      Center(
                        child: Text(_txtCPR,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: _pressedCPR,
                          child: Text(_btnCPR,
                              style: TextStyle(fontSize: 24))
                      )
                    ],
                  ),

                  TableRow(   // Defibrillation
                    children: [
                      Center(
                        child: Text(_txtShock,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: _pressedShock,
                          child: Text("Shock",
                              style: TextStyle(fontSize: 24))
                      )
                    ],
                  ),

                  TableRow(   // Epinephrine
                    children: [
                      Center(
                        child: Text(_txtEpi,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.brown.shade400,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: pressedEpi,
                          child: Text("Epinephrine",
                              style: TextStyle(fontSize: 24))
                      )
                    ],
                  ),
                ]
              ),

            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (context) => PageDrugs(this)
                              )
                          );
                        },
                      child: Text("Drugs",
                          style: TextStyle(fontSize: 24))
                    ),
                  ),
                ]
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (context) => PageProcedures(this)
                                )
                            );
                          },
                          child: Text("Procedures",
                              style: TextStyle(fontSize: 24))
                      ),
                    ),
                  ]
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (context) => PageEvents(this)
                                )
                            );
                          },
                          child: Text("Events",
                              style: TextStyle(fontSize: 24))
                      ),
                    ),
                  ]
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Divider(height: 1.0)
            ),

            Text("Event Log",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                  },
                  children: log.entries.map((item) =>
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(item['occurred'])
                        ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(item['description']),
                        )
                      ]
                    )
                  ).toList(),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class SheetCodeEnd extends StatelessWidget {
  final PageState _pageState;

  const SheetCodeEnd(this._pageState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Are you sure you want to end the code?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: FilledButton(
                      style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                    onPressed: () { Navigator.pop(context); },
                    child: Text("No",
                        style: TextStyle(fontSize: 24))
                )
              ),
              Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                      onPressed: () {
                        _pageState.endCode();
                        Navigator.pop(context);
                      },
                    child: Text("Yes",
                        style: TextStyle(fontSize: 24))
                )
              ),
            ]
          )
        ]
      )
    );
  }
}