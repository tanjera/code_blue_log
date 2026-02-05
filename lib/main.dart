import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';

import 'drug.dart';
import 'event.dart';
import 'procedure.dart';
import 'utility.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Log',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
      home: const Page(title: 'Code Log'),
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
  late Timer _timerUI;

  List<Event> _events = [];

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
    // Reset the event log & stopwatches
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

    _events = [];
  }

  void _pressedCode() {
    if (!_swCode.isRunning) {
      _swCode.start();
      _events.add(Event(type: EventType.Event, description: "Code started"));
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SheetCodeEnd(this);
        },
      );
    }

    _updateUI();
  }

  void _pressedCPR() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swCPR.isRunning) {
      _swCPR.start();

      _events.add(Event(type: EventType.CPR, description: "CPR started"));
    } else {
      _swCPR.stop();
      _swCPR.reset();

      _events.add(Event(type: EventType.CPR, description: "CPR paused"));
    }

    _updateUI();
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

    _events.add(Event(type: EventType.Shock, description: "Shock delivered"));

    _updateUI();
  }

  void _pressedEpi() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swEpi.isRunning) {
      _swEpi.start();
    } else {
      _swEpi.reset();
    }

    _events.add(Event(type: EventType.Drug, description: "Epinephrine administered"));

    _updateUI();
  }

  void _pressedDrugs() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SheetDrugs(this);
      },
    );
  }

  void _pressedProcedures() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SheetProcedures(this);
      },
    );
  }

  void _updateUI() {
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
      _updateUI();
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
                        style: FilledButton.styleFrom(backgroundColor: Colors.blue),
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
                          style: FilledButton.styleFrom(backgroundColor: Colors.blueGrey),
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
                          style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
                          style: FilledButton.styleFrom(backgroundColor: Colors.brown.shade400),
                          onPressed: _pressedEpi,
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
                      style: FilledButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: _pressedDrugs,
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
                          style: FilledButton.styleFrom(backgroundColor: Colors.blueGrey),
                          onPressed: _pressedProcedures,
                          child: Text("Procedures",
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
                  children: _events.map((item) =>
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

class SheetDrugs extends StatelessWidget {
  final PageState _pageState;

  final List<Drug> _drugs = [
    Drug("Atropine", "Atropine administered", Colors.purple),
    Drug("Epinephrine", "Epinephrine administered", Colors.brown.shade400),
  ];

  SheetDrugs(this._pageState, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:
      Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Drugs",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            Padding(
                padding: EdgeInsets.all(10),
                child: Divider(height: 1.0)
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _drugs.map((drug) =>
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: drug.color),
                          onPressed: () {
                            if (drug.button == "Epinephrine") {
                              _pageState._pressedEpi();
                            } else {
                              _pageState._events.add(Event( type: EventType.Drug, description: drug.log));
                            }
                            Navigator.pop(context);
                          },
                          child: Text(drug.button,
                              style: TextStyle(fontSize: 24))
                        ),
                      ),
                    ]
                  ),
                ),
              ).toList(),
            )
          ]
        )
      )
    );
  }
}


class SheetProcedures extends StatelessWidget {
  final PageState _pageState;
  
  final List<Procedure> _procedures = [
    Procedure("Intubation", "Intubated", Colors.blueGrey),
    Procedure("Intraosseous Line", "Intraosseous line placed", Colors.yellow.shade800),
  ];
  
  SheetProcedures(this._pageState, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:
      Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Procedures",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

          Padding(
              padding: EdgeInsets.all(10),
              child: Divider(height: 1.0)
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _procedures.map((procedure) =>
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: procedure.color),
                          onPressed: () {
                            _pageState._events.add(Event(type: EventType.Procedure, description: procedure.log));
                            Navigator.pop(context);
                          },
                          child: Text(procedure.button,
                              style: TextStyle(fontSize: 24))
                        ),
                      ),
                    ]
                  ),
                ),
              ).toList(),
            )
          ]
        )
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
                    onPressed: () { Navigator.pop(context); },
                    child: Text("No",
                        style: TextStyle(fontSize: 24))
                )
              ),
              Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
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