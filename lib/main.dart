import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';

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
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late Timer _timerUI;

  final Stopwatch _swCode = Stopwatch();
  String _btnCode = "";
  String _txtCode = "";

  void _startCode() {
    if (!_swCode.isRunning) {
      _swCode.start();
    }

    _updateUI();
  }

  void _updateUI() {
    setState(() {
      _txtCode = formatTime(_swCode.elapsedMilliseconds ~/ 1000);

      if (!_swCode.isRunning) {
        _btnCode = "Start";
      } else if (_swCode.isRunning){
        _btnCode = "Stop";
      }
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
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .center,
              spacing: 15,
            children: [
              Text(_txtCode,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              FilledButton(
                  onPressed: _startCode,
                  child: Text(_btnCode,
                    style: TextStyle(fontSize: 28))
              )
              ],
            )
          ],
        ),
      )
    );
  }
}
