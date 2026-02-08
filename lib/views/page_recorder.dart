import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';


import 'page_drugs.dart';
import 'page_events.dart';
import 'page_procedures.dart';
import 'page_rhythms.dart';

import '../classes/log.dart';
import '../classes/log.entry.dart';
import '../classes/utility.dart';

class PageRecorder extends StatefulWidget {
  const PageRecorder({super.key, required this.title});

  final String title;

  @override
  State<PageRecorder> createState() => PageRecorderState();
}

class PageRecorderState extends State<PageRecorder> {
  String _version = "";
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

  PageRecorderState() {
    getVersion();
  }

  void getVersion () async {
    PackageInfo _pi = await PackageInfo.fromPlatform();

    setState(() {
      _version = "${_pi.version}";
    });
  }

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

    updateUI();
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
        title: Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            Align(
              alignment: .centerLeft,
              child:Text(widget.title)
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Align(
                alignment: .topRight,
                child: Text(_version,
                  style: TextStyle(fontSize: 12)),
              )
            )
          ]
        ),
          actions:
            <Widget> [
              IconButton(
                icon: const Icon(Icons.volume_off_outlined),
                tooltip: 'Metronome',
                onPressed: () {
                  ScaffoldMessenger.of( context,
                  ).showSnackBar(const SnackBar(content: Text('This feature has not been implemented yet, but will be implemented in a version in the near future!',
                    textAlign: TextAlign.center,)));
                },
              ),
              IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save Log',
              onPressed: () {
                log.write();

                ScaffoldMessenger.of( context,
                  ).showSnackBar(const SnackBar(content: Text('Event log written to local storage.',
                textAlign: TextAlign.center,)));
                },
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: 'Identifiers',
                onPressed: () {
                  ScaffoldMessenger.of( context,
                  ).showSnackBar(const SnackBar(content: Text('This feature has not been implemented yet, but will be implemented in a version in the near future!',
                    textAlign: TextAlign.center,)));
                },
              ),
          ]
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
                    Padding(padding: EdgeInsets.only(left: 5),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                        onPressed: _pressedCode,
                        child: Text(_btnCode,
                            style: TextStyle(fontSize: 24)),
                        )
                      )
                    ],
                  ),

                  TableRow(   // CPR
                    children: [
                      Center(
                        child: Text(_txtCPR,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: _pressedCPR,
                          child: Text(_btnCPR,
                              style: TextStyle(fontSize: 24))
                        )
                      )
                    ],
                  ),

                  TableRow(   // Defibrillation
                    children: [
                      Center(
                        child: Text(_txtShock,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: _pressedShock,
                          child: Text("Shock",
                              style: TextStyle(fontSize: 24))
                        )
                      )
                    ],
                  ),

                  TableRow(   // Epinephrine
                    children: [
                      Center(
                        child: Text(_txtEpi,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.brown.shade400,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: pressedEpi,
                          child: Text("Epinephrine",
                              style: TextStyle(fontSize: 24))
                        )
                      )
                    ],
                  ),

                  TableRow(   // Drugs & Rhythms
                    children: [
                      Padding(padding: EdgeInsets.only(right: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.pink,
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
                        )
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                          child: FilledButton(
                              style: FilledButton.styleFrom(backgroundColor: Colors.red.shade900,
                                  shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (context) => PageRhythms(this)
                                    )
                                );
                              },
                              child: Text("Rhythms",
                                  style: TextStyle(fontSize: 24))
                          )
                      ),
                    ],
                  ),

                  TableRow(   // Procedures & Events
                    children: [
                      Padding(padding: EdgeInsets.only(right: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.orange.shade900,
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
                        )
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.purple,
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
                        )
                      ),
                    ],
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
  final PageRecorderState _prs;

  const SheetCodeEnd(this._prs, {super.key});

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
                        _prs.endCode();
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